//
//  TransactionView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import KeychainAccess
import SwiftUI

struct TransactionView: View {
    @Binding var transaction: Transaction?
    @State var presentPlaces = false
    private let onTransactionChange: () -> Void
    private let formatter = PropertyFormatter(appLanguage: .current)
    private let storage = AppStorage(keychain: Keychain(), userDefaults: UserDefaults.standard)
    
    init(transaction: Binding<Transaction?>, onTransactionChange: @escaping () -> Void) {
        _transaction = transaction
        self.onTransactionChange = onTransactionChange
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { transaction = nil }, label: {
            Image(systemName: "xmark")
        })
    }
    
    @ViewBuilder
    var icon: some View {
        if let transaction = transaction {
            if let data = transaction.data,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                Image(uiImage: transaction.type.icon)
                    .resizable()
                    .foregroundColor(Color(Assets.secondary.color))
                    .frame(width: 24, height: 24, alignment: .center)
            }
        }
    }
    
    var body: some View {
        if let transaction = transaction {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 24) {
                        VStack(alignment: .center, spacing: 8) {
                            ZStack { icon }
                            .frame(width: 80, height: 80)
                            .background(Color(Assets.background.color))
                            .clipShape(Circle())
                            Text(transaction.name)
                                .font(.system(size: 24))
                            Text(transaction.description)
                                .font(.system(size: 16))
                                .foregroundColor(Color(Assets.gray2.color))
                        }
                        VStack(alignment: .center, spacing: 8) {
                            Text((formatter.string(from: .init(value: transaction.amount), configurator: .init(maximumFractionDigits: 2)) ?? String(transaction.amount)) + " ₸")
                                .font(.system(size: 32, weight: .bold))
                            Text(transaction.type.title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(Assets.secondary.color))
                                .frame(width: UIScreen.main.bounds.width - 24, height: 32)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(Assets.secondary.color), lineWidth: 1)
                                )
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L10n.transactionPlace.uppercased())
                                .font(.system(size: 14))
                                .padding(.horizontal)
                                .foregroundColor(Color(Assets.gray2.color))
                            if let placeId = transaction.placeId,
                               let place = storage.places.first(where: { ($0.id == placeId) })  {
                                PlaceView(place: place)
                                    .padding(.horizontal, 16)
                                    .shadow(color: Color(Assets.black.color).opacity(0.2), radius: 8, x: 0, y: 0)
                            } else {
                                EmptyView(icon: .system(name: "location.viewfinder"),
                                          title: L10n.coreNotFound,
                                          description: L10n.transactionNoPlace,
                                          actionTitle: L10n.transactionChoosePlace,
                                          action: { presentPlaces = true })
                            }
                        }
                        Spacer()
                    }
                }
                .edgesIgnoringSafeArea(.horizontal)
                .navigationBarTitle(formatter.string(from: transaction.createDate, configurator: .init(dateFormat: "dd MMMM yyyy, HH:mm")), displayMode: .inline)
                .navigationBarItems(leading: closeButton)
            }
            .padding(.top)
            .sheet(isPresented: $presentPlaces, onDismiss: {
                presentPlaces = false
            }) {
                PlacesView(viewState: .view, transaction: $transaction, presentPlaces: $presentPlaces, onTransactionChange: onTransactionChange)
            }
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: .constant(Transaction(name: "test", description: "test", amount: 1000, type: .card, createDate: Date(), placeId: nil)), onTransactionChange: {})
            .previewDevice("iPhone 11 Pro Max")
    }
}

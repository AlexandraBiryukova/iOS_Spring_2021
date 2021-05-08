//
//  TransactionView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

struct TransactionView: View {
    @Binding var transaction: Transaction?
    private let formatter = PropertyFormatter(appLanguage: .current)
    
    init(transaction: Binding<Transaction?>) {
        _transaction = transaction
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { transaction = nil }, label: {
            Image(systemName: "xmark")
        })
    }
    
    var body: some View {
        if let transaction = transaction {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 24) {
                        VStack(alignment: .center, spacing: 8) {
                            ZStack {
                                Image(uiImage: transaction.type.icon)
                                    .resizable()
                                    .foregroundColor(Color(Assets.secondary.color))
                                    .frame(width: 24, height: 24, alignment: .center)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color(Assets.background.color))
                            .clipShape(Circle())
                            Text(transaction.name)
                                .font(.system(size: 24))
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
                            Text("МЕСТО ТРАНЗАКЦИИ")
                                .font(.system(size: 14))
                                .padding(.horizontal)
                                .foregroundColor(Color(Assets.gray2.color))
                            if transaction.place == nil {
                                EmptyView(place: .constant($transaction.wrappedValue?.place))
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
        }
    }
}


struct EmptyView: View {
    @Binding var place: TransactionPlace?
    @State var presentPlaces = false
    
    init(place: Binding<TransactionPlace?>) {
        _place = place
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "location.viewfinder")
                .resizable()
                .frame(width: 56, height: 56)
                .foregroundColor(Color(Assets.gray2.color))
            Text("Здесь ничего нет")
                .foregroundColor(Color(Assets.gray2.color))
                .font(.system(size: 20, weight: .semibold))
            Text("Не указано место транзакции. Его можно выбрать из Ваших мест транзакций")
                .foregroundColor(Color(Assets.gray2.color))
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            SecondaryButton(title: "Выбрать место транзакции", color: Assets.primary, image: nil) {
                presentPlaces = true
            }.sheet(isPresented: $presentPlaces, onDismiss: { presentPlaces = false }) {
                PlacesView(viewState: .view, place: $place, presentPlaces: $presentPlaces)
            }
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionView(transaction: .constant(Transaction(name: "test", description: "test", amount: 1000, type: .card, createDate: Date(), place: nil)))
                .previewDevice("iPhone 11 Pro Max")
        }
    }
}

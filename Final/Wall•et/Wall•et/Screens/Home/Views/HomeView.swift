//
//  HomeView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    @State var transaction: Transaction? = nil
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(homeViewModel.banners) { banner in
                                BannerView(banner: banner)
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal)
                    }
                    Text("НЕДАВНИЕ ТРАНЗАКЦИИ")
                        .font(.system(size: 14))
                        .padding(.horizontal)
                        .foregroundColor(Color(Assets.gray2.color))
                    SecondaryButton(title: "Добавить транзакцию", color: Assets.secondary, image: "plus.circle", action: {
                        homeViewModel.addTransaction(transaction: .init(name: "testing", description: "testing", amount: 1234, type: .cash, createDate: Date(), place: nil))
                    })
                    HomeTransactionsView(transactions: $homeViewModel.transactions, didSelectTransaction: { selectedItem in
                        transaction = selectedItem
                    })
                    .frame(height: homeViewModel.transactionsHeight)
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.horizontal)
            .navigationBarTitle(L10n.tabHome, displayMode: .automatic)
        }
        .padding(.top)
        .sheet(isPresented: .constant($transaction.wrappedValue != nil), onDismiss: { transaction = nil }) {
            TransactionView(transaction: $transaction)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 11 Pro Max")
    }
}

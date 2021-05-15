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
    @State var presentTransactionCreate = false
    
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
                        presentTransactionCreate = true
                    })
                    .padding(.horizontal, 16)
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
        .sheet(isPresented: .constant(presentTransactionCreate || $transaction.wrappedValue != nil), onDismiss: {
                presentTransactionCreate = false
                transaction = nil
            homeViewModel.updatePlaces()
        }) {
            if presentTransactionCreate {
                TransactionCreateView(presentTransactionCreate: $presentTransactionCreate, onTransactionCreate: { transaction in
                    homeViewModel.addTransaction(transaction: transaction)
                })
            } else {
                TransactionView(transaction: $transaction) {
                    guard let transaction = $transaction.wrappedValue else { return }
                    homeViewModel.changeTransaction(transaction: transaction)
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 11 Pro Max")
    }
}

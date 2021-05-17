//
//  TransactionCreateView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/9/21.
//

import SwiftUI

struct TransactionCreateView: View {
    @Binding private var presentTransactionCreate: Bool
    @State private var presentAlert = false
    @State private var presentPicker = false
    @State private var transaction = Transaction()

    @State private var alert = UIAlertController()
    @State private var type: UIImagePickerController.SourceType?
    private let onTransactionCreate: (Transaction) -> Void
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    private var imagePickerService = ImagePickerService()
    
    init(presentTransactionCreate: Binding<Bool>, onTransactionCreate: @escaping (Transaction) -> Void) {
        _presentTransactionCreate = presentTransactionCreate
        self.onTransactionCreate = onTransactionCreate
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { presentTransactionCreate = false }, label: {
            Image(systemName: "xmark")
        })
    }
    
    var alertView: AlertView {
        AlertView(presentAlert: $presentAlert, alertViewController: alert)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(alignment: .center, spacing: 8) {
                        if let data = transaction.data,
                           let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .background(Color(Assets.background.color))
                                .clipShape(Circle())
                        }
                        SecondaryButton(title: L10n.transactionCreateChoosePhoto, color: Assets.primary, image: "photo.on.rectangle", action: {
                            alert = imagePickerService.presentImagePickerSourceTypesSelect { selectedType in
                                presentAlert = false
                                guard let selectedType = selectedType else { return }
                                imagePickerService.checkPermission(for: selectedType) { granted in
                                    if granted {
                                        type = selectedType
                                        presentPicker = true
                                    } else {
                                        alert = imagePickerService.presentPermissionDeniedAlert(sourceType: selectedType, completion: {
                                            presentAlert = false
                                        })
                                        presentAlert = true
                                    }
                                }
                            }
                            presentAlert = true
                        })
                        .padding(.horizontal, 16)
                        .frame(width: UIScreen.main.bounds.width)
                    }
                    VStack(alignment: .center, spacing: 12) {
                        AmountTextFieldView(amount: $transaction.amount)
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $transaction.name, placeholder: L10n.transactionCreateName)
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $transaction.description, placeholder: L10n.transactionCreateDescription)
                            .padding(.horizontal, 16)
                    }
                    VStack(alignment: .center, spacing: 12) {
                        PickerView(selectedItem: $transaction.type, items: TransactionType.allCases, title: L10n.transactionCreatePaymentType)
                            .padding(.horizontal, 16)
                        DateView(date: $transaction.createDate, title: L10n.transactionCreateDate, type: .date)
                            .padding(.horizontal, 16)
                        DateView(date: $transaction.createDate, title: L10n.transactionCreateTime, type: .hourAndMinute)
                            .padding(.horizontal, 16)
                    }
                    PrimaryButton(title: L10n.transactionCreateAdd, color: Assets.primary, image: nil, action: {
                        onTransactionCreate(transaction)
                        presentTransactionCreate = false
                    })
                    .disabled(transaction.amount <= 0 || transaction.name.isEmpty)
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                if $presentAlert.wrappedValue {
                    alertView
                }
            }
            .padding(.horizontal, 16)
            .navigationBarTitle(L10n.transactionCreateAddTransaction, displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }
        .padding(.top)
        .sheet(isPresented: $presentPicker, onDismiss: { }) {
            ImagePicker(image: .constant(nil), data: $transaction.data, sourceType: type)
        }
    }
}

struct TransactionCreateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionCreateView(presentTransactionCreate: .constant(false), onTransactionCreate: {_ in})
                .previewDevice("iPhone 11")
        }
    }
}

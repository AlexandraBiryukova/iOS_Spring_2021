//
//  PlaceDetailView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import SwiftUI

struct PlaceDetailView: View {
    enum ViewState {
        case create
        case edit
        
        var title: String {
            switch self {
            case .create:
                return "Добавить место транзакции"
            case .edit:
                return "Редактировать место"
            }
        }
        var actionTitle: String {
            self == .create ? "Добавить" : "Сохранить"
        }
    }
    
    @Binding private var showPlaceDetail: Bool
    @State private var place: TransactionPlace
    @State private var showWorkTime: Bool = false
    @State private var showAlert: Bool = false
    
    private let viewState: ViewState
    private let onPlaceEdit: (TransactionPlace) -> Void
    
    init(viewState: ViewState,
         showPlaceDetail: Binding<Bool>,
         place: State<TransactionPlace>,
         onPlaceEdit: @escaping (TransactionPlace) -> Void) {
        self.viewState = viewState
        _showPlaceDetail = showPlaceDetail
        _place = place
        self.onPlaceEdit = onPlaceEdit
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { showPlaceDetail = false }, label: {
            Image(systemName: "xmark")
        })
    }
    
    @ViewBuilder
    var icon: some View {
        Image(Assets.locationPin.name)
            .resizable()
            .frame(width: 80, height: 80, alignment: .center)
            .clipShape(Circle())
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    icon
                }
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .center, spacing: 12) {
                        BaseTextFieldView(text: $place.name, placeholder: "Название")
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $place.address, placeholder: "Адрес")
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $place.description, placeholder: "Дополнительное описание")
                            .padding(.horizontal, 16)
                    }
                    VStack(spacing: 12) {
                        PickerView(selectedItem: $place.category, items: FilterCategory.allCases, title: "Категория")
                            .padding(.horizontal, 16)
                        ToggleView(isEnabled: $place.isFavourite, title: "Добавить в избранное")
                            .padding(.horizontal, 16)
                    }
                    SelectView(isSelected: $showWorkTime, title: "ГРАФИК РАБОТЫ МЕСТА")
                        .padding(.horizontal, 16)
                    if $showWorkTime.wrappedValue {
                        VStack(spacing: 12) {
                            DateView(date: $place.openTime, title: "Время открытия", type: .hourAndMinute)
                                .padding(.horizontal, 16)
                            DateView(date: $place.closeTime, title: "Время закрытия", type: .hourAndMinute)
                                .padding(.horizontal, 16)
                        }
                    }
                    VStack(alignment: .center, spacing: 12) {
                        if viewState == .create {
                            SecondaryButton(title: "Зачем добавлять места транзакций?", color: Assets.primary, image: nil, action: {
                                showAlert = true
                            })
                            .padding(.horizontal, 16)
                        }
                        PrimaryButton(title: viewState.actionTitle, color: Assets.primary, image: nil, action: {
                            onPlaceEdit(place)
                            showPlaceDetail = false
                        })
                        .disabled(place.name.isEmpty)
                        .padding(.horizontal, 16)
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .padding(.horizontal, 16)
            .navigationBarTitle(viewState.title, displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }
        .padding(.top)
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Зачем добавлять места транзакций?"),
                  message: Text("С их помощью Вы сможете выявить, где больше всего Вы тратите свои деньги. Созданные Вами транзакции можно будет привязать к любому из мест."), dismissButton: .default(Text("Понятно")))
        })
    }
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(viewState: .create, showPlaceDetail: .constant(false), place: .init(wrappedValue: .init()), onPlaceEdit: {_ in})
    }
}

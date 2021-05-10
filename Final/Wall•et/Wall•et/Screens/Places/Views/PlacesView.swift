//
//  PlacesView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/8/21.
//

import SwiftUI

struct PlacesView: View {
    enum ViewState {
        case tab, view
    }
    
    private let viewState: ViewState
    private let onTransactionChange: () -> Void
    
    @ObservedObject private var placesViewModel = PlacesViewModel()
    @Binding private var transaction: Transaction?
    @Binding private var presentPlaces: Bool
    @State private var presentFilter: Bool = false
    
    init(viewState: ViewState,
         transaction: Binding<Transaction?> = .constant(nil),
         presentPlaces: Binding<Bool> = .constant(false),
         onTransactionChange: @escaping () -> Void) {
        self.viewState = viewState
        _transaction = transaction
        _presentPlaces = presentPlaces
        self.onTransactionChange = onTransactionChange
    }
    
    @ViewBuilder
    var closeButton: some View {
        if viewState == .view {
            Button(action: { presentPlaces = false }, label: {
                Image(systemName: "xmark")
            })
        }
    }
    
    @ViewBuilder
    var addButton: some View {
        if viewState == .tab {
            Button(action: { }, label: {
                Text("Добавить")
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 8) {
                    VStack {
                        HStack {
                            Text("Фильтр")
                                .foregroundColor(Color(Assets.primary.color))
                                .font(.system(size: 18, weight: .medium))
                            Spacer()
                            Image(systemName: "slider.vertical.3")
                                .resizable()
                                .foregroundColor(Color(Assets.primary.color))
                                .frame(width: 24, height: 24)
                        }.padding(.init(top: 12, leading: 24, bottom: 12, trailing: 24))
                        Rectangle()
                            .fill(Color(Assets.divider.color))
                            .frame(height: 0.5)
                            .padding(.leading, 24)
                        
                    }
                    .background(Color.white)
                    .onTapGesture {
                        presentFilter = true
                    }
                    if placesViewModel.places.isEmpty {
                        EmptyView(icon: .system(name: "mappin.and.ellipse"), title: "Здесь ничего нет", description: "На данный момент Вы не добавили ни одного места транзакции. Добавить их можно в соответствущем разделе приложения")
                    }
                    ForEach(placesViewModel.places) { place in
                            PlaceView(place: place)
                                .padding(.horizontal, 16)
                                .shadow(color: Color(Assets.black.color).opacity(0.2), radius: 8, x: 0, y: 0)
                                .onTapGesture {
                                    switch viewState {
                                    case .view:
                                        transaction?.place = place
                                        onTransactionChange()
                                        self.presentPlaces = false
                                    default:
                                        break
                                    }
                                }
                    }
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.horizontal)
            .navigationBarTitle(L10n.tabPlaces, displayMode: viewState == .tab ? .automatic : .inline)
            .navigationBarItems(leading: closeButton, trailing: addButton)
        }
        .padding(.top)
        .sheet(isPresented: $presentFilter, onDismiss: { presentFilter = false }) {
            FilterView(filterModel: placesViewModel.filterModel, presentFilter: $presentFilter, onFilterSelect: { filterModel in
                placesViewModel.filterModel = filterModel
                placesViewModel.getPlaces()
            })
        }
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView(viewState: .tab, onTransactionChange: {})
            .previewDevice("iPhone 11 Pro Max")
    }
}

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
    @State private var place: TransactionPlace?
    @State private var showPlaceDetail: Bool = false
    
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
            Button(action: {
                showPlaceDetail = true
                place = .init()
            }, label: {
                Text(L10n.transactionCreateAdd)
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 8) {
                    VStack {
                        HStack {
                            Text(L10n.coreFilter)
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
                        EmptyView(icon: .system(name: "mappin.and.ellipse"), title: L10n.coreNotFound, description: L10n.placesNoPlace)
                    } else {
                        ForEach(placesViewModel.places) { place in
                            PlaceView(place: place)
                                .padding(.horizontal, 16)
                                .shadow(color: Color(Assets.black.color).opacity(0.2), radius: 8, x: 0, y: 0)
                                .onTapGesture {
                                    switch viewState {
                                    case .view:
                                        transaction?.placeId = place.id
                                        onTransactionChange()
                                        self.presentPlaces = false
                                    default:
                                        showPlaceDetail = true
                                        self.place = place
                                    }
                                }.contextMenu {
                                    Button {
                                        switch viewState {
                                        case .view:
                                            transaction?.placeId = place.id
                                            onTransactionChange()
                                            self.presentPlaces = false
                                        default:
                                            showPlaceDetail = true
                                            self.place = place
                                        }
                                    } label: {
                                        Label(viewState == .view ? L10n.placesChoose : L10n.placeEdit,
                                              systemImage: "mappin.and.ellipse")
                                    }
                                    Button {
                                        placesViewModel.removePlace(place: place)
                                    } label: {
                                        Label(L10n.placesDelete, systemImage: "xmark.bin")
                                    }
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
        .sheet(isPresented: .constant($presentFilter.wrappedValue || $showPlaceDetail.wrappedValue), onDismiss: {
            presentFilter = false
            showPlaceDetail = false
            place = nil
        }) {
            if let place = $place.wrappedValue,
               $showPlaceDetail.wrappedValue {
                PlaceDetailView(viewState: placesViewModel.indexOf(place: place) == nil ? .create : .edit, showPlaceDetail: $showPlaceDetail, place: .init(initialValue: place), onPlaceEdit: { place in
                    placesViewModel.changePlace(place: place)
                })
            } else {
                FilterView(filterModel: placesViewModel.filterModel, presentFilter: $presentFilter, onFilterSelect: { filterModel in
                    placesViewModel.filterModel = filterModel
                    placesViewModel.getPlaces()
                })
            }
        }.onAppear(perform: {
            placesViewModel.getPlaces()
        })
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView(viewState: .tab, onTransactionChange: {})
            .previewDevice("iPhone 11 Pro Max")
    }
}

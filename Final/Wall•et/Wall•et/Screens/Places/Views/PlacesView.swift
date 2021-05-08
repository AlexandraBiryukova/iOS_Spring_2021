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
    @ObservedObject var homeViewModel = PlacesViewModel()
    @Binding var place: TransactionPlace?
    @Binding var presentPlaces: Bool
    
    init(viewState: ViewState, place: Binding<TransactionPlace?> = .constant(nil), presentPlaces: Binding<Bool> = .constant(false)) {
        self.viewState = viewState
        _place = place
        _presentPlaces = presentPlaces
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
            Button(action: { place = .init() }, label: {
                Text("Добавить")
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Фильтр")
                    ForEach(homeViewModel.places) { place in
                        Text(place.name ?? "")
                    }
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.horizontal)
            .navigationBarTitle(L10n.tabPlaces, displayMode: viewState == .tab ? .automatic : .inline)
            .navigationBarItems(leading: closeButton, trailing: addButton)
        }
        .padding(.top)
        .sheet(isPresented: .constant($place.wrappedValue != nil && viewState == .tab), onDismiss: { place = nil }) {
            TransactionView(transaction: .constant(nil))
        }
    }
}


struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView(viewState: .tab)
            .previewDevice("iPhone 11 Pro Max")
    }
}

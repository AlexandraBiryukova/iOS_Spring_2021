//
//  FilterView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import SwiftUI

enum TransactionsCount: String, Codable, PickerItem, CaseIterable {
    case none
    case zero = "0"
    case between0and10 = "1 - 10"
    case between10and25 = "11 - 25"
    case moreThan25 = "25>"
    
    var title: String {
        switch self {
        case .none:
            return "Любое"
        default:
            return self.rawValue
        }
    }
}

enum FilterCategory: String, Codable, PickerItem, CaseIterable {
    case products
    case clothes
    case none
    
    var title: String {
        switch self {
        case .none:
            return "Все"
        case .products:
            return "Еда и продукты"
        case .clothes:
            return "Одежда и обувь"
        }
    }
}

struct FilterModel {
    var count: TransactionsCount = .none
    var category: FilterCategory = .none
    var onlyFavourites = false
    var usingPeriod = false
    var startDate = Date()
    var endDate = Date()
}

struct FilterView: View {
    @State var filterModel: FilterModel
    @Binding var presentFilter: Bool
    private let onFilterSelect: (FilterModel) -> Void
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    
    init(filterModel: FilterModel, presentFilter: Binding<Bool>, onFilterSelect: @escaping (FilterModel) -> Void) {
        _filterModel = .init(initialValue: filterModel)
        _presentFilter = presentFilter
        self.onFilterSelect = onFilterSelect
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { presentFilter = false }, label: {
            Image(systemName: "xmark")
        })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        PickerView(selectedItem: $filterModel.category, items: FilterCategory.allCases, title: "Категория")
                            .padding(.horizontal, 16)
                        PickerView(selectedItem: $filterModel.count, items: TransactionsCount.allCases, title: "Количество транзакций")
                            .padding(.horizontal, 16)
                    }
                    SelectView(isSelected: $filterModel.usingPeriod, title: "ПЕРИОД ТРАНЗАКЦИЙ")
                        .padding(.horizontal, 16)
                    if $filterModel.usingPeriod.wrappedValue {
                        VStack(spacing: 12) {
                            DateView(date: $filterModel.startDate, title: "C какой даты", type: .date)
                                .padding(.horizontal, 16)
                            DateView(date: $filterModel.endDate, title: "До какой даты", type: .date)
                                .padding(.horizontal, 16)
                        }
                    }
                    VStack(alignment: .center, spacing: 12) {
                        SecondaryButton(title: "Cбросить", color: Assets.red, image: nil, action: {
                            filterModel = .init()
                            onFilterSelect(filterModel)
                        })
                        .padding(.horizontal, 16)
                        PrimaryButton(title: "Применить", color: Assets.primary, image: nil, action: {
                            onFilterSelect(filterModel)
                            presentFilter = false
                        })
                        .padding(.horizontal, 16)
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .padding(.horizontal, 16)
            .navigationBarTitle("Фильтр", displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }
        .padding(.top)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filterModel: .init(), presentFilter: .constant(false), onFilterSelect: {_ in })
    }
}

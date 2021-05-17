//
//  ProfileStatisticsView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/15/21.
//

import SwiftUI

struct ProfileStatisticsView: View {
    @Binding private var presentStatistics: Bool
    
    private let colors: [Color]
    private let points: [CGFloat]
    private let formatter = PropertyFormatter(appLanguage: .current)
    private var storage = AppStorage(keychain: .init(), userDefaults: .standard)
    
    init(presentStatistics: Binding<Bool>) {
        _presentStatistics = presentStatistics
        colors = storage.places.map { _ in Color(.sRGB, red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1) }
        let max = storage.places.map { $0.transactions.count }.max() ?? 0
        points = storage.places.map { CGFloat($0.transactions.count) / CGFloat(max) }
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { presentStatistics = false }, label: {
            Image(systemName: "xmark")
        })
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.profileTransactionPlaces)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(Assets.black.color))
                        ForEach(FilterCategory.allCases, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.title)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(Assets.gray2.color))
                                HStack {
                                    ProgressBar(value: .constant(Float(storage.places.filter { $0.category == category }.count) /
                                                                    Float(max(1, storage.places.count))))
                                    Text("\(storage.places.filter { $0.category == category }.count) из \(storage.places.count)")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(Assets.gray2.color))
                                        .frame(width: 80)
                                }
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.profilePlaceTransactions)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(Assets.black.color))
                        ProfileStatisticsGraphView(dataPoints: points, colors: colors)
                            .padding(.horizontal, 16)
                        VStack(alignment: .leading) {
                            ForEach(Array(storage.places.enumerated()), id: \.offset) { index, place in
                                HStack {
                                    Circle()
                                        .fill(colors.reversed()[index])
                                        .frame(width: 16, height: 16)
                                    Text(place.name + " - " + place.category.title)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(Assets.black.color))
                                    Text(L10n.profileTransactionsCount(place.transactions.count))
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(Color(Assets.gray3.color))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        Text(L10n.profilePaymentTypes)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(Assets.black.color))
                            .padding(.top, 24)
                    }
                    VStack(alignment: .center, spacing: 24) {
                        CircularProgressBar(max: Float(storage.transactions.count), part: Float(storage.transactions.filter { $0.type == .cash }.count))
                        HStack(spacing: 16) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                HStack {
                                    Circle()
                                        .fill(Color((type == .cash ? Assets.secondary : Assets.primary).color))
                                        .frame(width: 16, height: 16)
                                    Text(type.title)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color(Assets.black.color))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 16)
            .navigationBarTitle(L10n.profileStatistics, displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }
        .padding(.top)
    }
}

struct ProfileStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileStatisticsView(presentStatistics: .constant(true))
            .previewDevice("iPhone 11")
    }
}

struct CircularProgressBar: View {
    let max: Float
    let part: Float
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(lineWidth: 20.0)
                .foregroundColor(Color(Assets.primary.color))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(part/max, 1.0)))
                .stroke(lineWidth: 20.0)
                .foregroundColor(Color(Assets.secondary.color))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f / %0.f", part , (max - part)))
                .font(.largeTitle)
                .bold()
        }
        .frame(width: 200, height: 200)
    }
}

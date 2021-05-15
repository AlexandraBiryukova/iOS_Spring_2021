//
//  ProfileView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import KeychainAccess
import SwiftUI

struct ProfileView: View {
    @State private var profile: Profile
    @State private var presentInfo = false
    @State private var presentStatistics = false
    @State private var currentLanguage = AppLanguage.current
    @State private var rotateDegrees: Double = 0
    @State private var wasRotated = false
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    private let appStorage: AppStorage
    
    init() {
        appStorage = .init(keychain: Keychain(), userDefaults: UserDefaults.standard)
        _profile = .init(initialValue: appStorage.profile)
    }
    
    var icon: some View {
        var imageView: Image
        if wasRotated {
            imageView = Image(uiImage: .init())
        } else {
            if let image = profile.image {
                imageView = Image(uiImage: image)
            } else {
                imageView = Image(uiImage: Assets.launchBackground.image)
            }
        }
        
        return ZStack(alignment: .center) {
            imageView
                .resizable()
                .background(Color.white)
            if wasRotated {
                ZStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 4) {
                        if !(profile.firstName.isEmpty || profile.lastName.isEmpty) {
                            Text(profile.firstName + " " + profile.lastName)
                                .font(.system(size: 24))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                        Text(profile.login)
                            .font(.system(size: 16))
                            .foregroundColor(Color(Assets.gray2.color))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        if !profile.phoneNumber.isEmpty,
                           formatter.validatePhoneNumber(input: profile.phoneNumber) {
                            Text(formatter.formattedPhoneNumber(from: profile.phoneNumber) ?? "")
                                .font(.system(size: 16))
                                .foregroundColor(Color(Assets.gray2.color))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                        if !profile.email.isEmpty,
                           ValidationRule(title: "", pattern: EmailValidationPattern().pattern).check(profile.email) {
                            Text(profile.email)
                                .font(.system(size: 16))
                                .foregroundColor(Color(Assets.gray2.color))
                                .multilineTextAlignment(.center)
                                .truncationMode(.tail)
                                .lineLimit(2)
                        }
                    }
                    .background(Color.white)
                    .padding(.horizontal, 12)
                    .frame(width: 240, height: 240)
                }
                .rotation3DEffect(.degrees(rotateDegrees), axis: (x:0, y:-1, z:0))
                .background(Color.white)
            }
        }
        .frame(width: 240, height: 240)
        .clipShape(Circle())
        .shadow(color: Color(Assets.black.color).opacity(0.5), radius: 16, x: 0, y: 12)
        .overlay(Circle().stroke(LinearGradient(gradient: .init(colors: [Color(Assets.primary.color), Color(Assets.secondary.color)]), startPoint: .top, endPoint: .bottom), lineWidth: 8))
        .rotation3DEffect(.degrees(rotateDegrees), axis: (x:0, y:1, z:0))
        .onTapGesture {
            withAnimation(.linear(duration: 1)) {
                rotateDegrees += 90
            }
        }.onAnimationCompleted(for: rotateDegrees) {
            if rotateDegrees.remainder(dividingBy: 180) != 0 {
                withAnimation(.linear(duration: 1)) {
                    wasRotated.toggle()
                    rotateDegrees += 90
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 32) {
                VStack(alignment: .center, spacing: 8) {
                    icon
                        .padding(.top, 24)
                }
                VStack(alignment: .leading, spacing: 12) {
                    PickerView(selectedItem: .constant(Placeholder()), items: [], title: "Общая информация", icon: "rectangle.stack.person.crop"){
                        presentInfo = true
                    }
                    .padding(.horizontal, 16)
                    PickerView(selectedItem: .constant(Placeholder()), items: [], title: "Статистика", icon: "hourglass.bottomhalf.fill") {
                        presentStatistics = true
                    }
                    .padding(.horizontal, 16)
                    PickerView(selectedItem: $currentLanguage, items: [], title: "Язык", icon: "globe") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    .padding(.horizontal, 16)
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.horizontal)
            .navigationBarTitle(L10n.tabProfile, displayMode: .large)
        }
        .padding(.top)
        .sheet(isPresented: .constant($presentInfo.wrappedValue || $presentStatistics.wrappedValue), onDismiss: {
            presentInfo = false
            presentStatistics = false
            appStorage.updateProfile(profile: profile)
        }) {
            if presentInfo {
                ProfileInfoView(presentProfileInfo: $presentInfo, profile: $profile)
            } else {
                ProfileStatisticsView(presentStatistics: $presentStatistics)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone 11 Pro Max")
    }
}

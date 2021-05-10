//
//  ProfileView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/10/21.
//

import SwiftUI

struct ProfileView: View {
    @State private var profile = Profile()
    @State private var presentInfo = false
    @State private var currentLanguage = AppLanguage.current
    @State private var rotateDegrees: Double = 0
    @State private var wasRotated = false
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    
    var icon: some View {
        var imageView: Image
        if wasRotated {
            imageView = Image(uiImage: .init())
        } else {
            if let data = profile.data,
               let image = UIImage(data: data) {
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
                        }
                        Text(profile.login)
                            .font(.system(size: 16))
                            .foregroundColor(Color(Assets.gray2.color))
                        if !profile.phoneNumber.isEmpty,
                           formatter.validatePhoneNumber(input: profile.phoneNumber) {
                            Text(formatter.formattedPhoneNumber(from: profile.phoneNumber) ?? "")
                                .font(.system(size: 16))
                                .foregroundColor(Color(Assets.gray2.color))
                        }
                        if !profile.email.isEmpty,
                           ValidationRule(title: "", pattern: EmailValidationPattern().pattern).check(profile.email) {
                            Text(profile.email)
                                .font(.system(size: 16))
                                .foregroundColor(Color(Assets.gray2.color))
                        }
                    }.background(Color.white)
                }
                .rotation3DEffect(.degrees(rotateDegrees), axis: (x:0, y:-1, z:0))
                .background(Color.white)
            }
        }
        .frame(width: 240, height: 240)
        .clipShape(Circle())
        .shadow(color: Color(Assets.black.color).opacity(0.5), radius: 16, x: 0, y: 12)
        .overlay(Circle().stroke(Color(Assets.primary.color), lineWidth: 8))
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
        .sheet(isPresented: $presentInfo, onDismiss: {
            presentInfo = false
        }) {
            ProfileView()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone 11 Pro Max")
    }
}

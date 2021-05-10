//
//  ProfileInfoView.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/11/21.
//

import SwiftUI

struct ProfileInfoView: View {
    @Binding private var presentProfileInfo: Bool
    @Binding private var profile: Profile
    
    @State private var presentPicker = false
    @State private var presentAlert = false
    @State private var alert = UIAlertController()
    @State private var type: UIImagePickerController.SourceType?
    
    private let formatter = PropertyFormatter(appLanguage: .current)
    private var imagePickerService = ImagePickerService()
    
    init(presentProfileInfo: Binding<Bool>, profile: Binding<Profile>) {
        _presentProfileInfo = presentProfileInfo
        _profile = profile
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: { presentProfileInfo = false }, label: {
            Image(systemName: "xmark")
        })
    }
    
    var icon: some View {
        var imageView: Image
        if let data = profile.data,
           let image = UIImage(data: data) {
            imageView = Image(uiImage: image)
        } else {
            imageView = Image(Assets.profileAvatar.name)
        }
        return imageView
            .resizable()
            .frame(width: 120, height: 120)
            .background(Color(Assets.background.color))
            .clipShape(Circle())
    }
    
    
    var alertView: AlertView {
        AlertView(presentAlert: $presentAlert, alertViewController: alert)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(alignment: .center, spacing: 8) {
                        icon
                        SecondaryButton(title: "Изменить фото", color: Assets.primary, image: "photo.on.rectangle", action: {
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
                        PhoneNumberTextFieldView(value: $profile.phoneNumber)
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $profile.login, placeholder: "Логин")
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $profile.firstName, placeholder: "Имя")
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $profile.lastName, placeholder: "Фамилия")
                            .padding(.horizontal, 16)
                        BaseTextFieldView(text: $profile.email, placeholder: "E-mail")
                            .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                if $presentAlert.wrappedValue {
                    alertView
                }
            }
            .padding(.horizontal, 16)
            .navigationBarTitle("Общая информация", displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }
        .padding(.top)
        .sheet(isPresented: $presentPicker, onDismiss: { }) {
            ImagePicker(data: $profile.data, sourceType: type)
        }
    }
}

struct ProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoView(presentProfileInfo: .constant(true), profile: .constant(.init()))
            .previewDevice("iPhone 11")
    }
}

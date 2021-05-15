//
//  AppStorage.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/15/21.
//

import KeychainAccess
import Disk

private enum Constants: String {
    case phoneNumber = "phoneNumber"
    case image
    case login
    case email
    case firstName
    case lastName
    case transactions = "AppStorage/transactions.json"
    case places = "AppStorage/places.json"
}

final class AppStorage {
    var phoneNumber: String {
        get { (try? keychain.get(Constants.phoneNumber.rawValue)) ?? "" }
        set { updateValue(.phoneNumber, value: newValue) }
    }
    var login: String {
        get { (try? keychain.get(Constants.login.rawValue)) ?? "" }
        set { updateValue(.login, value: newValue) }
    }
    var email: String {
        get { (try? keychain.get(Constants.email.rawValue)) ?? "" }
        set { updateValue(.email, value: newValue) }
    }
    var firstName: String {
        get { (try? keychain.get(Constants.firstName.rawValue)) ?? "" }
        set { updateValue(.firstName, value: newValue) }
    }
    var lastName: String {
        get { (try? keychain.get(Constants.lastName.rawValue)) ?? "" }
        set { updateValue(.lastName, value: newValue) }
    }
    var image: UIImage? {
        get {
            guard let data = userDefaults.data(forKey: Constants.image.rawValue) else { return nil }
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data)
        }
        set { updateImage(newValue) }
    }
    
    var profile: Profile {
        .init(firstName: firstName, lastName: lastName, login: login, phoneNumber: phoneNumber, email: email, image: image)
    }
    
    var transactions: [Transaction] {
        get { (try? Disk.retrieve(Constants.transactions.rawValue, from: .caches, as: [Transaction].self)) ?? [] }
        set { try? Disk.save(newValue, to: .caches, as: Constants.transactions.rawValue) }
    }
    
    var places: [TransactionPlace] {
        get { ((try? Disk.retrieve(Constants.places.rawValue, from: .caches, as: [TransactionPlace].self)) ?? []).sorted(by: { $0.transactions.count > $1.transactions.count }) }
        set { try? Disk.save(newValue, to: .caches, as: Constants.places.rawValue) }
    }
    
    private let keychain: Keychain
    private let userDefaults: UserDefaults
    
    init(keychain: Keychain, userDefaults: UserDefaults) {
        self.keychain = keychain
        self.userDefaults = userDefaults
    }
    
    func updateProfile(profile: Profile) {
        login = profile.login
        phoneNumber = profile.phoneNumber
        email = profile.email
        firstName = profile.firstName
        lastName = profile.lastName
        image = profile.image
    }
    
    private func updateValue(_ key: Constants, value: String?) {
        if let value = value {
            try? keychain.set(value, key: key.rawValue)
        } else {
            try? keychain.remove(key.rawValue)
        }
    }
    
    private func updateImage(_ image: UIImage?) {
        if let image = image {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: false)
            userDefaults.setValue(data, forKey: Constants.image.rawValue)
        } else {
            userDefaults.removeObject(forKey: Constants.image.rawValue)
        }
    }
}

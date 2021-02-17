//
//  ContactViewModel.swift
//  Contacts Lab
//
//  Created by Alexandra Biryukova on 2/18/21.
//

import SwiftUI

enum Gender: String {
    case female
    case male
}

struct Contact: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var phoneNumber: String
    var gender: Gender
    
    var image: Image {
        Image(gender.rawValue)
    }
}

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
}

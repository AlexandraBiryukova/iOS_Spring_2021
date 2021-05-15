//
//  Profile.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 5/11/21.
//

import UIKit

struct Profile {
    var firstName: String = "Test"
    var lastName: String = "Testov"
    var login: String = "User\(Int.random(in: 0...100000))"
    var phoneNumber: String = ""
    var email: String = "test@gmail.com"
    var image: UIImage? = nil
}

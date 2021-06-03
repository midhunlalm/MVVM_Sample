//
//  Contact.swift
//  ContactApp
//
//  Created by Midhunlal M on 14/12/19.
//  Copyright © 2019 Midhunlal M. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var profilePic: String?
    var favorite: Bool = false
    var email: String?
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite = "favorite"
        case email = "email"
        case phoneNumber = "phone_number"
    }
}

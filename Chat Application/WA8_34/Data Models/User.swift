//
//  User.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import Foundation
import FirebaseFirestore

struct User {
    var id: String
    var email: String
    var name: String
    var profileImageURL: String?
    
    init(id: String, email: String, name: String, profileImageURL: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
    }
}

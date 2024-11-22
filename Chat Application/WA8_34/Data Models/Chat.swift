//
//  Chat.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/9/24.
//

import Foundation
import FirebaseFirestore

struct Chat {
    let id: String
    let friendId: String
    let friendName: String
    let friendEmail: String
    
    init(id: String, friendId: String, friendName: String, friendEmail: String) {
        self.id = id
        self.friendId = friendId
        self.friendName = friendName
        self.friendEmail = friendEmail
    }
}

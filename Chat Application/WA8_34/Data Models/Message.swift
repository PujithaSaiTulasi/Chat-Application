//
//  Messages.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/11/24.
//

import Foundation
import FirebaseFirestore

struct Message {
    let id: String
    let senderId: String
    let senderName: String
    let text: String
    let timestamp: Date
    
    init(id: String, senderId: String, senderName: String, text: String, timestamp: Date) {
        self.id = id
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.timestamp = timestamp
    }
}

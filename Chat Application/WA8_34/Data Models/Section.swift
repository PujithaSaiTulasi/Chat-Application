//
//  Section.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/15/24.
//

import Foundation

struct Section {
    let date: Date
    let title: String
    let messages: [Message]
    
    init(date: Date, title: String, messages: [Message]) {
        self.date = date
        self.title = title
        self.messages = messages
    }
}

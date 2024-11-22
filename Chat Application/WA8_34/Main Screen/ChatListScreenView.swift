//
//  ChatListScreenView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit

class ChatListScreenView: UIView {

    var floatingButtonStartChat: UIButton!
    var tableViewChatList: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupFloatingButtonStartChat()
        setupTableViewChatList()
        initConstraints()
    }
    
    func setupTableViewChatList(){
        tableViewChatList = UITableView()
        tableViewChatList.register(TableViewChatCell.self, forCellReuseIdentifier: Configs.tableViewChatList)
        tableViewChatList.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewChatList)
    }
    
    func setupFloatingButtonStartChat(){
        floatingButtonStartChat = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "ellipsis.message")
        var attributedTitle = AttributedString("Start chat")
        attributedTitle.font = .boldSystemFont(ofSize: 16)
        config.attributedTitle = attributedTitle
        config.imagePadding = 10
        floatingButtonStartChat.configuration = config
        floatingButtonStartChat.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonStartChat)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            tableViewChatList.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewChatList.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewChatList.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewChatList.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            floatingButtonStartChat.widthAnchor.constraint(equalToConstant: 150),
            floatingButtonStartChat.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonStartChat.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            floatingButtonStartChat.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

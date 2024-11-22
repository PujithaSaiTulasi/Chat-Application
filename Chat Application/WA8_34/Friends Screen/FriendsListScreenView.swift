//
//  FriendsListScreenView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit

class FriendsListScreenView: UIView {

    var tableViewFriendsList: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewFriendsList()
        initConstraints()
    }

    func setupTableViewFriendsList(){
        tableViewFriendsList = UITableView()
        tableViewFriendsList.register(FriendsListTableView.self, forCellReuseIdentifier: Configs.tableViewFriendsList)
        tableViewFriendsList.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewFriendsList)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            tableViewFriendsList.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableViewFriendsList.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewFriendsList.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewFriendsList.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

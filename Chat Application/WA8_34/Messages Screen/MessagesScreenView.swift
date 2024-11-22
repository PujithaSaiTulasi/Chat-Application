//
//  MessagesScreenView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/9/24.
//

import UIKit

class MessagesScreenView: UIView {

    var tableViewMessages: UITableView!
    var textFieldMessage: UITextField!
    var buttonSend: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTableViewMessages()
        setupTextFieldMessage()
        setupButtonSend()
        initConstraints()
        
    }
    
    func setupTableViewMessages(){
        tableViewMessages = UITableView()
        tableViewMessages.register(MessagesTableViewCell.self, forCellReuseIdentifier: Configs.tableViewMessages)
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMessages)
    }
    
    func setupTextFieldMessage(){
        textFieldMessage = UITextField()
        textFieldMessage.placeholder = "Text message"
        textFieldMessage.borderStyle = .roundedRect
        textFieldMessage.layer.cornerRadius = 20
        textFieldMessage.layer.masksToBounds = true
        textFieldMessage.backgroundColor = .systemGray6
        textFieldMessage.attributedPlaceholder = NSAttributedString(
            string: "Type your message!",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textFieldMessage.frame.height))
        textFieldMessage.leftView = paddingView
        textFieldMessage.leftViewMode = .always
        textFieldMessage.rightView = paddingView
        textFieldMessage.rightViewMode = .always
        
        textFieldMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldMessage)
    }
    
    func setupButtonSend() {
        buttonSend = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGreen
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "paperplane.circle.fill")
        config.imagePadding = 10
        buttonSend.configuration = config
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSend)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            tableViewMessages.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableViewMessages.bottomAnchor.constraint(equalTo: textFieldMessage.topAnchor, constant: -20),
            tableViewMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableViewMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            textFieldMessage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            textFieldMessage.trailingAnchor.constraint(equalTo: buttonSend.leadingAnchor, constant: -10),
            textFieldMessage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            textFieldMessage.heightAnchor.constraint(equalToConstant: 40),
            textFieldMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            buttonSend.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            buttonSend.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonSend.heightAnchor.constraint(equalToConstant: 40),
            buttonSend.widthAnchor.constraint(equalToConstant: 40),
                        
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

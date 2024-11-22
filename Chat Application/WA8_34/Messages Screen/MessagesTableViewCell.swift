//
//  MessagesTableViewCell.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/11/24.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    var labelMessage: UILabel!
    var labelMessageTime: UILabel!
    var labelSenderName: UILabel!
    var messageContainer: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupMessageContainer()
        setupLabelMessage()
        setupLabelMessageTime()
        setupSenderNameLabel()
        
        initConstraints()
    }
    
    func setupMessageContainer(){
        messageContainer = UIView()
        messageContainer.layer.borderColor = UIColor.white.cgColor
        messageContainer.layer.borderWidth = 1
        messageContainer.layer.cornerRadius = 10
        messageContainer.layer.shadowColor = UIColor.gray.cgColor
        messageContainer.layer.shadowOffset = .zero
        messageContainer.layer.shadowRadius = 6.0
        messageContainer.layer.shadowOpacity = 0.7
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageContainer)

    }
    
    func setupSenderNameLabel() {
        labelSenderName = UILabel()
        labelSenderName.font = UIFont.systemFont(ofSize: 14)
        labelSenderName.textColor = .white
        labelSenderName.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(labelSenderName)
    }
    
    func setupLabelMessage(){
        labelMessage = UILabel()
        labelMessage.font = UIFont.boldSystemFont(ofSize: 16)
        labelMessage.numberOfLines = 0
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(labelMessage)
    }
    
    func setupLabelMessageTime(){
        labelMessageTime = UILabel()
        labelMessageTime.font = UIFont.boldSystemFont(ofSize: 12)
        labelMessageTime.textColor = .white
        labelMessageTime.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(labelMessageTime)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([

            messageContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            messageContainer.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),

            labelSenderName.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 10),
            labelSenderName.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 10),
            
            labelMessage.topAnchor.constraint(equalTo: labelSenderName.bottomAnchor, constant: 10),
            labelMessage.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 10),
            labelMessage.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -10),

            labelMessageTime.leadingAnchor.constraint(equalTo: labelMessage.trailingAnchor, constant: 10),
            labelMessageTime.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -10),
            labelMessageTime.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -10),
            labelMessageTime.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with message: Message, isCurrentUser: Bool) {
        labelMessage.text = message.text
        labelSenderName.text = message.senderName
        
        let date = message.timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let formattedTime = formatter.string(from: date)
        labelMessageTime.text = formattedTime
        
        messageContainer.backgroundColor = isCurrentUser ? .systemBlue : .orange
        labelMessage.textColor = isCurrentUser ? .white : .white
        labelMessage.textAlignment = isCurrentUser ? .right : .left
        
        if isCurrentUser {
            NSLayoutConstraint.activate([
                messageContainer.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                messageContainer.leadingAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            ])
        } else {
            NSLayoutConstraint.activate([
                messageContainer.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                messageContainer.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            ])
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

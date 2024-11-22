//
//  MessagesScreenViewController.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/9/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MessagesScreenViewController: UIViewController {
    
    let messagesScreen = MessagesScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    let db = Firestore.firestore()
    
    var messages = [Message]()
    
    var sections: [Section] = []
    
    var chat: Chat?
    
    override func loadView() {
        view = messagesScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        messagesScreen.buttonSend.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messagesScreen.tableViewMessages.separatorStyle = .none
        messagesScreen.tableViewMessages.dataSource = self
        messagesScreen.tableViewMessages.delegate = self
        fetchAndSetFriendProfileImage()
        fetchMessages()
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
    @objc func onBackButtonTapped() {
        notificationCenter.post(name: Notification.Name("ReloadChatData"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func fetchAndSetFriendProfileImage() {
        guard let friendEmail = chat?.friendEmail else { return }
        
        db.collection("users").document(friendEmail).getDocument { document, error in
            if let error = error {
                self.setDefaultProfileImage()
                print("Error fetching user profile image: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists, let data = document.data(), let profileImageURL = data["profileImageURL"] as? String {
                self.loadProfileImage(from: profileImageURL) { image in
                    DispatchQueue.main.async {
                        self.updateProfileButton(with: image, isDefault: false)
                    }
                }
            }else{
                self.setDefaultProfileImage()
            }
        }
    }
    
    func setDefaultProfileImage(){
        let defaultImage = UIImage(systemName: "person.crop.circle")
        updateProfileButton(with: defaultImage, isDefault: true)
    }
    
    func loadProfileImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    func updateProfileButton(with image: UIImage?, isDefault: Bool) {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let backArrowImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        let backButton = UIBarButtonItem(image: backArrowImage, style: .plain, target: self, action: #selector(onBackButtonTapped))
        
        guard let image = image else { return }
        guard let friendName = chat?.friendName else {return}
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let circularImage = renderer.image { _ in
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).addClip()
            image.draw(in: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        
        let profileName = UIBarButtonItem(title: friendName, style: .plain, target: self, action: nil)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 22)]
        profileName.setTitleTextAttributes(attributes, for: .normal)
        profileName.tintColor = .black
        
        let profileButton:UIBarButtonItem!
        if isDefault {
            profileButton = UIBarButtonItem(image: circularImage, style: .plain, target: self, action: nil)
        }else{
            profileButton = UIBarButtonItem(image: circularImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        }
        navigationItem.leftBarButtonItems = [backButton, profileButton, profileName]
    }
    
    func groupMessagesByDate() -> [Section] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let grouped = Dictionary(grouping: messages) { message -> Date in
            calendar.startOfDay(for: message.timestamp)
        }
        
        return grouped.map { (key, value) in
            let sectionDate = key
            let firstMessageTimestamp = value.first?.timestamp ?? sectionDate

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            timeFormatter.amSymbol = "am"
            timeFormatter.pmSymbol = "pm"
            
            let title: String
            if sectionDate == today {
                title = timeFormatter.string(from: firstMessageTimestamp)
            } else if sectionDate == yesterday {
                title = "Yesterday  • \(timeFormatter.string(from: firstMessageTimestamp))"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, d MMM"
                title = "\(dateFormatter.string(from: firstMessageTimestamp))  • \(timeFormatter.string(from: firstMessageTimestamp))"
            }
            
            return Section(date: sectionDate, title: title, messages: value)
        }.sorted(by: { $0.date < $1.date })
    }

    
    func fetchMessages() {
        guard let chatId = chat?.id else { return }
        db.collection("chats").document(chatId).collection("messages").order(by: "timestamp").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            self.messages = documents.compactMap { doc in
                let data = doc.data()
                return Message(
                    id: doc.documentID,
                    senderId: data["senderId"] as! String,
                    senderName: data["senderName"] as! String,
                    text: data["text"] as! String,
                    timestamp: (data["timestamp"] as! Timestamp).dateValue()
                )
            }
            self.sections = self.groupMessagesByDate()
            self.messagesScreen.tableViewMessages.reloadData()
            self.scrollToBottom()
        }
    }
    
    @objc func sendMessage() {
        guard let text = messagesScreen.textFieldMessage.text, !text.isEmpty,
              let userId = Auth.auth().currentUser?.uid,
              let name = Auth.auth().currentUser?.displayName else { return }
        
        guard let chatId = chat?.id else { return }
        
        let messageRef = db.collection("chats").document(chatId).collection("messages").document()
        let message = Message(id: messageRef.documentID, senderId: userId, senderName: name, text: text, timestamp: Date())
        
        messageRef.setData([
            "senderId": message.senderId,
            "senderName": message.senderName,
            "text": message.text,
            "timestamp": Timestamp(date: message.timestamp)
        ]) { error in
            if error == nil {
                self.messagesScreen.textFieldMessage.text = ""
            }
        }
    }
    
    func scrollToBottom() {
        guard !sections.isEmpty else { return }
        let lastSection = sections.count - 1
        let lastRow = sections[lastSection].messages.count - 1
        guard lastRow >= 0 else { return }

        let indexPath = IndexPath(row: lastRow, section: lastSection)
        messagesScreen.tableViewMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

}

extension MessagesScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].messages.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.text = sections[section].title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.backgroundColor = .systemGray6
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 10
        titleLabel.layer.masksToBounds = true
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: (tableView.bounds.width - titleLabel.bounds.width) / 2, y: 0, width: titleLabel.bounds.width + 20, height: 25)
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessages, for: indexPath) as! MessagesTableViewCell
        let message = sections[indexPath.section].messages[indexPath.row]
        let isCurrentUser = message.senderId == Auth.auth().currentUser?.uid
        cell.configure(with: message, isCurrentUser: isCurrentUser)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! MessagesTableViewCell
//        cell.toggleSenderNameVisibility()
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
}

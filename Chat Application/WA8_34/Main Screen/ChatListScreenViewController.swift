//
//  ChatListScreenViewController.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatListScreenViewController: UIViewController {

    let chatListScreen = ChatListScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    let db = Firestore.firestore()
    
    var chatPartners = [(user: User, lastMessageTimestamp: Date?)]()
    
    override func loadView() {
        view = chatListScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Messages"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        view.bringSubviewToFront(chatListScreen.floatingButtonStartChat)
        chatListScreen.floatingButtonStartChat.addTarget(self, action: #selector(startNewChat), for: .touchUpInside)
        
        notificationCenter.addObserver(self, selector: #selector(reloadChatData), name: Notification.Name("ReloadChatData"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateProfileButtonImage(_:)), name: Notification.Name("ProfileImageUpdated"), object: nil)
        
        chatListScreen.tableViewChatList.separatorStyle = .none
        chatListScreen.tableViewChatList.delegate = self
        chatListScreen.tableViewChatList.dataSource = self
        
        fetchChatPartners()
        fetchAndSetProfileImage()
    }
    
    @objc func onProfileButtonTapped() {
        let profileViewController = ProfileScreenViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @objc func reloadChatData() {
        fetchChatPartners()
    }
       
    func setDefaultImage(){
        let image = UIImage(systemName: "person.crop.circle")
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let circularImage = renderer.image { _ in
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).addClip()
            image?.draw(in: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        let profileButton = UIBarButtonItem(image: circularImage, style: .plain, target: self, action: #selector(onProfileButtonTapped))
        navigationItem.rightBarButtonItem = profileButton
    }
    
    @objc func startNewChat() {
        let friendsListViewController = FriendsListScreenViewController()
        navigationController?.pushViewController(friendsListViewController, animated: true)
    }
    
    func fetchAndSetProfileImage() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        db.collection("users").document(currentUserEmail).getDocument { document, error in
            if let error = error {
                self.setDefaultImage()
                print("Error fetching user profile image: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists, let data = document.data(), let profileImageURL = data["profileImageURL"] as? String {
                self.loadProfileImage(from: profileImageURL) { image in
                    DispatchQueue.main.async {
                        self.updateProfileButton(with: image)
                    }
                }
            }else{
                self.setDefaultImage()
            }
        }
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
        
    func updateProfileButton(with image: UIImage?) {
        guard let image = image else { return }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
        let circularImage = renderer.image { _ in
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).addClip()
            image.draw(in: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        
        let profileButton = UIBarButtonItem(image: circularImage.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onProfileButtonTapped))
        profileButton.tintColor = .black
        navigationItem.rightBarButtonItem = profileButton
    }
    
    @objc func updateProfileButtonImage(_ notification: Notification) {
        if let userInfo = notification.userInfo, let updatedImage = userInfo["image"] as? UIImage {
            updateProfileButton(with: updatedImage)
        }
    }
    
    func fetchChatPartners() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        db.collection("users").document(currentUserEmail).collection("chats").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching chat partners: \(error.localizedDescription)")
                return
            }
            
            var fetchedChatPartners: [(user: User, lastMessageTimestamp: Date?)] = []
            let group = DispatchGroup()
            
            snapshot?.documents.forEach { document in
                let data = document.data()
                guard let friendId = data["friendId"] as? String,
                      let friendEmail = data["friendEmail"] as? String,
                      let friendName = data["friendName"] as? String else {
                    return
                }
                
                group.enter()
                
                let friendRef = self.db.collection("users").document(friendEmail)
                friendRef.getDocument { (doc, error) in
                    if let doc = doc, doc.exists, let data = doc.data() {
                        let profileImageURL = data["profileImageURL"] as? String
                        let friend = User(id: friendId, email: friendEmail, name: friendName, profileImageURL: profileImageURL)
                        
                        self.fetchLastMessage(friend: friend) { _, _, timestamp in
                            fetchedChatPartners.append((user: friend, lastMessageTimestamp: timestamp))
                            group.leave()
                        }
                    } else {
                        print("Error fetching profile image URL for \(friendEmail): \(error?.localizedDescription ?? "Unknown error")")
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.chatPartners = fetchedChatPartners.sorted { ($0.lastMessageTimestamp ?? Date.distantPast) > ($1.lastMessageTimestamp ?? Date.distantPast) }
                self.chatListScreen.tableViewChatList.reloadData()
            }
        }
    }

    func fetchLastMessage(friend: User, completion: @escaping (String, String, Date?) -> Void) {
        guard let currentUserName = Auth.auth().currentUser?.displayName else { return }
        let chatId = currentUserName < friend.name ? "\(currentUserName)_\(friend.name)" : "\(friend.name)_\(currentUserName)"
        let messagesRef = db.collection("chats").document(chatId).collection("messages")
        
        messagesRef.order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching latest message: \(error.localizedDescription)")
                completion("", "", nil)
                return
            }
            if let document = snapshot?.documents.first {
                let senderId = document["senderId"] as? String ?? "Unknown senderId"
                let text = document["text"] as? String ?? "No message"
                if let timestamp = document["timestamp"] as? Timestamp {
                    let date = timestamp.dateValue()
                    completion(senderId, text, date)
                } else {
                    completion(senderId, text, nil)
                }
                
            } else {
                completion("", "", nil)
            }
        }
    }
    
    func formattedTimestamp(from timestamp: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: timestamp, to: now)
        let dateFormatter = DateFormatter()
        
        if let hourDifference = components.hour, let minuteDifference = components.minute {
            if hourDifference == 0 {
                if minuteDifference == 0 {
                    return "Just now"
                } else {
                    return "\(minuteDifference) min"
                }
            }
        }

        if calendar.isDateInToday(timestamp) {
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            return dateFormatter.string(from: timestamp)
        }

        if calendar.isDateInYesterday(timestamp) {
            return "Yesterday"
        }

        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: timestamp)
    }

}

extension ChatListScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatPartners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewChatList, for: indexPath) as! TableViewChatCell
        cell.selectionStyle = .none
        let friend = chatPartners[indexPath.row].user
        cell.labelName?.text = friend.name
        
        if let profileImageURL = friend.profileImageURL, let url = URL(string: profileImageURL) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageViewProfile?.image = image
                        cell.imageViewProfile?.layer.cornerRadius = cell.imageViewProfile!.frame.size.width / 2
                        cell.imageViewProfile?.clipsToBounds = true
                    }
                } else {
                    print("Error loading profile image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            cell.imageViewProfile?.image = UIImage(systemName: "person.crop.circle")
            cell.imageViewProfile?.layer.cornerRadius = cell.imageViewProfile!.frame.size.width / 2
            cell.imageViewProfile?.clipsToBounds = true
        }
        
        fetchLastMessage(friend: friend) { (senderId, text, timestamp) in
            if let timestamp = timestamp {
                let formattedTime = self.formattedTimestamp(from: timestamp)
                cell.labelTime?.text = formattedTime
                
                if friend.id == senderId {
                    cell.labelText?.text = "\(friend.name): \(text)"
                }
                else {
                    cell.labelText?.text = "You: \(text)"
                }
                
            } else {
                cell.labelText?.text = "Texting with \(friend.name)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = chatPartners[indexPath.row].user
        guard let currentUserName = Auth.auth().currentUser?.displayName else { return }
        let chatId = currentUserName < friend.name ? "\(currentUserName)_\(friend.name)" : "\(friend.name)_\(currentUserName)"
        
        let messagesViewController = MessagesScreenViewController()
        messagesViewController.chat = Chat(id: chatId, friendId: friend.id, friendName: friend.name, friendEmail: friend.email)
        navigationController?.pushViewController(messagesViewController, animated: true)
    }
    
}

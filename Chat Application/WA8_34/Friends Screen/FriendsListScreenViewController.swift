//
//  FriendsListScreenViewController.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendsListScreenViewController: UIViewController {

    let friendsListScreen = FriendsListScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    let db = Firestore.firestore()
    
    var friends = [User]()
    
    override func loadView() {
        view = friendsListScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "New Conversation"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22) ]
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        friendsListScreen.tableViewFriendsList.separatorStyle = .none
        friendsListScreen.tableViewFriendsList.delegate = self
        friendsListScreen.tableViewFriendsList.dataSource = self
        
        fetchFriends()
        
    }
    
    func fetchFriends() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching friends: \(error.localizedDescription)")
                return
            }
            self.friends = snapshot?.documents.compactMap { document in
                let data = document.data()
                let email = data["email"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let id = data["uid"] as? String ?? ""
                let profileImageURL = data["profileImageURL"] as? String
                
                if email != currentUserEmail {
                    return User(id: id, email: email, name: name, profileImageURL: profileImageURL)
                } else {
                    return nil
                }
            } ?? []
            self.friendsListScreen.tableViewFriendsList.reloadData()
        }
    }
    
}

extension FriendsListScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewFriendsList, for: indexPath) as! FriendsListTableView
        let friend = friends[indexPath.row]
        cell.labelName?.text = friend.name
        cell.labelEmail?.text = friend.email
        
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
            cell.imageViewProfile?.image = UIImage(systemName: "person.circle")
            cell.imageViewProfile?.layer.cornerRadius = cell.imageViewProfile!.frame.size.width / 2
            cell.imageViewProfile?.clipsToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        startChat(with: friend)
    }
    
    func startChat(with friend: User) {
        guard let userId = Auth.auth().currentUser?.uid,
          let currentUserEmail = Auth.auth().currentUser?.email,
          let currentUserName = Auth.auth().currentUser?.displayName else { return }
        
        let chatId = currentUserName < friend.name ? "\(currentUserName)_\(friend.name)" : "\(friend.name)_\(currentUserName)"
        let currentUserChatRef = db.collection("users").document(currentUserEmail).collection("chats").document(chatId)
        let friendChatRef = db.collection("users").document(friend.email).collection("chats").document(chatId)
        let mainChatRef = db.collection("chats").document(chatId)

        mainChatRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.navigateToChat(with: chatId, friend: friend)
            } else {
                
                mainChatRef.setData([
                    "participants": [
                        ["id": userId, "name": currentUserName, "email": currentUserEmail],
                        ["id": friend.id, "name": friend.name, "email": friend.email]
                    ],
                    "createdAt": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        self.showAlert("Error", "Failed to create chat: \(error.localizedDescription)")
                        return
                    }
                    
                    currentUserChatRef.setData([
                        "chatId": chatId,
                        "friendId": friend.id,
                        "friendName": friend.name,
                        "friendEmail": friend.email
                    ])

                    friendChatRef.setData([
                        "chatId": chatId,
                        "friendId": userId,
                        "friendName": currentUserName,
                        "friendEmail": currentUserEmail
                    ])

                    self.navigateToChat(with: chatId, friend: friend)
                }
            }
        }
    }

    func navigateToChat(with chatId: String, friend: User) {
        let chat = Chat(id: chatId, friendId: friend.id, friendName: friend.name, friendEmail: friend.email)
        let messagesViewController = MessagesScreenViewController()
        messagesViewController.chat = chat
        navigationController?.pushViewController(messagesViewController, animated: true)
        
        notificationCenter.post(name: Notification.Name("ReloadChatData"), object: nil)
        
        if let navigationController = self.navigationController {
            let chatVC = navigationController.viewControllers.first { $0 is ChatListScreenViewController }
            navigationController.setViewControllers([chatVC, messagesViewController].compactMap { $0 }, animated: true)
        }
        
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

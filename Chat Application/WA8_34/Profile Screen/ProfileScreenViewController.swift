//
//  ProfileScreenViewController.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class ProfileScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let profileScreen = ProfileScreenView()
    
    let notificationCenter = NotificationCenter.default
    
    let db = Firestore.firestore()
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "My Profile"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22) ]
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        profileScreen.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture)))
        profileScreen.buttonLogout.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        loadProfileInfo()
 
    }
    
    func loadProfileInfo() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        profileScreen.labelName.text = currentUser.displayName
        profileScreen.labelEmail.text = currentUser.email
        
        let storageRef = Storage.storage().reference(withPath: "profile_pictures/\(currentUser.uid).jpg")
        storageRef.downloadURL { url, error in
            guard let url = url, error == nil else { return }
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.profileScreen.profileImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    @objc func changeProfilePicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage,
              let currentUser = Auth.auth().currentUser,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else { return }
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        profileScreen.profileImageView.image = selectedImage
        
        notificationCenter.post(name: Notification.Name("ProfileImageUpdated"), object: nil, userInfo: ["image": selectedImage])
        
        let storageRef = Storage.storage().reference(withPath: "profile_pictures/\(currentUser.uid).jpg")
    
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload profile picture: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let url = url, error == nil else {
                    print("Failed to get download URL: \(error?.localizedDescription ?? "No error description")")
                    return
                }
                
                self.db.collection("users").document(currentUserEmail).updateData(["profileImageURL": url.absoluteString]) { error in
                    if let error = error {
                        print("Failed to save profile image URL to Firestore: \(error.localizedDescription)")
                    } else {
                        print("Profile image URL saved successfully to Firestore.")
                    }
                }
            }
        }
    }
    
    static func removeToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "authToken")
        defaults.synchronize()
    }
    
    @objc func logout() {
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                let loginViewController = ViewController()
                let navController = UINavigationController(rootViewController: loginViewController)
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = navController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            } catch {
                print("Error occurred: \(error.localizedDescription)")
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(logoutAlert, animated: true)
    }
}

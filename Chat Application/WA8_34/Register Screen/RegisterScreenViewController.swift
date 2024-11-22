//
//  RegisterScreenViewController.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterScreenViewController: UIViewController {

    let registerScreen = RegisterScreenView()
    let db = Firestore.firestore()
    var isRegistrationInProgress = false
    
    override func loadView() {
        view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        registerScreen.chatImage.image = UIImage(named: "chat.png")
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        registerScreen.buttonLogin.addTarget(self, action: #selector(onButtonLoginTapped), for: .touchUpInside)
        registerScreen.buttonRegister.addTarget(self, action: #selector(onButtonRegisterTapped), for: .touchUpInside)
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
    @objc func onButtonLoginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onButtonRegisterTapped() {
        registerUser()
    }
    
    @objc func registerUser() {
        guard let name = registerScreen.textFieldName.text, !name.isEmpty,
              let email = registerScreen.textFieldEmail.text, !email.isEmpty,
              let password = registerScreen.textFieldPassword.text, !password.isEmpty,
              let confirmPassword = registerScreen.textFieldConfirmPassword.text, !confirmPassword.isEmpty else {
            showAlert("Missing Fields", "Please fill in all fields.")
            return
        }
        
        if !isValidEmail(email) {
           showAlert("Invalid Email", "Please enter a valid email address.")
           return
        }
        
        guard password == confirmPassword else {
            showAlert("Invalid Password", "Passwords do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert("Registration failed", "\(error.localizedDescription)")
            } else if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        self.showAlert("Failed to set display name", "\(error.localizedDescription)")
                        return
                    }

                    self.db.collection("users").document(email.lowercased()).setData([
                        "name": name,
                        "email": email.lowercased(),
                        "password": password,
                        "uid": user.uid
                    ]) { error in
                        if let error = error {
                            self.showAlert("Failed to save user data", "\(error.localizedDescription)")
                        } else {
                            do {
                                
                                try Auth.auth().signOut()
                                self.navigationController?.popViewController(animated: true)
                            } catch let signOutError as NSError {
                                self.showAlert("Sign Out Error", signOutError.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

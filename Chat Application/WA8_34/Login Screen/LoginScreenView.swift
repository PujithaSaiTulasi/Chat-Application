//
//  LoginScreenView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit

class LoginScreenView: UIView {

    var contentWrapper:UIScrollView!
    var chatImage:UIImageView!
    var labelEmail:UILabel!
    var textFieldEmail:UITextField!
    var labelPassword:UILabel!
    var textFieldPassword:UITextField!
    var buttonRegister:UIButton!
    var labelDontHaveAccount:UILabel!
    var buttonLogin:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupChatImage()
        setupLabelEmail()
        setupLabelPassword()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupLabelDontHaveAccount()
        setupButtonRegister()
        setupButtonLogin()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupChatImage(){
        chatImage = UIImageView()
        chatImage.contentMode = .scaleAspectFit
        chatImage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(chatImage)
    }
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.text = "Email"
        labelEmail.font = UIFont.boldSystemFont(ofSize: 16)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelEmail)
    }
    
    func setupTextFieldEmail(){
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Enter Email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldEmail)
    }
    
    func setupLabelPassword(){
        labelPassword = UILabel()
        labelPassword.text = "Password"
        labelPassword.font = UIFont.boldSystemFont(ofSize: 16)
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelPassword)
    }
    
    func setupTextFieldPassword(){
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Enter Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldPassword)
    }
    
    func setupLabelDontHaveAccount(){
        labelDontHaveAccount = UILabel()
        labelDontHaveAccount.text = "Don't have an account?"
        labelDontHaveAccount.font = UIFont.boldSystemFont(ofSize: 16)
        labelDontHaveAccount.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDontHaveAccount)
    }
    
    func setupButtonLogin() {
        buttonLogin = UIButton(type: .system)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonLogin.setTitle("Login", for: .normal)
        
        buttonLogin.backgroundColor = .black
        buttonLogin.setTitleColor(.white, for: .normal)
        
        buttonLogin.layer.cornerRadius = 5
        buttonLogin.clipsToBounds = true

        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonLogin)
    }

    
    func setupButtonRegister(){
        buttonRegister = UIButton(type: .system)
        buttonRegister.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonRegister)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            chatImage.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 50),
            chatImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            chatImage.widthAnchor.constraint(equalToConstant: 100),
            chatImage.heightAnchor.constraint(equalToConstant: 100),
            
            labelEmail.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 50),
            labelEmail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            labelEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            textFieldEmail.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 10),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            labelPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 50),
            labelPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            labelPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 10),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 50),
            buttonLogin.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            buttonLogin.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            labelDontHaveAccount.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 20),
            labelDontHaveAccount.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            
            buttonRegister.centerYAnchor.constraint(equalTo: labelDontHaveAccount.centerYAnchor),
            buttonRegister.leadingAnchor.constraint(equalTo: labelDontHaveAccount.trailingAnchor, constant: 10),
            buttonRegister.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
              
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


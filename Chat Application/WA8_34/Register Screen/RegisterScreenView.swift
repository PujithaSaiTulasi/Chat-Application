//
//  RegisterScreenView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit

class RegisterScreenView: UIView {

    var contentWrapper:UIScrollView!
    var chatImage:UIImageView!
    var labelName:UILabel!
    var textFieldName:UITextField!
    var labelEmail:UILabel!
    var textFieldEmail:UITextField!
    var labelPassword:UILabel!
    var textFieldPassword:UITextField!
    var labelConfirmPassword:UILabel!
    var textFieldConfirmPassword:UITextField!
    var buttonRegister:UIButton!
    var labelAlreadyHaveAccount:UILabel!
    var buttonLogin:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupChatImage()
        setupLabelName()
        setupLabelEmail()
        setupLabelPassword()
        setupLabelConfirmPassword()
        setupTextFieldName()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupTextFieldConfirmPassword()
        setupButtonRegister()
        setupLabelAlreadyHaveAccount()
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
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.text = "Name"
        labelName.font = UIFont.boldSystemFont(ofSize: 16)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelName)
    }
    
    func setupTextFieldName(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Enter Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldName)
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
    
    func setupLabelConfirmPassword(){
        labelConfirmPassword = UILabel()
        labelConfirmPassword.text = "Confirm Password"
        labelConfirmPassword.font = UIFont.boldSystemFont(ofSize: 16)
        labelConfirmPassword.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelConfirmPassword)
    }
    
    func setupTextFieldConfirmPassword(){
        textFieldConfirmPassword = UITextField()
        textFieldConfirmPassword.placeholder = "Enter your password again"
        textFieldConfirmPassword.borderStyle = .roundedRect
        textFieldConfirmPassword.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldConfirmPassword)
    }
    
    func setupButtonRegister() {
        buttonRegister = UIButton(type: .system)
        buttonRegister.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonRegister.setTitle("Register", for: .normal)
        
        buttonRegister.backgroundColor = .black
        buttonRegister.setTitleColor(.white, for: .normal)
        
        buttonRegister.layer.cornerRadius = 5
        buttonRegister.clipsToBounds = true

        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonRegister)
    }
    
    func setupLabelAlreadyHaveAccount(){
        labelAlreadyHaveAccount = UILabel()
        labelAlreadyHaveAccount.text = "Already have an account?"
        labelAlreadyHaveAccount.font = UIFont.boldSystemFont(ofSize: 16)
        labelAlreadyHaveAccount.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelAlreadyHaveAccount)
    }
    
    func setupButtonLogin(){
        buttonLogin = UIButton(type: .system)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonLogin.setTitle("Log In", for: .normal)
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonLogin)
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
            
            labelName.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 50),
            labelName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            labelName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            textFieldName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            labelEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 30),
            labelEmail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            labelEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            textFieldEmail.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 10),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            labelPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 30),
            labelPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            labelPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            textFieldPassword.topAnchor.constraint(equalTo: labelPassword.bottomAnchor, constant: 10),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            labelConfirmPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 30),
            labelConfirmPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            labelConfirmPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            textFieldConfirmPassword.topAnchor.constraint(equalTo: labelConfirmPassword.bottomAnchor, constant: 10),
            textFieldConfirmPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            textFieldConfirmPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            buttonRegister.topAnchor.constraint(equalTo: textFieldConfirmPassword.bottomAnchor, constant: 50),
            buttonRegister.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            buttonRegister.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            
            labelAlreadyHaveAccount.topAnchor.constraint(equalTo: buttonRegister.bottomAnchor, constant: 15),
            labelAlreadyHaveAccount.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            
            buttonLogin.centerYAnchor.constraint(equalTo: labelAlreadyHaveAccount.centerYAnchor),
            buttonLogin.leadingAnchor.constraint(equalTo: labelAlreadyHaveAccount.trailingAnchor, constant: 10),
            buttonLogin.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
              
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

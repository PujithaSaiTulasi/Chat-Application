//
//  ProfileScreenView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/12/24.
//

import UIKit

class ProfileScreenView: UIView {

    var contentWrapper:UIScrollView!
    var profileImageView:UIImageView!
    var labelName:UILabel!
    var labelEmail:UILabel!
    var buttonLogout:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupProfileImageView()
        setupLabelName()
        setupLabelEmail()
        setupButtonLogout()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupProfileImageView(){
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50 
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        profileImageView.tintColor = .gray
        profileImageView.isUserInteractionEnabled = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(profileImageView)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.text = "Name"
        labelName.font = UIFont.boldSystemFont(ofSize: 24)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelName)
    }
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.text = "Email"
        labelEmail.font = UIFont.boldSystemFont(ofSize: 18)
        labelEmail.textColor = .gray
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelEmail)
    }
    
    func setupButtonLogout() {
        buttonLogout = UIButton(type: .system)
        buttonLogout.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonLogout.setTitle("Logout", for: .normal)
        
        buttonLogout.backgroundColor = .black
        buttonLogout.setTitleColor(.white, for: .normal)
        
        buttonLogout.layer.cornerRadius = 5
        buttonLogout.clipsToBounds = true

        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonLogout)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 50),
            profileImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            labelName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            labelName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 20),
            labelEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            buttonLogout.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 50),
            buttonLogout.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonLogout.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),
            buttonLogout.widthAnchor.constraint(equalToConstant: 100),
              
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

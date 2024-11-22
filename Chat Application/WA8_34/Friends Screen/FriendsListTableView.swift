//
//  FriendsListTableView.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit

class FriendsListTableView: UITableViewCell {

    var wrapperCellView: UIView!
    var imageViewProfile: UIImageView!
    var labelName: UILabel!
    var labelEmail: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupWrapperCellView()
        setupimagePhoto()
        setupLabelName()
        setupLabelEmail()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.layer.borderColor = UIColor.gray.cgColor
        wrapperCellView.layer.borderWidth = 1
        wrapperCellView.layer.cornerRadius = 10
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 6.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupimagePhoto(){
        imageViewProfile = UIImageView()
        imageViewProfile.image = UIImage(systemName: "person.circle.fill")
        imageViewProfile.contentMode = .scaleToFill
        imageViewProfile.clipsToBounds = true
        imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageViewProfile)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
    }
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.font = UIFont.boldSystemFont(ofSize: 16)
        labelEmail.textColor = .purple
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelEmail)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            imageViewProfile.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 15),
            imageViewProfile.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 15),
            imageViewProfile.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -15),
            imageViewProfile.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            imageViewProfile.heightAnchor.constraint(equalToConstant: 50),
            imageViewProfile.widthAnchor.constraint(equalToConstant: 55),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 15),
            labelName.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 20),
            labelName.heightAnchor.constraint(equalToConstant: 25),
            
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            labelEmail.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 20),
            labelEmail.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -15),
            labelEmail.heightAnchor.constraint(equalToConstant: 20),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 85)
        ])
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

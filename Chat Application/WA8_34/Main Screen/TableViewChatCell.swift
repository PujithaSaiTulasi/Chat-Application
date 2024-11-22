//
//  TableViewChatCell.swift
//  WA8_34
//
//  Created by Pujitha Sai Tulasi Muddhu on 11/8/24.
//

import UIKit

class TableViewChatCell: UITableViewCell {

    var wrapperCellView: UIView!
    var imageViewProfile: UIImageView!
    var labelName: UILabel!
    var labelText: UILabel!
    var labelTime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupimagePhoto()
        setupLabelName()
        setupLabelText()
        setupLabelTime()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
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
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = UIFont.boldSystemFont(ofSize: 14)
        labelText.textColor = .gray
        labelText.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelText)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.font = UIFont.boldSystemFont(ofSize: 12)
        labelTime.textColor = .gray
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            imageViewProfile.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 5),
            imageViewProfile.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 5),
            imageViewProfile.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -5),
            imageViewProfile.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            imageViewProfile.heightAnchor.constraint(equalToConstant: 50),
            imageViewProfile.widthAnchor.constraint(equalToConstant: 55),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 5),
            labelName.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 20),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            
            labelText.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 5),
            labelText.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 20),
            labelText.heightAnchor.constraint(equalToConstant: 15),
            labelText.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),
            
            labelTime.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            labelTime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelTime.heightAnchor.constraint(equalToConstant: 15),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 65)
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

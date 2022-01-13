//
//  ContentsCell.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import SDWebImage

class ContentsCell: UITableViewCell {

    static let identifier = "ContentsCell"
    var titleLabel = STTitleLabel(textAlignment: .left, fontSize: 12)
    var subTitleLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
    var urlToImageView = STImageView(frame: .zero)
    var userNameLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(newsContentsModel:NewsContentsModel){
        urlToImageView.sd_setImage(with: URL(string: newsContentsModel.urlToImage!))
        titleLabel.text = newsContentsModel.title
        
        layoutUIForNews()
    }
    
    func configureContents(contentsModel:ContentsModel){
        
        urlToImageView.sd_setImage(with: URL(string: (contentsModel.userModel?.profileImageURL)!))
        userNameLabel.text = contentsModel.userModel?.userName
        titleLabel.text = contentsModel.title
        subTitleLabel.text = contentsModel.body
        
        print(contentsModel.title,contentsModel.body)
        layoutUIForTimeline()
    }
    
    func layoutUIForTimeline(){
        addSubview(urlToImageView)
        addSubview(userNameLabel)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding/2),
            urlToImageView.widthAnchor.constraint(equalToConstant: 50),
            urlToImageView.heightAnchor.constraint(equalToConstant: self.frame.height - padding),
            
            userNameLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            userNameLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width - urlToImageView.frame.size.width - padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: padding),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding)
            
            
            
        ])
        
    }

    func layoutUIForNews(){
        addSubview(urlToImageView)
        addSubview(titleLabel)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding/2),
            urlToImageView.widthAnchor.constraint(equalToConstant: 50),
            urlToImageView.heightAnchor.constraint(equalToConstant: self.frame.height - padding),
       

            titleLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding)

        ])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

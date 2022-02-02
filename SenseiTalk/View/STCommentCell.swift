//
//  STCommentCell.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/17.
//

import UIKit

class STCommentCell: UITableViewCell {

    static let identifier = "STCommentCell"
    var urlToImageView = STImageView(frame: .zero)
    var userNameLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
    var titleLabel = STTitleLabel(textAlignment: .left, fontSize: 12)
    var footerBaseView = STFooterView()
    let footerView = STFooterView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func configure(commentModel:CommentContent,footerView:STFooterView){
        
        footerBaseView = footerView
        urlToImageView.sd_setImage(with: URL(string: (commentModel.userModel?.profileImageURL)!))
        userNameLabel.text = commentModel.userModel?.userName
        titleLabel.text = commentModel.comment
        
        footerBaseView.backgroundColor = .yellow
        footerBaseView.translatesAutoresizingMaskIntoConstraints = false
        layoutUIForTimeline(footerView:footerBaseView)
    }
    
    
    //footerViewをセル内に移植
    func configure(commentModel:CommentContent){
        urlToImageView.sd_setImage(with: URL(string: (commentModel.userModel?.profileImageURL)!))
        userNameLabel.text = commentModel.userModel?.userName
        titleLabel.text = commentModel.comment
        footerView.configureForComment()
        footerView.backgroundColor = .white
        footerView.translatesAutoresizingMaskIntoConstraints = false
        layoutUIForTimeline(footerView:footerView)
    }
    
    func layoutUIForTimeline(footerView:STFooterView){
        addSubview(urlToImageView)
        addSubview(userNameLabel)
        addSubview(titleLabel)
        addSubview(footerView)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding/2),
            urlToImageView.widthAnchor.constraint(equalToConstant: 50),
            urlToImageView.heightAnchor.constraint(equalToConstant: 50),

            userNameLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            userNameLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width - urlToImageView.frame.size.width - padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: urlToImageView.bottomAnchor,constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
//            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -40),

            footerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            footerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 40),
            footerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        ])
    }
    
    func layoutUI(){
        addSubview(urlToImageView)
        addSubview(userNameLabel)
        addSubview(titleLabel)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding/2),
            urlToImageView.widthAnchor.constraint(equalToConstant: 50),
            urlToImageView.heightAnchor.constraint(equalToConstant: 50),

            userNameLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            userNameLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width - urlToImageView.frame.size.width - padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: urlToImageView.bottomAnchor,constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
        ])

        
        
    }

    
}

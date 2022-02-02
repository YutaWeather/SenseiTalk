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
    var tapGesture = UITapGestureRecognizer()
    var footerView = STFooterView()
    var backView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureContents(contentsModel:ContentsModel){
        footerView.configureForTimeLine()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        urlToImageView.sd_setImage(with: URL(string: (contentsModel.userModel?.profileImageURL)!))
        urlToImageView.isUserInteractionEnabled = true
        urlToImageView.addGestureRecognizer(tapGesture)
        userNameLabel.text = contentsModel.userModel?.userName
        titleLabel.text = contentsModel.title
        subTitleLabel.text = contentsModel.body
        layoutUIForTimeline(footerView:footerView)

    }
    
    
    func configure(contentsModel:ContentsModel){
        
        backView.layer.cornerRadius = 10
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .yellow
        subTitleLabel.text = contentsModel.body
        
        layoutUIForContents()
        
    }
    
    

    func layoutUIForContents(){
        addSubview(backView)
        addSubview(subTitleLabel)
        let padding:CGFloat = 20
        let backPadding:CGFloat = 10

        NSLayoutConstraint.activate([
                        
            subTitleLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor,constant: padding),
            subTitleLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: padding),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding),
            
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: backPadding),
            backView.topAnchor.constraint(equalTo: self.topAnchor,constant: backPadding),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -backPadding),
            backView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -backPadding)

            
        ])
    }
    
    func layoutUIForTimeline(footerView:STFooterView){

        addSubview(urlToImageView)
        addSubview(userNameLabel)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(footerView)
        footerView.backgroundColor = .yellow
        
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
            
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: padding),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 80),
            
            footerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            footerView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 30),
            footerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

            
        ])
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

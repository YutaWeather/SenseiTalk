//
//  STHeaderView.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/14.
//

import UIKit

class STHeaderView: UIView {

    var titleLabel = STTitleLabel(textAlignment: .left, fontSize: 12)
    var urlToImageView = STImageView(frame: .zero)
    var userNameLabel = STTitleLabel(textAlignment: .left, fontSize: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(contentsModel:ContentsModel){
        
        urlToImageView.sd_setImage(with: URL(string: (contentsModel.userModel?.profileImageURL)!))
        titleLabel.text = contentsModel.title
        userNameLabel.text = contentsModel.userModel?.userName
        backgroundColor = .white
        layoutUI()
        
    }

    func layoutUI(){
        addSubview(urlToImageView)
        addSubview(userNameLabel)
        addSubview(titleLabel)
        
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: padding),
            urlToImageView.widthAnchor.constraint(equalToConstant: 40),
            urlToImageView.heightAnchor.constraint(equalToConstant:40),
            
            userNameLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            userNameLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: urlToImageView.bottomAnchor,constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding)
            
        ])
        
    }
    
    
    

}

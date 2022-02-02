//
//  STNewsCollectionViewCell.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/31.
//

import UIKit

class STNewsCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "STNewsCollectionViewCell"
    var titleLabel = STTitleLabel(textAlignment: .left, fontSize: 12)
    var urlToImageView = STImageView(frame: .zero)

    func configure(article:Article){
        urlToImageView.image = nil
        titleLabel.text = nil
        if article.urlToImage != nil{
            urlToImageView.sd_setImage(with: URL(string: article.urlToImage!))
        }else{
            urlToImageView.image = UIImage(named: "noImage")

        }
        titleLabel.text = article.title
            
        
        layoutUIForNews()
    }
    
    func layoutUIForNews(){
        addSubview(urlToImageView)
        addSubview(titleLabel)
        
        let padding:CGFloat = 10
        NSLayoutConstraint.activate([
            
            urlToImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: padding),
            urlToImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            urlToImageView.widthAnchor.constraint(equalToConstant: 100),
            urlToImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.leadingAnchor.constraint(equalTo: urlToImageView.trailingAnchor,constant: padding),
            titleLabel.topAnchor.constraint(equalTo: urlToImageView.topAnchor,constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding)

        ])
        
    }
    
}

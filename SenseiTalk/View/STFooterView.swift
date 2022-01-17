//
//  STFooterView.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/14.
//

import UIKit

class STFooterView: UIView {

    var likeButton = STButton(backgroundColor: .white, title: "")
    var commentIconButton = STButton(backgroundColor: .white, title: "")
    
    var likeCountLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
    var commentCountLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
    
    //コメントTextField
    var commentTextField = STTextField(textAlignment: .left, fontSize: 10)
    //投稿Button
    var postButton = STButton(backgroundColor: .white, title: "投稿")
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI(){
        addSubview(likeButton)
        addSubview(likeCountLabel)
        addSubview(commentIconButton)
        addSubview(commentCountLabel)
        
        addSubview(commentTextField)
        addSubview(postButton)

        let padding:CGFloat = 5
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: self.trailingAnchor,constant: -150),
            likeButton.topAnchor.constraint(equalTo: self.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor,constant: padding),
            likeCountLabel.topAnchor.constraint(equalTo: likeButton.topAnchor),
            likeCountLabel.widthAnchor.constraint(equalToConstant: 30),
            likeCountLabel.heightAnchor.constraint(equalToConstant: 30),
            
            commentIconButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor,constant: padding),
            commentIconButton.topAnchor.constraint(equalTo: likeCountLabel.topAnchor),
            commentIconButton.widthAnchor.constraint(equalToConstant: 30),
            commentIconButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentCountLabel.leadingAnchor.constraint(equalTo: commentIconButton.trailingAnchor,constant: padding),
            commentCountLabel.topAnchor.constraint(equalTo: commentIconButton.topAnchor),
            commentCountLabel.widthAnchor.constraint(equalToConstant: 30),
            commentCountLabel.heightAnchor.constraint(equalToConstant: 30),
            
            commentTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            commentTextField.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: padding),
            commentTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -80),
            commentTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            
            postButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: padding),
            postButton.topAnchor.constraint(equalTo: commentTextField.topAnchor),
            postButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            postButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -padding)
            
            
        ])
        
    }
    
    func configure(){

        self.backgroundColor = .yellow
        likeButton.setImage(UIImage(named: "notLike"), for: .normal)
        commentIconButton.setImage(UIImage(named: "commentIcon"), for: .normal)
        likeCountLabel.text = "0"
        commentCountLabel.text = "0"
        layoutUI()
    }
    
}

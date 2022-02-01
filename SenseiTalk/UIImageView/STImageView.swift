//
//  STImageView.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class STImageView: UIImageView {
    
    //プレースホルダーを宣言
    let placeholderImage = UIImage(named: "avatar-placeholder")!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    init(frame:CGRect,image:UIImage) {
        
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.image = image
        translatesAutoresizingMaskIntoConstraints = false

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }



}

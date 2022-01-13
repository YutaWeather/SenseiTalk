//
//  STTextView.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/13.
//

import UIKit

class STTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configure() {
        textColor = .label
        font = .boldSystemFont(ofSize: 12)
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
    }
}

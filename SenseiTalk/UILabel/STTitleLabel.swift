//
//  STLabel.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class STTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //TitleLabelを作成する時に自由に設定できるプロパティを定義
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    //決定しているプロパティ
    private func configure() {
        textColor = .label
        numberOfLines = 0
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}

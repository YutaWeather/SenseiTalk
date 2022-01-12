//
//  STTextField.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/12.
//

import UIKit

class STTextField: UITextField {

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
//        textColor = .label
        backgroundColor = .white
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

//
//  STPostVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/13.
//

import UIKit

class STPostVC: UIViewController,DoneSend {

    var categoryName = String()
    var textView = STTextView()
    var textField = STTextField(textAlignment: .left, fontSize: 12)
    var postBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func layoutUI(){
        
        view.addSubview(textField)
        view.addSubview(textView)
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
        
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            textField.topAnchor.constraint(equalTo: view.topAnchor,constant: (self.navigationController?.navigationBar.frame.size.height)! + 50),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            textField.heightAnchor.constraint(equalToConstant: 30),
            
            textView.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant: padding),
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: padding),
            textView.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant: -padding),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -130)
            
        ])
    }
    
    func configure(){
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        view.backgroundColor = .systemGroupedBackground
        title = "投稿を作成"
        postBarButtonItem = UIBarButtonItem(title: "投稿", style: .done, target: self, action: #selector(postContents(_:)))
        self.navigationItem.rightBarButtonItems = [postBarButtonItem]
        layoutUI()
    }

    @objc func postContents(_ sender: UIBarButtonItem) {
        //1000文字まで
        let sendDBModel = STSendDBModel()
        sendDBModel.doneSend = self
        sendDBModel.sendContents(category: categoryName, title: textField.text!, body: textView.text!)
    }
    
    func doneSendData() {
        self.navigationController?.popViewController(animated: true)
    }
    

}

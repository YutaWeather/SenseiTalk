//
//  STPostVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/13.
//

import UIKit
import Network

class STPostVC: UIViewController,DoneSend,UITextViewDelegate {
    
    var categoryName = String()
    var textView = STTextView()
    var textField = STTextField(textAlignment: .left, fontSize: 12)
    var textCountLabel = STTitleLabel(textAlignment: .left, fontSize: 10)
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
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -200),
            
            textCountLabel.topAnchor.constraint(equalTo: textView.bottomAnchor,constant: padding),
            textCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            textCountLabel.heightAnchor.constraint(equalToConstant: 20),
            textCountLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width/2 - padding)
            
        ])
    }
    
    func configure(){
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        view.backgroundColor = .systemGroupedBackground
        title = "投稿を作成"
        postBarButtonItem = UIBarButtonItem(title: "投稿", style: .done, target: self, action: #selector(postContents(_:)))
        self.navigationItem.rightBarButtonItems = [postBarButtonItem]
        textCountLabel.text = "残り文字数: \(STConst.maxTextCount)"
        textView.delegate = self
        textView.text = "テキストを入力・・・"
        view.addSubview(textCountLabel)
        layoutUI()
    }
    
    @objc func postContents(_ sender: UIBarButtonItem) {
        //1000文字まで
        let sendDBModel = STSendDBModel()
        sendDBModel.doneSend = self
        if textField.text?.isEmpty == true || textView.text?.isEmpty == true{
            STAlertNotification.alert(text:FetchErrors.emptyError.title)
        }
        sendDBModel.sendContents(category: categoryName, title: textField.text!, body: textView.text!)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= STConst.maxTextCount
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCountLabel.text = "残り文字数: \(STConst.maxTextCount - textView.text.count)"
        if textView.text.count == STConst.maxTextCount{
            STAlertNotification.alert(text: FetchErrors.textError.title)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "テキストを入力・・・" {
            textView.text = nil
            textView.textColor = .darkText
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = "テキストを入力・・・"
        }
    }
    
    func doneSendData() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

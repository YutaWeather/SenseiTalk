//
//  STPostVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/13.
//

import UIKit

class STPostVC: UIViewController {

    var categoryName = String()
    var textView = STTextView()
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
        
        view.addSubview(textView)
        let padding:CGFloat = 20
        NSLayoutConstraint.activate([
        
            textView.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant: padding),
            textView.topAnchor.constraint(equalTo: view.topAnchor,constant: (self.navigationController?.navigationBar.frame.size.height)! + padding * 2),
            textView.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant: -padding),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100)
            
        ])
    }
    
    func configure(){
        view.backgroundColor = .systemGroupedBackground
        title = "投稿を作成"
        postBarButtonItem = UIBarButtonItem(title: "投稿", style: .done, target: self, action: #selector(postContents(_:)))
        self.navigationItem.rightBarButtonItems = [postBarButtonItem]
        layoutUI()
    }

    @objc func postContents(_ sender: UIBarButtonItem) {
        //1000文字まで
        let sendDBModel = STSendDBModel()
        sendDBModel.sendContents(category: "カテゴリー", title: "タイトル", body: "本文")
    }
    

}

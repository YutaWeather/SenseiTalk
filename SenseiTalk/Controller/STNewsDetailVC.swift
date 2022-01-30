//
//  STNewsDetailVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/30.
//

import UIKit
import WebKit

class STNewsDetailVC: UIViewController {

    var newsUrl = String()
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configure()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true

    }
    
    func configure(){
        let url = URL(string: newsUrl)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        view.addSubview(webView)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = view.frame
    }
    

}

//
//  STTimeLineVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import FirebaseAuth

class STTimeLineVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var scrollView = UIScrollView()
    var tableView:UITableView?
    var postButton = STButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        postButton.frame = CGRect(x: view.frame.size.width - 100, y: view.frame.size.height - (self.tabBarController?.tabBar.frame.height)! - (self.navigationController?.navigationBar.frame.size.height)! - 80, width: 80, height: 80)
    }


    
    private func showLoginVC(){
        let loginVC = STLoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)

    }
    
    
    func configure(){
        if Auth.auth().currentUser?.uid != nil{
            
        }else{
            showLoginVC()
            
        }

        
        setUpScroolViewAndTableView()
        postButton.addTarget(self, action: #selector(tapPost), for: .touchUpInside)
        postButton.setImage(UIImage(named: "plus"), for: .normal)
        view.addSubview(scrollView)
        view.backgroundColor = .systemGray
        view.addSubview(postButton)
        
    }
    
    @objc func tapPost(){
        
        //toPostVC
        let postVC = STPostVC()
        postVC.categoryName = "カテゴリー名"
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    private func setUpScroolViewAndTableView(){
        
        scrollView.backgroundColor = .green
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(
            width: view.frame.size.width * 3,
            height: view.frame.size.height
        )
        
        for i in 0...2{
            
            tableView = UITableView()
            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.tag = i
            tableView!.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
            tableView!.frame = CGRect(x: view.frame.size.width * CGFloat(i), y: (self.navigationController?.navigationBar.frame.size.height)!, width: view.frame.size.width, height: view.frame.size.height)
            scrollView.addSubview(tableView!)
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
        
        return cell
    }

    
    
}

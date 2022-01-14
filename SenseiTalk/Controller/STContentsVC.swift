//
//  STContentsVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/14.
//

import UIKit

class STContentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var contentsModel:ContentsModel?
    var tableView = UITableView()
    var headerView = STHeaderView()
    var footerView = STFooterView()
    
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
        
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
        headerView.configure(contentsModel: contentsModel!)
        footerView.configure()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        footerView.likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        footerView.commentIconButton.addTarget(self, action: #selector(tapCommentIconButton), for: .touchUpInside)

    }
    
    
    @objc func tapLikeButton(){
        print("タップLike")
        
    }
    
    @objc func tapCommentIconButton(){
        print("タップComment")
        
   
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let padding:CGFloat = 20
        headerView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + padding, width: view.frame.size.width, height: 100)
        footerView.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        tableView.frame = CGRect(x: 0, y: headerView.frame.origin.y + headerView.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - headerView.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - footerView.frame.size.height - padding)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
        cell.configure(contentsModel: contentsModel!)
        return cell
        
    }
    

    

}

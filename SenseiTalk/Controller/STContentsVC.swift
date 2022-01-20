//
//  STContentsVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/14.
//

import UIKit
import Firebase

class STContentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var contentsModel:ContentsModel?
    var tableView = UITableView()
    var headerView = STHeaderView()
    var footerView = STFooterView()
    let sendDBModel = STSendDBModel()
    let loadDBModel = STLoadDBModel()
    var contentArray = [ContentsModel]()
    var likeContentsArray = [LikeContents]()
    var commentArray = [CommentContent]()
    var checkLike = Bool()
    
    
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
        tableView.register(STCommentCell.self, forCellReuseIdentifier: STCommentCell.identifier)
        headerView.configure(contentsModel: contentsModel!)
        footerView.configure()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        footerView.likeButton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        footerView.postButton.addTarget(self, action: #selector(tapCommentIconButton), for: .touchUpInside)
        footerView.commentIconButton.addTarget(self, action: #selector(tapCommentButton), for: .touchUpInside)
      
//        loadDBModel.doneLoad = self
//        loadDBModel.loadLike(categroy: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!)
//        loadDBModel.loadComment(categroy: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!)
    }
    
    
    
    @objc func tapCommentButton(){
        
//        let detailContentVC = STDetailContentVC()
//        detailContentVC.commentContent = self.commentArray[]
//        self.navigationController?.pushViewController(detailContentVC, animated: true)
        
    }
    
    @objc func tapLikeButton(){
        //いいね送信
        sendDBModel.sendLikeContents(category: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!,checkLike:checkLike)
    }

    @objc func tapCommentIconButton(){
        //コメント送信
        sendDBModel.sendComment(category: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, comment: footerView.commentTextField.text!)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let padding:CGFloat = 20
        headerView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + padding, width: view.frame.size.width, height: 100)
        footerView.frame = CGRect(x: 0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 100)
        tableView.frame = CGRect(x: 0, y: headerView.frame.origin.y + headerView.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - headerView.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - footerView.frame.size.height - padding)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 1 + self.commentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
            cell.configure(contentsModel: contentsModel!)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: STCommentCell.identifier, for: indexPath) as! STCommentCell
            cell.configure(commentModel: commentArray[indexPath.row - 1])
            return cell

        }
        
    }
    


}

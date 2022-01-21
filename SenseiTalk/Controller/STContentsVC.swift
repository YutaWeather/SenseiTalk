//
//  STContentsVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/14.
//

import UIKit
import Firebase

class STContentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoad {
    
    var contentsModel:ContentsModel?
    var tableView = UITableView()
    var headerView = STHeaderView()
//    var footerView = STFooterView()
    var textFooterView = STFooterView()
    let sendDBModel = STSendDBModel()
    let loadDBModel = STLoadDBModel()
    var contentArray = [ContentsModel]()
    var likeContentsArray = [LikeContents]()
    var commentArray = [CommentContent]()
    var checkLike = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        configure()

    }

    func configure(){
        
        view.backgroundColor = .white
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
        tableView.register(STCommentCell.self, forCellReuseIdentifier: STCommentCell.identifier)
        headerView.configure(contentsModel: contentsModel!)
        view.addSubview(headerView)
        view.addSubview(tableView)
        loadDBModel.doneLoad = self
        view.addSubview(textFooterView)
        textFooterView.configure()
        textFooterView.postButton.addTarget(self, action: #selector(tapCommentButton(sender:)), for: .touchUpInside)
        loadDBModel.loadComment(categroy: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, cell: ContentsCell(), indexPath: IndexPath())
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let padding:CGFloat = 20
        headerView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + padding, width: view.frame.size.width, height: 100)
        textFooterView.frame = CGRect(x: 0, y: view.frame.size.height - 80, width: view.frame.size.width, height: 80)
        tableView.frame = CGRect(x: 0, y: headerView.frame.origin.y + headerView.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - headerView.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - textFooterView.frame.size.height - padding)
        
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
//            cell.configure(commentModel: commentArray[indexPath.row - 1])
            let footerView = STFooterView()
            print(self.commentArray.debugDescription)
            cell.configure(commentModel: commentArray[indexPath.row - 1], footerView: footerView)
           
//            footerView.configureForTimeLine()
            footerView.configureForCommentToComment()
            footerView.backgroundColor = .yellow
            
            cell.footerBaseView.likeButton.tag = indexPath.row - 1
            cell.footerBaseView.commentIconButton.tag = indexPath.row - 1
            
            cell.footerBaseView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
            loadDBModel.loadCommentLike(categroy:  (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, cell: cell, indexPath: indexPath,commentModel: commentArray[indexPath.row - 1])
            
            
            return cell

        }
        
    }

    @objc func tapLikeButton(sender:STButton){

        //いいね送信
        var checkFlag = Bool()
        if sender.imageView?.image == UIImage(named: "like"){

            checkFlag = true
        }else{
            checkFlag = false
        }

        sendDBModel.sendLikeContentsToComment(category:(contentsModel?.category)!, contentID: self.commentArray[sender.tag].contentID!, checkLike: checkFlag, commentModel: self.commentArray[sender.tag])
        
    }
    
    @objc func tapCommentButton(sender:STButton){
        //コメント送信
        var checkFlag = Bool()
        if sender.imageView?.image == UIImage(named: "like"){

            checkFlag = true
        }else{
            checkFlag = false
        }
        
        
        sendDBModel.sendComment(category: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, comment: textFooterView.commentTextField.text!)
    }

    func likeOrNot(likeContents: [LikeContents], cell: STCommentCell, indexPath: IndexPath) {
     
        print(cell.footerBaseView.likeButton.tag,indexPath.row)
        if cell.footerBaseView.likeButton.tag == indexPath.row - 1{
            
            cell.footerBaseView.likeCountLabel.text = String(likeContents.count)
            
            //ここが問題 自分がこのLike配列の中にいるかどうかチェック
            let check = likeContents.filter{ $0.userID == Auth.auth().currentUser!.uid}.count > 0
            if check == true{
                cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
            }else{
                cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
            }
        }
        
//        self.likeContentsArray = []
//        self.likeContentsArray = likeContents
//
//        cell.footerBaseView.likeCountLabel.text = String(self.likeContentsArray.count)
//        checkLike = self.likeContentsArray.filter{ $0.userID == Auth.auth().currentUser!.uid}.count > 0
//        var check = self.likeContentsArray.filter{$0.userID == Auth.auth().currentUser?.uid}
//        if check.isEmpty != true{
//            cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
//        }else{
//            cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
//        }



        
    }
    
    func loadComment(commentArray: [CommentContent], cell: ContentsCell, indexPath: IndexPath) {
        
        self.commentArray = []
        self.commentArray = commentArray
        tableView.reloadData()
        
    }

    
    func loadContents(contentsArray: [ContentsModel]) {
        
    }
    
    func likeOrNot(likeContents: [LikeContents], cell: ContentsCell, indexPath: IndexPath) {
    
    }
    
    func likeOrNotForContents(likeContents: [LikeContents]) {
        
    }
    
}

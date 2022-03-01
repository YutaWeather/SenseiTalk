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
    var textFooterView = STFooterView()
    let sendDBModel = STSendDBModel()
    var commentCollection = STCommentCollection()
    
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
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
        tableView.register(STCommentCell.self, forCellReuseIdentifier: STCommentCell.identifier)
        headerView.configure(contentsModel: contentsModel!)
//        view.addSubview(headerView)
//        view.addSubview(tableView)
//        view.addSubview(textFooterView)

        textFooterView.configure()
        textFooterView.postButton.addTarget(self, action: #selector(tapCommentButton(sender:)), for: .touchUpInside)
        
        commentCollection.fetchContent(categroy: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, limit: 4) { [unowned self] in
            
            self.tableView.reloadData()
        }
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(textFooterView)
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let padding:CGFloat = 22
        headerView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + padding, width: view.frame.size.width, height: 100)
        textFooterView.frame = CGRect(x: 0, y: view.frame.size.height - 80, width: view.frame.size.width, height: 80)
        tableView.frame = CGRect(x: 0, y: headerView.frame.origin.y + headerView.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - headerView.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - textFooterView.frame.size.height - padding)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(commentCollection.commentArray.debugDescription)
        return 1 + self.commentCollection.commentArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
            cell.configure(contentsModel: contentsModel!)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: STCommentCell.identifier, for: indexPath) as! STCommentCell
            cell.contentView.isUserInteractionEnabled = false
            cell.configure(commentModel: commentCollection.commentArray[indexPath.row - 1])
            cell.footerView.likeButton.tag = indexPath.row - 1
            cell.footerView.commentIconButton.tag = indexPath.row - 1

            if commentCollection.commentArray[indexPath.row - 1].likeIDArray!.count > 0{
                for i in 0...commentCollection.commentArray[indexPath.row - 1].likeIDArray!.count - 1{
                    if commentCollection.commentArray[indexPath.row - 1].likeIDArray![i].contains(Auth.auth().currentUser!.uid) == true{
                        cell.footerView.likeButton.setImage(UIImage(named: "like"), for: .normal)
                    }else{
                        cell.footerView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
                    }
                }
            }else{
                cell.footerView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
            }
            cell.footerView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
            cell.footerView.likeCountLabel.text = "\(self.commentCollection.commentArray[indexPath.row - 1].likeIDArray!.count)"
            
            return cell
        }
        
    }
               
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func tapLikeButton(sender:STButton){
      
        var checkFlag = Bool()

        if self.commentCollection.commentArray[sender.tag].likeIDArray?.contains(Auth.auth().currentUser!.uid) == true{
            checkFlag = true

        }else{
            checkFlag = false

        }
        
        sendDBModel.sendLikeContentsToComment(category: (contentsModel?.category)!, contentID: self.commentCollection.commentArray[sender.tag].contentID!, checkLike: checkFlag, commentModel: self.commentCollection.commentArray[sender.tag], likeIDArray: self.commentCollection.commentArray[sender.tag].likeIDArray!)
        
    }
    
    @objc func tapCommentButton(sender:STButton){

        let uuid = UUID().uuidString
        if (contentsModel?.commentIDArray)!.count > 0{

            contentsModel?.commentIDArray?.append(Auth.auth().currentUser!.uid)
            sendDBModel.sendComment(category: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, comment: textFooterView.commentTextField.text!,uuid:uuid, commentIDArray: (contentsModel?.commentIDArray)!)

        }else{
            sendDBModel.sendComment(category: (contentsModel?.category)!, contentID: (contentsModel?.contentID)!, comment: textFooterView.commentTextField.text!,uuid:uuid, commentIDArray:[Auth.auth().currentUser!.uid])
        }
    }

}

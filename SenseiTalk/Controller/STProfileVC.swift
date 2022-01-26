//
//  STProfileVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/26.
//

import UIKit
import Firebase
import SDWebImage

class STProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoad {

    let profileImageView = STImageView(frame: .zero)
    let userNameLabel = STTitleLabel(textAlignment: .center, fontSize: 15)
    var timeLineTableView = UITableView()
    let loadDBModel = STLoadDBModel()
    var contentsArray = [ContentsModel]()
    var userID = String()
    var sendDBModel = STSendDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        configure()

    }
    
    func configure(){
        
        view.backgroundColor = .white
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        timeLineTableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
//        timeLineTableView.backgroundColor = .yellow
//        timeLineTableView.frame = CGRect(x: 0, y: 120, width: view.frame.size.width, height: view.frame.size.height)

        let loadDBModel = STLoadDBModel()
        loadDBModel.doneLoad = self
//        loadDBModel.loadContent(categroy: String(pageNum))
//        loadDBModel.loadContent(userID:userID)
        loadDBModel.loadContent(userID: Auth.auth().currentUser!.uid)
        layoutUI()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timeLineTableView.frame = CGRect(x: 0, y: userNameLabel.frame.origin.y + 100, width: view.frame.size.width, height: view.frame.size.height - userNameLabel.frame.origin.y + 100)
    }
    func layoutUI(){
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(timeLineTableView)
        let padding:CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: padding),
            userNameLabel.widthAnchor.constraint(equalToConstant: 100),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20)
            
//            timeLineTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            timeLineTableView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: padding),
//            timeLineTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            timeLineTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -(self.tabBarController?.tabBar.frame.size.height)!)
            
            
        ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.contentsArray.count)
        return self.contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.contentsArray.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
                let footerView = STFooterView()
                footerView.configureForTimeLine()
                footerView.backgroundColor = .yellow
                cell.configureContents(contentsModel: self.contentsArray[indexPath.row], footerView: footerView)
                cell.footerBaseView.likeButton.tag = indexPath.row
                cell.footerBaseView.commentIconButton.tag = indexPath.row
                
                if self.contentsArray[indexPath.row].commentIDArray!.count > 0{
                    cell.footerBaseView.commentCountLabel.text =
                    String(self.contentsArray[indexPath.row].commentIDArray!.count)
                }
                
                if self.contentsArray[indexPath.row].likeIDArray!.count > 0{
                for i in 0...self.contentsArray[indexPath.row].likeIDArray!.count - 1{
                    
                    if self.contentsArray[indexPath.row].likeIDArray![i].contains(userID) == true{
                        
                        cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
                        
                    }else{
                        cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)

                    }
                    
                }
                    
                }
                cell.footerBaseView.likeCountLabel.text = "\(self.contentsArray[indexPath.row].likeIDArray!.count)"

                cell.footerBaseView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
                
                return cell
            
        }else{
            return UITableViewCell()
        }
        
    }
    
    @objc func tapLikeButton(sender:STButton){
        
        //いいね送信
        var checkFlag = Bool()
        if self.contentsArray[sender.tag].likeIDArray?.contains(Auth.auth().currentUser!.uid) == true{
            checkFlag = true

        }else{
            checkFlag = false

        }
        
        sendDBModel.sendLikeContents(category: self.contentsArray[sender.tag].category!, contentID: self.contentsArray[sender.tag].contentID!,likeIDArray:self.contentsArray[sender.tag].likeIDArray!, checkLike: checkFlag,contentModel:self.contentsArray[sender.tag])

    }
    func loadContents(contentsArray: [ContentsModel]) {
        self.contentsArray = []
        self.contentsArray = contentsArray
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        userNameLabel.text = userModel.userName
        profileImageView.sd_setImage(with: URL(string: userModel.profileImageURL!))
        print(self.contentsArray.debugDescription)
        timeLineTableView.reloadData()
    }
    
    func likeOrNot(likeContents: [LikeContents], cell: ContentsCell, indexPath: IndexPath) {
        
    }
    
    func likeOrNot(likeContents: [LikeContents], cell: STCommentCell, indexPath: IndexPath) {
        
    }
    
    func likeOrNotForContents(likeContents: [LikeContents]) {
        
    }
    
    func loadComment(commentArray: [CommentContent], cell: ContentsCell, indexPath: IndexPath) {
        
    }
    
    func loadComment(commentArray: [CommentContent]) {
        
    }
}

//
//  STProfileVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/26.
//

import UIKit
import Firebase
import SDWebImage

class STProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoad,UITabBarDelegate {

    let profileImageView = STImageView(frame: .zero)
    let userNameLabel = STTitleLabel(textAlignment: .center, fontSize: 15)
    var timeLineTableView = UITableView()
    let loadDBModel = STLoadDBModel()
    var contentsArray = [ContentsModel]()
    var userID = String()
    var sendDBModel = STSendDBModel()
    fileprivate var userDataCollection: STUserDataCollection = STUserDataCollection()

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
        //もしtabがクリックされていなかったら userID
        if self.tabBarController?.selectedIndex == 2{
            userID = Auth.auth().currentUser!.uid
        }
        
        userDataCollection.fetchUserDataCollection(userID: userID, limit: 4) { [unowned self] in
            let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
            if userID == Auth.auth().currentUser!.uid{
                userNameLabel.text = userModel.userName
                profileImageView.sd_setImage(with: URL(string: userModel.profileImageURL!))

            }else{
        
                userNameLabel.text = self.userDataCollection.contentsArray[0].userModel?.userName
                profileImageView.sd_setImage(with: URL(string: (self.userDataCollection.contentsArray[0].userModel?.profileImageURL!)!), completed: nil)
            }
            print(self.userDataCollection.contentsArray.debugDescription)
            timeLineTableView.reloadData()

        }
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
        ])
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDataCollection.contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.userDataCollection.contentsArray.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
                let footerView = STFooterView()
                footerView.configureForTimeLine()
                footerView.backgroundColor = .yellow
                cell.configureContents(contentsModel: self.userDataCollection.contentsArray[indexPath.row], footerView: footerView)
                cell.footerBaseView.likeButton.tag = indexPath.row
                cell.footerBaseView.commentIconButton.tag = indexPath.row
                
                if self.userDataCollection.contentsArray[indexPath.row].commentIDArray!.count > 0{
                    cell.footerBaseView.commentCountLabel.text =
                    String(self.userDataCollection.contentsArray[indexPath.row].commentIDArray!.count)
                }
                
                if self.userDataCollection.contentsArray[indexPath.row].likeIDArray!.count > 0{
                for i in 0...self.userDataCollection.contentsArray[indexPath.row].likeIDArray!.count - 1{
                    
                    if self.userDataCollection.contentsArray[indexPath.row].likeIDArray![i].contains(userID) == true{
                        
                        cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
                        
                    }else{
                        cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)

                    }
                    
                }
                    
                }
                cell.footerBaseView.likeCountLabel.text = "\(self.userDataCollection.contentsArray[indexPath.row].likeIDArray!.count)"

                cell.footerBaseView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
                
                return cell
            
        }else{
            return UITableViewCell()
        }
        
    }
    
    @objc func tapLikeButton(sender:STButton){
        
        //いいね送信
        var checkFlag = Bool()
        if self.userDataCollection.contentsArray[sender.tag].likeIDArray?.contains(Auth.auth().currentUser!.uid) == true{
            checkFlag = true

        }else{
            checkFlag = false

        }
        
        sendDBModel.sendLikeContents(category: self.userDataCollection.contentsArray[sender.tag].category!, contentID: self.userDataCollection.contentsArray[sender.tag].contentID!,likeIDArray:self.userDataCollection.contentsArray[sender.tag].likeIDArray!, checkLike: checkFlag,contentModel:self.userDataCollection.contentsArray[sender.tag])

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        print(distanceToBottom)
        //========== ここから============
        if(distanceToBottom < 500 && self.userDataCollection.lastDocument != nil){
        print("ここが呼ばれた回数だけcompleted()が呼ばれる、受信される　↑上の条件を変える")
            self.userDataCollection.fetchMoreUserDataCollection(userID: userID, limit: 4) {
                [unowned self] in
            
                self.timeLineTableView.reloadData()
                
            }
        }
        
        //========== ここまで============
        
    }
    
    func loadContents(contentsArray: [ContentsModel]) {
//        self.contentsArray = []
//        self.contentsArray = contentsArray
//        print(contentsArray.debugDescription)
//        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
//        if userID == Auth.auth().currentUser!.uid{
//            userNameLabel.text = userModel.userName
//            profileImageView.sd_setImage(with: URL(string: userModel.profileImageURL!))
//
//        }else{
//
//            userNameLabel.text = self.contentsArray[0].userModel?.userName
//            profileImageView.sd_setImage(with: URL(string: (self.contentsArray[0].userModel?.profileImageURL!)!), completed: nil)
//        }
//        print(self.contentsArray.debugDescription)
//        timeLineTableView.reloadData()
    }
    
 
    
    func likeOrNot(likeContents: [LikeContents], cell: STCommentCell, indexPath: IndexPath) {
        
    }
    

    func loadComment(commentArray: [CommentContent]) {
        
    }
}

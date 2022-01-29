//
//  STTimeLineVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import FirebaseAuth

class STTimeLineVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoad {
    
    var tableView = UITableView()
    var postButton = STButton()
//    var contentsArray = [ContentsModel]()
    var pageNum = Int()
//    var pageControl = UIPageControl()
//    let loadDBModel = STLoadDBModel()
    let sendDBModel = STSendDBModel()
//    var likeContentsArray = [LikeContents]()
    var commentArrays = [[CommentContent]]()
    var commentArray = [CommentContent]()
    var checkLike = false
    var myUserID = String()
//    var posY: CGFloat!
    var topSafeArea: CGFloat!
    var bottomSafeArea: CGFloat!
    
    fileprivate var contentsCollection: STContentsCollection = STContentsCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
     
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: 120, width: view.frame.size.width, height: view.frame.size.height - 120)
        postButton.frame = CGRect(x: view.frame.size.width - 100, y: view.frame.size.height - 200, width: 80, height: 80)
    }
    
    func checkSafeArea(){
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    func configure(){
        checkSafeArea()
        postButton.addTarget(self, action: #selector(tapPost), for: .touchUpInside)
        postButton.setImage(UIImage(named: "plus"), for: .normal)
        view.backgroundColor = .white
//        loadDBModel.doneLoad = self

        setTableView(x: CGFloat(pageNum))
    }
    
    @objc func tapPost(){
        
        //toPostVC
        let postVC = STPostVC()
        postVC.categoryName = String(pageNum)
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    
    func setTableView(x:CGFloat){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        

        tableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
        tableView.frame = CGRect(x: 0, y: 120, width: view.frame.size.width, height: view.frame.size.height)

        view.addSubview(tableView)
//        let loadDBModel = STLoadDBModel()
//        loadDBModel.doneLoad = self
        
//        loadDBModel.loadContent(categroy: String(pageNum), fromDate: Date().timeIntervalSince1970,now:true)
        contentsCollection.fetchContent(categroy: String(pageNum), limit:2) {  [unowned self] in
            
//            DispatchQueue.main.async{
                if Auth.auth().currentUser?.uid != nil{
                    myUserID = Auth.auth().currentUser!.uid
                }else{
                    let loginVC = STLoginVC()
                    loginVC.modalPresentationStyle = .fullScreen
                    present(loginVC, animated: true, completion: nil)
                }

                self.tableView.reloadData()
//            }
            
        }
        
        
        view.addSubview(postButton)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("カウントチェック")
        print(self.contentsCollection.contentsArray.count)
//        return self.contentsCollection.contentsArray.count
        if self.contentsCollection.contentsArray.count > 0{
            switch self.contentsCollection.contentsArray[0].category{
//            case String(pageControl.currentPage):
            case String(pageNum):

                return self.contentsCollection.contentsArray.count
            default:
                return 1
            }

        }else{
            return 1
        }
//        if self.contentsArray.count > 0{
//            switch self.contentsArray[0].category{
////            case String(pageControl.currentPage):
//            case String(pageNum):
//
//                return self.contentsArray.count
//            default:
//                return 1
//            }
//
//        }else{
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if self.contentsCollection.contentsArray.count > 0{
            switch self.contentsCollection.contentsArray[indexPath.row].category{
            case String(pageNum):                
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
                
                let footerView = STFooterView()
                footerView.configureForTimeLine()
                footerView.backgroundColor = .yellow
//                cell.configureContents(contentsModel: self.contentsArray[indexPath.row], footerView: footerView)
                
                cell.configureContents(contentsModel: self.contentsCollection.contentsArray[indexPath.row], footerView: footerView)

                cell.tapGesture.view!.tag = indexPath.row
                cell.tapGesture.addTarget(self, action: #selector(tapImageView(sender:)))
                cell.footerBaseView.likeButton.tag = indexPath.row
                cell.footerBaseView.commentIconButton.tag = indexPath.row
                
                if self.contentsCollection.contentsArray[indexPath.row].commentIDArray!.count > 0{

                cell.footerBaseView.commentCountLabel.text =
                    String(self.contentsCollection.contentsArray[indexPath.row].commentIDArray!.count)
                }
                if self.contentsCollection.contentsArray[indexPath.row].likeIDArray!.count > 0{
                for i in 0...self.contentsCollection.contentsArray[indexPath.row].likeIDArray!.count - 1{

                    if self.contentsCollection.contentsArray[indexPath.row].likeIDArray![i].contains(myUserID) == true{
                        cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
                    }else{
                        cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
                    }
                }
                    
                }
                cell.footerBaseView.likeCountLabel.text = "\(self.contentsCollection.contentsArray[indexPath.row].likeIDArray!.count)"
                cell.footerBaseView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        else{
            return UITableViewCell()
        }
    }
    
    @objc func tapLikeButton(sender:STButton){
        
        //いいね送信
        var checkFlag = Bool()
//        if self.contentsArray[sender.tag].likeIDArray?.contains(Auth.auth().currentUser!.uid) == true{
        if self.contentsCollection.contentsArray[sender.tag].likeIDArray?.contains(Auth.auth().currentUser!.uid) == true{

        checkFlag = true

        }else{
            checkFlag = false

        }
//        sendDBModel.sendLikeContents(category: String(pageNum), contentID: self.contentsArray[sender.tag].contentID!,likeIDArray:self.contentsArray[sender.tag].likeIDArray!, checkLike: checkFlag,contentModel:self.contentsArray[sender.tag])
        sendDBModel.sendLikeContents(category: String(pageNum), contentID: self.contentsCollection.contentsArray[sender.tag].contentID!,likeIDArray:self.contentsCollection.contentsArray[sender.tag].likeIDArray!, checkLike: checkFlag,contentModel:self.contentsCollection.contentsArray[sender.tag])

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contentsVC = STContentsVC()
//        contentsVC.contentsModel = self.contentsArray[indexPath.row]
        contentsVC.contentsModel = self.contentsCollection.contentsArray[indexPath.row]

        self.commentArray = []
        if self.commentArray.count > 0{
            for i in 0...self.commentArrays.count - 1{
//                if self.commentArrays[i].contains(where: { $0.contentID == self.contentsArray[indexPath.row].contentID }) == true{
                if self.commentArrays[i].contains(where: { $0.contentID == self.contentsCollection.contentsArray[indexPath.row].contentID }) == true{

                print(self.commentArray.debugDescription)
                    self.commentArray = self.commentArrays[i]
                }
            }
        }
        
        
        contentsVC.commentArray = self.commentArray
        self.navigationController?.pushViewController(contentsVC, animated: true)
        
    }
    
    @objc func tapImageView(sender:UITapGestureRecognizer){
        
//        sender.tag
        let profileVC = STProfileVC()
//        profileVC.userID = (self.contentsArray[sender.view!.tag].userModel?.userID)!
        profileVC.userID = (self.contentsCollection.contentsArray[sender.view!.tag].userModel?.userID)!

        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func loadContents(contentsArray: [ContentsModel]) {
//        //2,8,1,6,7
//        print(contentsArray.debugDescription)
//
//        if Auth.auth().currentUser?.uid != nil{
//            myUserID = Auth.auth().currentUser!.uid
//        }else{
//            let loginVC = STLoginVC()
//            loginVC.modalPresentationStyle = .fullScreen
//            present(loginVC, animated: true, completion: nil)
//        }
//        if contentsArray.count > 0 && String(pageNum) == contentsArray[0].category{
//
//
//            self.contentsArray = []
//            self.contentsArray = contentsArray
//
//        }
//
//        tableView.reloadData()
        
    }
    
    
    func likeOrNot(likeContents: [LikeContents],cell:ContentsCell,indexPath:IndexPath) {
        
        print(cell.footerBaseView.likeButton.tag,indexPath.row)
        if cell.footerBaseView.likeButton.tag == indexPath.row{
            
            cell.footerBaseView.likeCountLabel.text = String(likeContents.count)
            
            //ここが問題 自分がこのLike配列の中にいるかどうかチェック
            if Auth.auth().currentUser?.uid.isEmpty != true{
                let check = likeContents.filter{ $0.userID == Auth.auth().currentUser?.uid}.count > 0
                if check == true{
                    cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
                }else{
                    cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
                }
            }
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        print(distanceToBottom)
        //==========STEP5 ここから============
        if(distanceToBottom < 500 && self.contentsCollection.lastDocument != nil){
//        if(distanceToBottom < 500 && self.contentsCollection.lastDocument != nil && statusCheck == false){

        print("ここが呼ばれた回数だけcompleted()が呼ばれる、受信される　↑上の条件を変える")
            self.contentsCollection.fetchMoreContent(categroy: String(pageNum), limit: 2){ [unowned self] in
                
                self.tableView.reloadData()
                
            }
        }
        
        //========== ここまで============
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        print(indexPath.row)
//        print(self.contentsCollection.contentsArray.count)
//        if self.contentsCollection.contentsArray.count >= 2 && indexPath.row == self.contentsCollection.contentsArray.count - 1 {
//
//                   self.contentsCollection.fetchMoreContent(categroy: String(pageNum), limit: 2){ [unowned self] in
//
//                       self.tableView.reloadData()
//
//                   }
//               }
//
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollPosY = scrollView.contentOffset.y //スクロール位置
//        let maxOffsetY = scrollView.contentSize.height - scrollView.frame.height //スクロール領域の高さからスクロール画面の高さを引いた値
//        let distanceToBottom = maxOffsetY - scrollPosY //スクロール領域下部までの距離
//        //スクロール領域下部に近づいたら追加で記事を取得する
//        print("スクロール")
//        print(distanceToBottom)
//        if distanceToBottom < 200 {
//
//            print("超えた")
//            contentsCollection.fetchMoreContent(categroy: String(pageNum), limit:1) {  [unowned self] in
//
////                DispatchQueue.main.async{
//                    if Auth.auth().currentUser?.uid != nil{
//                        myUserID = Auth.auth().currentUser!.uid
//                    }else{
//                        let loginVC = STLoginVC()
//                        loginVC.modalPresentationStyle = .fullScreen
//                        present(loginVC, animated: true, completion: nil)
//                    }
//
//                    self.tableView.reloadData()
////                }
//
//            }
//
//
//        }
//        /*
//
//         プロパティ    意味
//         contentOffset    どれくらいスクロールしているか
//         contentInset    余分にどれだけスクロールできるか
//         contentSize    スクロールする中身のサイズ
//
//         */
//    }
    
    func loadComment(commentArray: [CommentContent]) {
        self.commentArray = []
        self.commentArray = commentArray
//        tableView.reloadData()
    }

    func likeOrNot(likeContents: [LikeContents], cell: STCommentCell, indexPath: IndexPath) {
        
    }


}


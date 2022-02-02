//
//  STTimeLineVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import FirebaseAuth

class STTimeLineVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView = UITableView()
    var postButton = STButton()
    var pageNum = Int()
    let sendDBModel = STSendDBModel()
    var myUserID = String()
    var topSafeArea: CGFloat!
    var bottomSafeArea: CGFloat!
    
    fileprivate var contentsCollection: STContentsCollection = STContentsCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        tableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
        tableView.frame = CGRect(x: 0, y: 120, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(tableView)
        
        contentsCollection.fetchContent(categroy: String(pageNum), limit:4) {  [unowned self] in
            
            if Auth.auth().currentUser?.uid != nil{
                myUserID = Auth.auth().currentUser!.uid
            }else{
                let loginVC = STLoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true, completion: nil)
            }
            
            self.tableView.reloadData()
            
        }
        view.addSubview(postButton)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.contentsCollection.contentsArray.count > 0{
            switch self.contentsCollection.contentsArray[0].category{
            case String(pageNum):
                return self.contentsCollection.contentsArray.count
            default:
                return 1
            }
            
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
        cell.contentView.isUserInteractionEnabled = false

        if self.contentsCollection.contentsArray.count > 0{
            switch self.contentsCollection.contentsArray[indexPath.row].category{
            case String(pageNum):
                cell.configureContents(contentsModel: self.contentsCollection.contentsArray[indexPath.row])
                
                cell.tapGesture.view!.tag = indexPath.row
                cell.tapGesture.addTarget(self, action: #selector(tapImageView(sender:)))
                cell.footerView.likeButton.tag = indexPath.row
                cell.footerView.commentIconButton.tag = indexPath.row
                
                if self.contentsCollection.contentsArray[indexPath.row].commentIDArray!.count > 0{
                    
                    cell.footerView.commentCountLabel.text =
                    String(self.contentsCollection.contentsArray[indexPath.row].commentIDArray!.count)
                }
                if self.contentsCollection.contentsArray[indexPath.row].likeIDArray!.count > 0{
                    for i in 0...self.contentsCollection.contentsArray[indexPath.row].likeIDArray!.count - 1{
                        
                        if self.contentsCollection.contentsArray[indexPath.row].likeIDArray![i].contains(myUserID) == true{
                            cell.footerView.likeButton.setImage(UIImage(named: "like"), for: .normal)
                        }else{
                            cell.footerView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
                        }
                    }
                    
                }
                cell.footerView.likeCountLabel.text = "\(self.contentsCollection.contentsArray[indexPath.row].likeIDArray!.count)"
                cell.footerView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
                
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
        if self.contentsCollection.contentsArray[sender.tag].likeIDArray?.contains(Auth.auth().currentUser!.uid) == true{
            
            checkFlag = true
            
        }else{
            checkFlag = false
            
        }
        
        sendDBModel.sendLikeContents(category: String(pageNum), contentID: self.contentsCollection.contentsArray[sender.tag].contentID!,likeIDArray:self.contentsCollection.contentsArray[sender.tag].likeIDArray!, checkLike: checkFlag,contentModel:self.contentsCollection.contentsArray[sender.tag]) {

            self.contentsCollection.fetchContent(categroy: String(self.pageNum), limit:4) {  [unowned self] in
                
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contentsVC = STContentsVC()
        contentsVC.contentsModel = self.contentsCollection.contentsArray[indexPath.row]
        
        self.navigationController?.pushViewController(contentsVC, animated: true)
        
    }
    
    @objc func tapImageView(sender:UITapGestureRecognizer){
        
        let profileVC = STProfileVC()
        profileVC.userID = (self.contentsCollection.contentsArray[sender.view!.tag].userModel?.userID)!
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        if(distanceToBottom < 500 && self.contentsCollection.lastDocument != nil){
            self.contentsCollection.fetchMoreContent(categroy: String(pageNum), limit: 4){ [unowned self] in
                
                self.tableView.reloadData()
                
            }
        }
    }
    
}


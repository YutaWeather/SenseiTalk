//
//  STTimeLineVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import FirebaseAuth

class STTimeLineVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneLoad,UIScrollViewDelegate {
  
    var scrollView = UIScrollView()
    var tableView:UITableView?
    var postButton = STButton()
    var contentsArray = [ContentsModel]()
    var pageNum = String()
    var pageControl = UIPageControl()
    let loadDBModel = STLoadDBModel()
    let sendDBModel = STSendDBModel()
    var likeContentsArray = [LikeContents]()
    var commentArrays = [[CommentContent]]()
    var commentArray = [CommentContent]()
    var checkLike = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
        configure()

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
        
        pageControl = UIPageControl()
        pageControl.frame = CGRect(
            x: 0,
            y: view.frame.maxY-100,
            width: view.frame.maxX,
            height: 50
        )
        pageControl.pageIndicatorTintColor = UIColor.lightGray //点のベースの色
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray //現在地を表す点の色
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0 //現在地
        pageControl.isUserInteractionEnabled = false //アニメーション中のユーザー操作を無効
        view.addSubview(pageControl)
        loadDBModel.doneLoad = self
        


        
    }
    
    @objc func tapPost(){
        
        //toPostVC
        let postVC = STPostVC()
        postVC.categoryName = String(pageControl.currentPage)
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    private func setUpScroolViewAndTableView(){
        
        scrollView.delegate = self
        
        pageControl.currentPage = 0
        scrollView.backgroundColor = .green
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(
            width: view.frame.size.width * 3,
            height: view.frame.size.height
        )
        
        setTableView(x: CGFloat(pageControl.currentPage))
        
        
    }
    
    func setTableView(x:CGFloat){
        
        tableView = UITableView()
        tableView!.delegate = self
        tableView!.dataSource = self
        //            tableView!.tag = i
        tableView!.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)
        tableView!.frame = CGRect(x: view.frame.size.width * CGFloat(x), y: (self.navigationController?.navigationBar.frame.size.height)!, width: view.frame.size.width, height: view.frame.size.height)
        scrollView.addSubview(tableView!)
        let loadDBModel = STLoadDBModel()
        loadDBModel.doneLoad = self
        print(pageControl.currentPage)
        loadDBModel.loadContent(categroy: String(pageControl.currentPage))
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.contentsArray.count > 0{
            switch self.contentsArray[0].category{
            case String(pageControl.currentPage):
                return self.contentsArray.count
            default:
                return 1
            }
            
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.contentsArray.count > 0{
            switch self.contentsArray[indexPath.row].category{
            case String(pageControl.currentPage):
                let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
                let footerView = STFooterView()
                footerView.configureForTimeLine()
                footerView.backgroundColor = .yellow
                cell.configureContents(contentsModel: self.contentsArray[indexPath.row], footerView: footerView)
                
                cell.footerBaseView.likeButton.tag = indexPath.row
                cell.footerBaseView.commentIconButton.tag = indexPath.row
                
                cell.footerBaseView.likeButton.addTarget(self, action: #selector(tapLikeButton(sender:)), for: .touchUpInside)
                loadDBModel.loadLike(categroy: (self.contentsArray[indexPath.row].category)!, contentID: (self.contentsArray[indexPath.row].contentID)!,cell:cell,indexPath: indexPath)
                loadDBModel.loadComment(categroy: self.contentsArray[indexPath.row].category!, contentID:self.contentsArray[indexPath.row].contentID!,cell:cell,indexPath: indexPath)

                
                return cell
                
            default:
                return UITableViewCell()
            }
            
        }else{
            return UITableViewCell()
        }
    }
    
    @objc func tapLikeButton(sender:STButton){
        //いいね送信
        sendDBModel.sendLikeContents(category: String(pageControl.currentPage), contentID: self.contentsArray[sender.tag].contentID!, checkLike: checkLike)
    }
    
//    @objc func tapCommentIconButton(sender:STButton){
//        //コメント送信
////        sendDBModel.sendComment(category: String(pageControl.currentPage), contentID:self.contentsArray[sender.tag].contentID!, comment: commentArray[sender.tag].comment!)
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contentsVC = STContentsVC()
        contentsVC.contentsModel = self.contentsArray[indexPath.row]
        self.commentArray = []
        
        //self.contentsArray[indexPath.row].contentIDを含んでいるcommentArraysの中の配列のcommentArrayを出す
        
        for i in 0 ... self.commentArrays.count - 1{
            //            if self.commentArrays[i].contains(where: self.contentsArray[indexPath.row].contentID) == true{
            if self.commentArrays[i].contains(where: { $0.contentID == self.contentsArray[indexPath.row].contentID }) == true{
                self.commentArray = self.commentArrays[i]
            }
            
        }
        contentsVC.commentArray = self.commentArray
        self.navigationController?.pushViewController(contentsVC, animated: true)
        
    }
    
    func loadContents(contentsArray: [ContentsModel]) {
      
        print(String(pageControl.currentPage),contentsArray.count)
        if contentsArray.count > 0 && String(pageControl.currentPage) == contentsArray[0].category{
            
            self.contentsArray = []
            self.contentsArray = contentsArray
            print(self.contentsArray.debugDescription)
            
        }

        tableView?.reloadData()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            
            print(CGFloat(pageControl.currentPage))
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            setTableView(x: CGFloat(pageControl.currentPage))
            let loadDBModel = STLoadDBModel()
            loadDBModel.doneLoad = self
            loadDBModel.loadContent(categroy: String(pageControl.currentPage))

//            loadDBModel.loadLike(categroy: (self.contentsArray[indexPath.row].category)!, contentID: (self.contentsArray[indexPath.row].contentID)!,cell:cell,indexPath: indexPath)
//            loadDBModel.loadComment(categroy: self.contentsArray[indexPath.row].category!, contentID:self.contentsArray[indexPath.row].contentID!,cell:cell,indexPath: indexPath)

        }
        
    }
    
    func likeOrNot(likeContents: [LikeContents],cell:ContentsCell,indexPath:IndexPath) {
        
        self.likeContentsArray = []
        self.likeContentsArray = likeContents
        cell.footerBaseView.likeCountLabel.text = String(self.likeContentsArray.count)
        checkLike =  self.likeContentsArray.filter{ $0.userID == Auth.auth().currentUser!.uid}.count > 0
        if checkLike == true{
            cell.footerBaseView.likeButton.setImage(UIImage(named: "like"), for: .normal)
        }else{
            cell.footerBaseView.likeButton.setImage(UIImage(named: "notLike"), for: .normal)
        }


    }

    func loadComment(commentArray: [CommentContent], cell: ContentsCell, indexPath: IndexPath) {

//        self.commentArrays = []
        self.commentArrays.append(commentArray)
        
        cell.footerBaseView.commentCountLabel.text = String(commentArray.count)
//        self.tableView?.reloadData()
        
    }
    
    func likeOrNotForContents(likeContents: [LikeContents]) {
        
    }
}

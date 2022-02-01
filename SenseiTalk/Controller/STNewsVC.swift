//
//  STNewsVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class STNewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,TapCollectionViewCell{
    
    var tableView = UITableView()
    let newsManager = STNewsManager()
    private let categoryArray = ["&category=business","&category=entertainment"]
    private let categoryURL = "https://newsapi.org/v2/top-headlines?country=jp&apiKey="

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false

    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
    }
    

    func tableViewConfigure(){
        view.backgroundColor = .white
        title = "ニュース"
        view.addSubview(tableView)
        //コレクションビュー用
        newsManager.analyticsStart(categoryURL: categoryArray[0]) { error in
            if error != nil{
                print(error.debugDescription)
                return
            }
                //tableView用
                self.newsManager.analyticsStart(categoryURL: "") { error in
                    if error != nil{
                        print(error.debugDescription)
                        return
                    }
                    DispatchQueue.main.async {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.register(STNewsTableViewCell.self, forCellReuseIdentifier: STNewsTableViewCell.identifier)
                        self.tableView.reloadData()
                     }
                }
            }
    }
    
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 100
        default:
            return UITableView.automaticDimension
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (newsManager.categoryNewsContentsModel?.articles!.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: STNewsTableViewCell.identifier, for: indexPath) as! STNewsTableViewCell
        for subview in cell.contentView.subviews{
              subview.removeFromSuperview()
        }

//        cell.collectionView?.layoutIfNeeded()
//        cell.collectionView?.reloadData()
        cell.tapCollectionViewCell = self
        cell.urlToImageView.image = nil
        cell.collectionView = nil
        cell.titleLabel.text = nil
        cell.configure(indexPath:indexPath,articles: (newsManager.newsContentsModel?.articles)!,categoryArticles:(newsManager.categoryNewsContentsModel?.articles)!)
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsDetailVC = STNewsDetailVC()
        print(newsManager.categoryNewsContentsModel?.articles![indexPath.row - 1].title!)
        newsDetailVC.newsUrl = (newsManager.categoryNewsContentsModel?.articles![indexPath.row - 1].url)!
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
        
    }
    
    func errorString(errotMessage: String) {
        let alert = UIAlertController(title: errotMessage, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func tapCollectionViewCell(indexPath: IndexPath) {
        let newsDetailVC = STNewsDetailVC()
        newsDetailVC.newsUrl = (newsManager.newsContentsModel?.articles![indexPath.row].url)!
        self.navigationController?.pushViewController(newsDetailVC, animated: true)

    }
    
}

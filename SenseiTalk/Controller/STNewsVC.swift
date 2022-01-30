//
//  STNewsVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class STNewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DoneJsonProtocol {
    
    var tableView = UITableView()
    var newsContentsArray = [NewsContentsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false

    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    

    func configure(){
        view.backgroundColor = .white
        title = "ニュース"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContentsCell.self, forCellReuseIdentifier: ContentsCell.identifier)

        view.addSubview(tableView)
        let networkManager = NetworkManager()
        networkManager.doneJsonProtocol = self
        networkManager.analyticsStart()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsContentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
        cell.configure(newsContentsModel: self.newsContentsArray[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newsDetailVC = STNewsDetailVC()
        newsDetailVC.newsUrl = self.newsContentsArray[indexPath.row].url!
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
        
    }
    
    
    
    func doneJsonAnalytics(newsContentsArray: [NewsContentsModel]) {
        self.newsContentsArray = []
        self.newsContentsArray = newsContentsArray
        tableView.reloadData()
    }
    
    func errorString(errotMessage: String) {
        let alert = UIAlertController(title: errotMessage, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

//
//  STNewsVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class STNewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }

    func configure(){
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentsCell.identifier, for: indexPath) as! ContentsCell
        cell.configure(newsContentsModel: )
        return cell
        
    }
    
    
    

}

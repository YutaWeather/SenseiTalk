//
//  PageViewController.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/26.
//

import UIKit
import TabPageViewController
import Firebase

class PageViewController: TabPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override init() {
        super.init()
        let timelineVC1 = STTimeLineVC()
        timelineVC1.pageNum = 0
        timelineVC1.view.tag = 0
        let timelineVC2 = STTimeLineVC()
        timelineVC2.pageNum = 1
        timelineVC2.view.tag = 1
        let timelineVC3 = STTimeLineVC()
        timelineVC3.pageNum = 2
        timelineVC3.view.tag = 2
        

        tabItems = [(timelineVC1, "小学校"), (timelineVC2, "中学校"),(timelineVC3, "高校")]
        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        option.hidesTopViewOnSwipeType = .all
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "avatar-placeholder")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

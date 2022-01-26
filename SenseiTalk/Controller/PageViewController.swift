//
//  PageViewController.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/26.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timelineVC1 = STTimeLineVC()
        timelineVC1.pageNum = 0
        
        self.setViewControllers([timelineVC1], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        
    }
    
    //    func getFirst() -> STTimeLineVC {
    //        let timelineVC1 = STTimeLineVC()
    //        timelineVC1.pageNum = 0
    //        return timelineVC1
    //    }
    //
    //    func getSecond() -> STTimeLineVC {
    //        let timelineVC2 = STTimeLineVC()
    //        timelineVC2.pageNum = 1
    //        return timelineVC2
    //    }
    //
    //    func getThird() -> STTimeLineVC {
    //        let timelineVC3 = STTimeLineVC()
    //        timelineVC3.pageNum = 2
    //        return timelineVC3
    //    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc:STTimeLineVC = STTimeLineVC()
        vc.pageNum = (viewController as! STTimeLineVC).pageNum - 1
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc:STTimeLineVC = STTimeLineVC() // コード生成したりStoryboardから取ったり
        vc.pageNum = (viewController as! STTimeLineVC).pageNum + 1
        return vc
        
    }
    
    
}

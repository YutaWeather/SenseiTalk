//
//  STTimeLineVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class STTimeLineVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        // Do any additional setup after loading the view.
    }
    
    
    func configure(){
        view.backgroundColor = .systemGray
        title = "タイトル"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

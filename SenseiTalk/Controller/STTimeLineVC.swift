//
//  STTimeLineVC.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import FirebaseAuth

class STTimeLineVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        // Do any additional setup after loading the view.
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

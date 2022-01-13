//
//  STLoadDBModel.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/13.
//

import Foundation
import Firebase

protocol DoneLoad{
    func loadContents(contentsArray:[ContentsModel])
}

class STLoadDBModel{
    
    let db = Firestore.firestore()
    var contentsArray = [ContentsModel]()
    var doneLoad:DoneLoad?
    
    func loadContent(categroy:String){
        
        db.collection("Contents").document(categroy).collection("detail").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    print(data.debugDescription)
                    if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let title = data["title"] as? String,let body = data["body"] as? String{
                            
                            let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                            let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body)
                            self.contentsArray.append(contentsModel)
                    }
                }
                
                self.doneLoad?.loadContents(contentsArray: self.contentsArray)
            }
            
        }
        
    }
    
}

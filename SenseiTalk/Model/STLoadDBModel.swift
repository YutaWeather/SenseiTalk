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
    func likeOrNot(likeContents:[LikeContents])
    func loadComment(commentArray:[CommentContent])
}

class STLoadDBModel{
    
    let db = Firestore.firestore()
    var contentsArray = [ContentsModel]()
    var doneLoad:DoneLoad?
    var likeFlagArray = [LikeContents]()
    var commentArray = [CommentContent]()
    
    func loadContent(categroy:String){
        
        print(categroy)
        db.collection("Contents").document(categroy).collection("detail").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                self.contentsArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let title = data["title"] as? String,let body = data["body"] as? String,let contentID = data["contentID"] as? String{
                            
                            let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID)
                            self.contentsArray.append(contentsModel)
                    }
                }
                
                self.doneLoad?.loadContents(contentsArray: self.contentsArray)
            }
            
        }
        
    }
    
    func loadLike(categroy:String,contentID:String){
        
        db.collection("Contents").document(categroy).collection("detail").document(contentID).collection("like").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                self.likeFlagArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userID = data["userID"] as? String,let like = data["like"] as? Bool,let contentID = data["contentID"] as? String{
                        let likeContents = LikeContents(userID: userID, like: like, contentID: contentID)
                        self.likeFlagArray.append(likeContents)
                    
                    }
                    
                }
               
                self.doneLoad?.likeOrNot(likeContents: self.likeFlagArray)

            }
        }
        
    }
    
    func loadComment(categroy:String,contentID:String){
        db.collection("Contents").document(categroy).collection("detail").document(contentID).collection("comment").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                self.commentArray = []

                for doc in snapShotDoc{
                    let data = doc.data()
                    
                    if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let comment = data["comment"] as? String,let contentID = data["contentID"] as? String{
                        let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                        let commentModel = CommentContent(userModel: userModel, comment: comment, contentID: contentID)
                        self.commentArray.append(commentModel)
                        print(self.commentArray.debugDescription)
                        
                    }
                }
                self.doneLoad?.loadComment(commentArray:self.commentArray)

            }
        }
    }
    
}

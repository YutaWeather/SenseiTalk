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
    func likeOrNot(likeContents:[LikeContents],cell:ContentsCell,indexPath:IndexPath)
    func likeOrNot(likeContents:[LikeContents],cell:STCommentCell,indexPath:IndexPath)
    func likeOrNotForContents(likeContents:[LikeContents])
    func loadComment(commentArray:[CommentContent],cell:ContentsCell,indexPath:IndexPath)
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
        db.collection("Contents").document(categroy).collection("detail").order(by: "date").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                self.contentsArray = []
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let title = data["title"] as? String,let body = data["body"] as? String,let contentID = data["contentID"] as? String{

                        let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)

                        if let likeIDArray = data["likeID"] as? [String]{
                            let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: likeIDArray)
                            self.contentsArray.append(contentsModel)

                        }else{
                            let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: [])
                            self.contentsArray.append(contentsModel)

                        }
                        
                        
                    }
                }
                
                self.doneLoad?.loadContents(contentsArray: self.contentsArray)
            }
            
        }
        
    }
    
    func loadLike(categroy: String, contentID: String){
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
               
                self.doneLoad?.likeOrNotForContents(likeContents: self.likeFlagArray)

            }
        }

    }
    
    func loadLike(categroy:String,contentID:String,cell:ContentsCell,indexPath:IndexPath){
        
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
               
                self.doneLoad?.likeOrNot(likeContents: self.likeFlagArray,cell:cell,indexPath:indexPath)

            }
        }
        
    }
    
    
    //投稿に対するコメント受信
    func loadComment(categroy:String,contentID:String){
        db.collection("Contents").document(categroy).collection("detail").document(contentID).collection("comment").order(by: "date").addSnapshotListener { snapShot, error in
            
            if error != nil{
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                self.commentArray = []

                for doc in snapShotDoc{
                    let data = doc.data()
                    
                    if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let comment = data["comment"] as? String,let contentID = data["contentID"] as? String,let uuid = data["uuid"] as? String{
                        
                        if let likeIDArray = data["likeID"] as? [String]{
                            let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                            let commentModel = CommentContent(userModel: userModel, comment: comment, contentID: contentID, likeIDArray: likeIDArray,uuid:uuid)
                            self.commentArray.append(commentModel)

                        }else{
                            let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                            let commentModel = CommentContent(userModel: userModel, comment: comment, contentID: contentID, likeIDArray: [],uuid: uuid)
                            self.commentArray.append(commentModel)
                        }
                    }
                }
                self.doneLoad?.loadComment(commentArray:self.commentArray)
            }
        }
    }
    
    func loadLike(categroy:String,contentID:String,cell:STCommentCell,indexPath:IndexPath){
        
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
               
                self.doneLoad?.likeOrNot(likeContents: self.likeFlagArray,cell:cell,indexPath:indexPath)

            }
        }
        
    }
    
    
    //コメントへの返信に対するいいねの受信
    func loadCommentLike(categroy:String,contentID:String,cell:STCommentCell,indexPath:IndexPath,commentModel:CommentContent){

        db.collection("Contents").document(categroy).collection("detail").document(contentID).collection("comment").document((commentModel.userModel?.userID)!).collection("like").addSnapshotListener { snapShot, error in
            
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
               
                self.doneLoad?.likeOrNot(likeContents: self.likeFlagArray,cell:cell,indexPath:indexPath)

            }
        }
        
    }

    
}


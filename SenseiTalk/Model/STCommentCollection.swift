//
//  STContentsCollection.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/28.
//

import Foundation
import Firebase
import FirebaseFirestore

class STCommentCollection{
    
    var commentArray = [CommentContent]()
//    var likeIDArray = [String]()
    //分割して取得していくので、最後に取得したドキュメントのスナップショットを保持する
    var lastDocument: DocumentSnapshot?
    var checkLastDocument:DocumentSnapshot?
    
    func fetchContent(categroy:String,contentID:String,limit:Int,completed:@escaping() -> Void){
      
        let db = Firestore.firestore()
        db.collection("Contents").document(categroy).collection("detail").document(contentID).collection("comment").order(by: "date").addSnapshotListener { querySnapshot, error in

            if error != nil{
                completed()
                return
            }
            
            self.commentArray.removeAll()
            guard let snapShot = querySnapshot else{
                completed()
                return
            }
            
            self.lastDocument = snapShot.documents.last

            for doc in snapShot.documents{
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
            
            completed()
            
        }
    }
    
    
    //fetchMore
    func fetchMoreContent(categroy:String,contentID:String,limit:Int,completed:@escaping() -> Void){
        guard let lastDocument = lastDocument else {
            //全ての記事を取得し終わったら、lastDocumentはnilになります。
            print("終わり")
            completed()
            return
        }
        let db = Firestore.firestore()
        
        db.collection("Contents").document(categroy).collection("detail").document(contentID).collection("comment").order(by: "date").addSnapshotListener { querySnapshot, error in

            if error != nil{
                completed()
                return
            }
            
            guard let snapShot = querySnapshot else{
                completed()
                return
            }
            
            self.checkLastDocument = self.lastDocument
            
            self.lastDocument = snapShot.documents.last
            
            if self.lastDocument == self.checkLastDocument{
                print("最後がまだ同じ")
                return
            }else{
                print("最後が変わった")
            
            }
            
            for doc in snapShot.documents{
            
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
            print("更新")
            completed()
            
        }
    }
    
}

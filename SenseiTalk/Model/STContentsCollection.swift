//
//  STContentsCollection.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/28.
//

import Foundation
import Firebase
import FirebaseFirestore

var statusCheck = Bool()

class STContentsCollection{
    
    var commentArray = [CommentContent]()
    var likeIDArray = [String]()
    var commentIDArray = [String]()
    
    var contentsArray: [ContentsModel] = [] //取得した記事を格納する配列
    var lastDocument: DocumentSnapshot?
    //分割して取得していくので、最後に取得したドキュメントのスナップショットを保持する
    
    var checkLastDocument:DocumentSnapshot?
    
    func fetchContent(categroy:String,limit:Int,completed:@escaping() -> Void){
      
        let db = Firestore.firestore()
        db.collection("Contents").document(categroy).collection("detail").order(by: "date").limit(to:limit).addSnapshotListener { querySnapshot, error in
            
            if error != nil{
                completed()
                return
            }
            
            self.contentsArray.removeAll()
            guard let snapShot = querySnapshot else{
                completed()
                return
            }
            
            self.lastDocument = snapShot.documents.last
            print(self.lastDocument?.data())
            for doc in snapShot.documents{
                let data = doc.data()
                if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let title = data["title"] as? String,let body = data["body"] as? String,let contentID = data["contentID"] as? String,let date = data["date"] as? Double{
                    
                    let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                    
                    if data["likeID"] as? [String] != nil && data["commentID"] as? [String] != nil{
                        
                        self.likeIDArray = data["likeID"] as! [String]
                        self.commentIDArray = data["commentID"] as! [String]
                        
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: self.likeIDArray, commentIDArray: self.commentIDArray)
                        self.contentsArray.append(contentsModel)

                    }else if data["likeID"] as? [String] != nil && data["commentID"] as? [String] == nil{
                        self.likeIDArray = data["likeID"] as! [String]
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: self.likeIDArray, commentIDArray: [])
                        self.contentsArray.append(contentsModel)
                        
                    }else if data["likeID"] as? [String] == nil && data["commentID"] as? [String] != nil{
                        
                        self.commentIDArray = data["commentID"] as! [String]
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: [], commentIDArray: self.commentIDArray)
                        self.contentsArray.append(contentsModel)
                    }else{
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: [], commentIDArray: [])
                        self.contentsArray.append(contentsModel)
                    }
                }
            }
            
            completed()
            
        }
    }
    
    
    //fetchMore
    func fetchMoreContent(categroy:String,limit:Int,completed:@escaping() -> Void){
        guard let lastDocument = lastDocument else {
            //全ての記事を取得し終わったら、lastDocumentはnilになります。
            print("終わり")
            completed()
            return
        }
        let db = Firestore.firestore()
        db.collection("Contents").document(categroy).collection("detail").order(by: "date").start(afterDocument: self.lastDocument!).limit(to:limit).getDocuments() { (querySnapshot, error) in
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
//                statusCheck = true
                return
            }else{
                    
                print("最後が変わった")
//                statusCheck = false
            
            }
            
            for doc in snapShot.documents{
            
                let data = doc.data()
                
                if let userName = data["userName"] as? String,let userID = data["userID"] as? String,let profileImageURL = data["profileImageURL"] as? String,let category = data["category"] as? String,let title = data["title"] as? String,let body = data["body"] as? String,let contentID = data["contentID"] as? String,let date = data["date"] as? Double{
                
                    let userModel = UserModel(userName: userName, profileImageURL: profileImageURL, userID: userID)
                    
                    if data["likeID"] as? [String] != nil && data["commentID"] as? [String] != nil{
                        self.likeIDArray = data["likeID"] as! [String]
                        self.commentIDArray = data["commentID"] as! [String]
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: self.likeIDArray, commentIDArray: self.commentIDArray)
                        self.contentsArray.append(contentsModel)
                    
                    }else if data["likeID"] as? [String] != nil && data["commentID"] as? [String] == nil{
                        self.likeIDArray = data["likeID"] as! [String]
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: self.likeIDArray, commentIDArray: [])
                        self.contentsArray.append(contentsModel)
                    
                    }else if data["likeID"] as? [String] == nil && data["commentID"] as? [String] != nil{
                        self.commentIDArray = data["commentID"] as! [String]
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: [], commentIDArray: self.commentIDArray)
                        self.contentsArray.append(contentsModel)
                    
                    }else{
                        let contentsModel = ContentsModel(userModel: userModel, category: category, title: title, body: body,contentID:contentID, likeIDArray: [], commentIDArray: [])
                        self.contentsArray.append(contentsModel)
                    }
                }
            }
            print("更新")
            completed()
            
        }
    }
    
}

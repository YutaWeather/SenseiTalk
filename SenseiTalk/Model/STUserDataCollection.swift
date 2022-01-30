//
//  STUserDataCollection.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/29.
//

import Foundation
import Firebase
import FirebaseFirestore

class STUserDataCollection{
 
    var likeIDArray = [String]()
    var commentIDArray = [String]()
    var contentsArray: [ContentsModel] = [] //取得した記事を格納する配列
    var lastDocument: DocumentSnapshot?
    //分割して取得していくので、最後に取得したドキュメントのスナップショットを保持する
    
    var checkLastDocument:DocumentSnapshot?
    
    func fetchUserDataCollection(userID:String,limit:Int,completed:@escaping() -> Void){
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("myContents").order(by: "date").limit(to:5).addSnapshotListener { querySnapshot, error in

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

    func fetchMoreUserDataCollection(userID:String,limit:Int,completed:@escaping() -> Void){
        guard let lastDocument = lastDocument else {
            //全ての記事を取得し終わったら、lastDocumentはnilになります。
            print("終わり")
            completed()
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("myContents").order(by: "date").limit(to:5).getDocuments() { (querySnapshot, error) in
            if error != nil{
                completed()
                return
            }
            self.contentsArray.removeAll()
            guard let snapShot = querySnapshot else{
                completed()
                return
            }
            
            self.checkLastDocument = self.lastDocument
            
            self.lastDocument = snapShot.documents.last
            
            if self.lastDocument == self.checkLastDocument{
                return
            }else{
                print("最後が変わった")            
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
            completed()
        }
        
    }
    
}

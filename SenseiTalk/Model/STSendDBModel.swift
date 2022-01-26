//
//  STSendDBModel.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/12.
//

import Foundation
import Firebase

protocol DoneSend{
    
    func doneSendData()
    
}

class STSendDBModel{
    
    let db = Firestore.firestore()
    var doneSend:DoneSend?
    
   
    func sendProfileData(userName:String,profileImageData:Data){
        
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImageData, metadata:nil) { (metaData, error) in
            if error != nil{
                return
            }
            imageRef.downloadURL { (url, error) in
                if error != nil{
                    return
                }
                if url != nil{
                    let userModel = UserModel(userName:userName, profileImageURL: url?.absoluteString, userID: Auth.auth().currentUser!.uid)
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                        ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":url?.absoluteString]
                    )
                    KeyChainConfig.setKeyData(userValue:UserModel(userName: userName, profileImageURL: url?.absoluteString, userID: Auth.auth().currentUser!.uid), key: "userData")
                }
                self.doneSend?.doneSendData()
            }
        }
    }

    
    func sendContents(category:String,title:String,body:String){

        //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        let uuid = UUID().uuidString
        self.db.collection("Contents").document(category).collection("detail").document(uuid).setData(
            ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":userModel.profileImageURL!,"category":category,"title":title,"body":body,"contentID":uuid,"date":Date().timeIntervalSince1970]
        )
        self.doneSend?.doneSendData()
        
    }
    
    //コンテンツに対するいいね機能
    func sendLikeContents(category:String,contentID:String,likeIDArray:[String],checkLike:Bool){
        var checkLikeIDArray = likeIDArray
        //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        if let index = checkLikeIDArray.firstIndex(where: { $0 == Auth.auth().currentUser?.uid }) {
            checkLikeIDArray.remove(at: index)
        }else{
            checkLikeIDArray.append(userModel.userID!)
        }
        self.db.collection("Contents").document(category).collection("detail").document(contentID).setData(
            ["likeID":checkLikeIDArray],merge: true
        )
        
    }

    
    
    //コメントへの返信に対するいいね☆
    func sendLikeContentsToComment(category:String,contentID:String,checkLike:Bool,commentModel:CommentContent,likeIDArray:[String]){
        
        //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        var checkLikeIDArray = likeIDArray
        if let index = checkLikeIDArray.firstIndex(where: { $0 == Auth.auth().currentUser?.uid }) {
            checkLikeIDArray.remove(at: index)
        }else{
            checkLikeIDArray.append(userModel.userID!)
        }
        self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("comment").document((commentModel.uuid)!).setData(
            ["likeID":checkLikeIDArray],merge: true
        )
        
        
    }
    

    func sendLikeForCommentContents(category:String,contentID:String,checkLike:Bool,commentModel:CommentContent){
        
        //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        
        if checkLike == true{
            
            self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("comment").document((commentModel.userModel?.userID)!).collection("like").document(Auth.auth().currentUser!.uid).delete()
            
        }else{
            self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("comment").document((commentModel.userModel?.userID)!).collection("like").document(Auth.auth().currentUser!.uid).setData(
                ["userID":userModel.userID!,"like":true,"contentID":contentID]
            )
        }
        
        
    }

    //コメント機能
    func sendComment(category:String,contentID:String,comment:String,uuid:String,commentIDArray:[String]){
        //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        
        self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("comment").document(uuid).setData(
            ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":userModel.profileImageURL!,"category":category,"comment":comment,"contentID":contentID,"uuid":uuid,"date":Date().timeIntervalSince1970]
        )
        
        self.db.collection("Contents").document(category).collection("detail").document(contentID).setData(
            ["commentID":commentIDArray],merge: true

        )
        

    }
    
}


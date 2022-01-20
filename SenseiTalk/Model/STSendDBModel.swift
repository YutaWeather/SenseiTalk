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
    
//    func createProfileData(userModel:UserModel){
//
//        db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
//            ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":userModel.profileImageURL!]
//        )
//
//    }
    
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
            ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":userModel.profileImageURL!,"category":category,"title":title,"body":body,"contentID":uuid]
        )
        self.doneSend?.doneSendData()
        
    }
    
    //いいね機能
//    func sendLikeContents(category:String,contentID:String,like:Bool,checkLike:Bool){
    func sendLikeContents(category:String,contentID:String,checkLike:Bool){

    //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        
        if checkLike == true{
            self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        }else{
            self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("like").document(Auth.auth().currentUser!.uid).setData(
                ["userID":userModel.userID!,"like":true,"contentID":contentID]
            )
        }

        
    }
    
    //コメント機能
    func sendComment(category:String,contentID:String,comment:String){
        //アプリ内からUserData取り出し
        let userModel:UserModel = KeyChainConfig.getKeyData(key: "userData")
        
        self.db.collection("Contents").document(category).collection("detail").document(contentID).collection("comment").document(Auth.auth().currentUser!.uid).setData(
            ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":userModel.profileImageURL!,"category":category,"comment":comment,"contentID":contentID]
        )

    }
    
}

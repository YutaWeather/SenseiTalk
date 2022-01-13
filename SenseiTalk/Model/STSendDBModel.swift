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
//                    KeyChainConfig.setKeyData(userValue: User(userId: Auth.auth().currentUser!.uid, urlString: url!.absoluteString, userName: userName), key: "userData")
                }
                self.doneSend?.doneSendData()
            }
        }
    }

    
    func sendContents(category:String,title:String,body:String){

        //アプリ内からUserData取り出し
        self.db.collection("Contents").document("categoryID").collection("detail").document().setData(
//            ["userName":userModel.userName!,"userID":userModel.userID!,"profileImageURL":url?.absoluteString,"category":category,"title":title,"body":body]
            ["userName":"userName","userID":"userID","profileImageURL":"profileImageURL","category":category,"title":title,"body":body]
        )
        
    }
    
}

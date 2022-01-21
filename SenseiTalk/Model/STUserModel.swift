//
//  STUserModel.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/12.
//

import Foundation

struct UserModel:Codable{
    
    let userName:String?
    let profileImageURL:String?
    let userID:String?
    
}

struct ContentsModel{
    
    let userModel:UserModel?
    let category:String?
    let title:String?
    let body:String?
    let contentID:String?
    let likeIDArray:[String]?
    
}

struct LikeContents{
    let userID:String?
    let like:Bool?
    let contentID:String?
}

struct CommentContent{
    let userModel:UserModel?
    let comment:String?
    let contentID:String?
    let likeIDArray:[String]?
    let uuid:String?
}



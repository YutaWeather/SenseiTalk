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
    
}

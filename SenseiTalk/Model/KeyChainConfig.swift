//
//  KeyChainConfig.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/13.
//

import Foundation
import KeychainSwift

class KeyChainConfig{
    
    static func getKeyData(key:String)->UserModel{
        let keychain = KeychainSwift()
        let userData = keychain.getData(key)
        let user = try! JSONDecoder().decode(UserModel.self, from: userData!)
        
        return user
    }

    static func setKeyData(userValue:UserModel,key:String){
        
        let keychain = KeychainSwift()
        let data = try! JSONEncoder().encode(userValue)
        keychain.set(data, forKey: key)
        
     
    }


}

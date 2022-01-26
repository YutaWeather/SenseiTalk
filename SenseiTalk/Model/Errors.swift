//
//  Errors.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/26.
//

import Foundation

enum FetchErrors:Error{
    
    case noResult
    case someError
    
    var title:String{
        
        switch self{
        case .noResult:return "結果がありませんでした。"
        case .someError:return "予期せぬエラーが発生しました。"
        }
    }
    
}

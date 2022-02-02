//
//  STAlertNotification.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/02/02.
//

import Foundation
import ImpressiveNotifications

class STAlertNotification{
    
    static func alert(text:String){

        INNotifications.show(type: .warning, data: INNotificationData(title:text, description: "",completionHandler: {
            print("チェック")
        }))
        
    }
    
}

//
//  AppDelegate.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import KeychainSwift
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let reachability = try! Reachability()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        checkNetworkState()
        
        FirebaseApp.configure()
//                ログアウト
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//        let keychain = KeychainSwift()
//        keychain.clear() // Delete everything from app's Keychain. Does not work on macOS.

        IQKeyboardManager.shared.enable = true

        return true
    }
    
    func checkNetworkState(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
               try? reachability.startNotifier()
        
        reachability.whenUnreachable = { reachability in
            print(reachability.connection)
        }
        try? reachability.startNotifier()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

         switch reachability.connection {
         case .wifi:
             print("Reachable via WiFi")
         case .cellular:
             print("Reachable via Cellular")
         case .unavailable:
           print("Network not reachable")
             STAlertNotification.alert(text: NetWorkErrors.unSatisfied.title)
         case .none:
             break
         }
        
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


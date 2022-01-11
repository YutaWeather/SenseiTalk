//
//  SceneDelegate.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        self.window?.rootViewController = createTabbar()
        self.window?.makeKeyAndVisible()
        
    }

    func createTopMenuNav() -> UINavigationController{
        let timeLineVC = STTimeLineVC()
        let nav = UINavigationController(rootViewController: timeLineVC)
        nav.tabBarItem = UITabBarItem(title: "タイムライン", image:UIImage(named: ""), tag: 0)
        nav.navigationBar.backgroundColor = .white
        nav.navigationBar.barTintColor = .black
        
        return nav
    }

    func createTopMenuNav2() -> UINavigationController{
        let newsVC = STNewsVC()
        let nav = UINavigationController(rootViewController: newsVC)
        nav.tabBarItem = UITabBarItem(title: "ニュース", image:UIImage(named: ""), tag: 1)
        return nav
    }

    func createTopMenuNav3() -> UINavigationController{
        let timeLineVC = STTimeLineVC()
        let nav = UINavigationController(rootViewController: timeLineVC)
        nav.tabBarItem = UITabBarItem(title: "タイムライン", image:UIImage(named: ""), tag: 2)
        return nav
    }

    
    func createTabbar() -> UITabBarController{
        
        let tabbar = UITabBarController()
        tabbar.tabBar.backgroundColor = .white
        tabbar.viewControllers = [createTopMenuNav(),createTopMenuNav2(),createTopMenuNav3()]
        
        return tabbar
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


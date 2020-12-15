//
//  SceneDelegate.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/8/20.
//

import UIKit
 
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //create my UIWindow
        guard let windowScene = scene as? UIWindowScene else {return}
        let window = UIWindow(windowScene: windowScene)
        
        //creating navigation controller and setting HomeController(:UICollectionViewController) as nav's root controller
        let collectionViewLayout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: HomeController(collectionViewLayout: collectionViewLayout))
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        self.window = window
    }

}


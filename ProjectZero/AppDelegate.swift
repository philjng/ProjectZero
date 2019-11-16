//
//  AppDelegate.swift
//  ProjectZero
//
//  Created by phing on 2019-11-08.
//  Copyright © 2019 phing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = blue5
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        Thread.sleep(forTimeInterval: 2.0)
        let userData =  UserData()
        
        // check if all register information required (name, avatar, color) is filled
        if (userData.hasDataFilled) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let navigationController:UINavigationController = UINavigationController(rootViewController: viewController);
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        return true
    }
}


//
//  AppDelegate.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/21.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupAddition()
        
        window = UIWindow();
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = XKMainController()
        
        window?.makeKeyAndVisible()
        
        loadAppInfo()
        
        return true
    }
}

extension AppDelegate {
    
    fileprivate func loadAppInfo() {
        
        DispatchQueue.global().async {
            
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            let data = NSData(contentsOf: url!)
            
            let docDir = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0]
            
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}

extension AppDelegate {
    
    fileprivate func setupAddition() {
        
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (success, error) in
                
            }
        } else {
            
            let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
        }
    }
}


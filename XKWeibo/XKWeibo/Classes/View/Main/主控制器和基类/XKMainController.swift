//
//  XKTabBarController.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/21.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import SVProgressHUD

class XKMainController: UITabBarController {
    
    fileprivate var timer: Timer?
    
    fileprivate lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupChildControllers()
        
        setupComposeButton()
        
        setupTimer()
        
        setupNewFeatureView()
        
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: XKUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        timer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func userLogin(notification: Notification) {
        
        
        var when = DispatchTime.now()
        
        
        if notification.object != nil {
            
            SVProgressHUD.setDefaultMaskType(.gradient)
            
            SVProgressHUD.showInfo(withStatus: "您需要重新登录")
            
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) { 
            
            let nav = UINavigationController(rootViewController: XKOAuthController())
            
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: -点击事件的处理
    @objc fileprivate func handleComposeButtonEvent() {
        
        print("点击了中间的按钮")
        
    }
}

extension XKMainController {
    
    fileprivate func setupNewFeatureView() {
        
        let  xkViwe = isNewFeature ? XKNewFeatureView() : XKWelcomeView()
        
        xkViwe.frame = view.bounds
        
        view.addSubview(xkViwe)
    }
    
    private var isNewFeature:Bool {
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        let sandboxVersion = UserDefaults.standard.string(forKey: "kCurrentVersionKey")
        
        UserDefaults.standard.set(currentVersion, forKey: "kCurrentVersionKey")
        
        return currentVersion != sandboxVersion
    }
}

extension XKMainController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = childViewControllers.index(of: viewController)
        
        if selectedIndex == 0 && index == selectedIndex {
            
            let nav = childViewControllers[0] as! UINavigationController
            
            let vc = nav.childViewControllers[0] as! XKHomeViewController
            
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                
                vc.loadData()
                
            })
            
            vc.tabBarItem.badgeValue = nil
            
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 定时器相关方法
extension XKMainController {
    
    fileprivate func setupTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
    }
    
    @objc private func updateTimer() {
        
        if !XKNetworkingManager.shared.userLogon {
            
            return
        }
        
        XKNetworkingManager.shared.unreadCount { (count) in
            
            print("有\(count)条数据更新")
            
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// MARK: - 设置界面
extension XKMainController {
    
    // MARK: -设置页面
    fileprivate func setupComposeButton() {
        
        tabBar.addSubview(composeButton)
        
        let count = CGFloat(childViewControllers.count)
        
        let width = tabBar.bounds.width / count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
        composeButton.addTarget(self, action: #selector(handleComposeButtonEvent), for: .touchUpInside)
        
    }
    
    /// 设置子控制器
    fileprivate func setupChildControllers() {
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        // 加载 data
        var data = NSData(contentsOfFile: jsonPath)
        
        if data == nil {
            
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            
            data = NSData(contentsOfFile: path!)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
            else {
                return
        }
        
        var arrayM = [UIViewController]()
        
        for dict in array! {
            
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 属性字典
    /// - Returns: 返回一个导航栏包装的视图控制器
    fileprivate func controller(dict:[String:AnyObject]) -> UIViewController {
        
        guard let className = dict["className"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? XKBasicViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String: String] else {
                
                return UIViewController()
        }
        
        let viewController = cls.init()
        
        viewController.title = title
        
        viewController.visitorInfoDictionary = visitorDict
        
        viewController.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        
        viewController.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        viewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected)
        
        let navigationController = XKNavigationController(rootViewController:viewController);
        
        return navigationController
    }
}

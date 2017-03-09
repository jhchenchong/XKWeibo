//
//  XKNavigationController.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/21.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true;
    }

    // MARK: -重写push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            if let viewController = viewController as? XKBasicViewController {
                
                var title = "返回"
                
                if childViewControllers.count == 1 {
                    
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                viewController.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popBackPresent), isBack: true)
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }

    @objc fileprivate func popBackPresent() {
        
        popViewController(animated: true)
    }
}

//
//  UIBarButtonItem+Extension.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/22.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    
    /// 创建UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize
    ///   - target: target
    ///   - action: action
    ///   - isBack: action
    convenience init(title:String, fontSize:CGFloat = 16, target:AnyObject?, action:Selector, isBack:Bool = false) {
        let button:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBack {
            
            let imageName = "navigationbar_back_withtext"
            
            button.setImage(UIImage(named: imageName), for: .normal)
            
            button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            
            button.sizeToFit()
        }
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
}

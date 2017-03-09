//
//  Bundle+Extension.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/21.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation

extension Bundle {
    
    
    /// 一个没有参数 一定有返回值的计算属性 类似于函数
    var namespace:String {
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    
}

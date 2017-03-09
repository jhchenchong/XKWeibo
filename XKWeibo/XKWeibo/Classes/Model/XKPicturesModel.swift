//
//  XKPicturesModel.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKPicturesModel: NSObject {

    var thumbnail_pic: String? {
        
        didSet {
            
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    var largePic: String?
    
    
    override var description: String {
        
        return yy_modelDescription()
    }
}

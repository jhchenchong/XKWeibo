//
//  XKUser.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKUser: NSObject {

    var id: Int64 = 0
    /// 用户昵称
    var screen_name: String?
    /// 用户头像
    var profile_image_url: String?
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = 0
    /// 会员等级 0-6
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}

//
//  XKStatus.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/25.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import YYModel

class XKStatus: NSObject {
    
    var id: Int64 = 0
    
    var text: String?
    
    var created_at: String? {
        didSet {
            
            createdDate = Date.cz_sinaDate(string: created_at ?? "")
        }
    }
    
    var createdDate: Date?
    
    var source: String? {
        didSet {
            
            source = "来自 " + (source?.cz_href()?.text ?? "")
        }
    }
    
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 点赞数
    var attitudes_count: Int = 0
    
    /// 微博的用户 - 注意和服务器返回的 KEY 要一致
    var user: XKUser?
    
    /// 被转发的原创微博
    var retweeted_status: XKStatus?
    
    /// 微博配图模型数组
    var pic_urls: [XKPicturesModel]?
    
    /// 重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": XKPicturesModel.self]
    }

}

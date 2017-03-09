//
//  XKUserAccount.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/26.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

private let accountFile: NSString = "userAccount.json"

class XKUserAccount: NSObject {
    
    var access_token: String? 
    
    var uid: String?
    
    var expires_in: TimeInterval = 0.0 {
        didSet {
            
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    var expiresDate: Date?
    
    var screen_name: String?
    
    var avatar_large: String?
    
    override var description: String {
        
        return yy_modelDescription()
    }
    
    override init() {
        
        super.init()
        
        
        guard let path = accountFile.cz_appendDocumentDir(),
              let data = NSData(contentsOfFile: path),
              let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
            return
        }
        
        yy_modelSet(withJSON: dict ?? [:])
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            
            print("用户过期")
            
            access_token = nil
            
            uid = nil
            
            _ = try? FileManager.default.removeItem(atPath: path)
        }
        
        print("用户正常")
    }
    
    func saveAccount() {
        
        var dict = self.yy_modelToJSONObject() as? [String: AnyObject] ?? [:]
        
        dict.removeValue(forKey: "expires_in")
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let filePath = accountFile.cz_appendDocumentDir()  else {
            
                return
        }
        
        (data as NSData).write(toFile: filePath, atomically: true)
    }
}

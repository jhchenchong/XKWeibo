//
//  XKNetworkingManager+Extension.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/25.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation

extension XKNetworkingManager {
    
    func statusList(since_id :Int64, max_id :Int64, completion: @escaping (_ list: [[String :AnyObject]]?, _ isSuccess :Bool) -> ()) {
        
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["since_id":"\(since_id)", "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        
        tokenRequest(url: url, parameters: parameters) { (result, isSuccess) in
            
            let list = result?["statuses"] as? [[String :AnyObject]]
            
            completion(list, isSuccess)
        }
    }
    
    func unreadCount(completion :@escaping (_ count :Int) -> ()) {
        
        guard let uid = userAccount.uid else {
            
            return
        }
        
        let url = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let parameters = ["uid":uid]
        
        tokenRequest(url: url, parameters: parameters) { (result, isSuccess) in
            
            let dict = result as? [String :AnyObject]
            
            let count = dict?["status"] as? Int
            
            completion(count ?? 0)
        }
    }
}

extension XKNetworkingManager {
    
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()) {
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["uid": uid]
        
        tokenRequest(url: urlString, parameters: parameters) { (result, isSuccess) in
            
            completion(result as? [String: AnyObject] ?? [:])
        }
    }
}

extension XKNetworkingManager {
    
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id": XKAppKey,
                      "client_secret": XKAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": XKRedirectURI]
        
        request(method: .POST, url: urlString, parameters: params) { (result, isSuccess) in
            
            self.userAccount.yy_modelSet(withJSON: result as? [String: AnyObject] ?? [:])
            
            self.loadUserInfo(completion: { (dict) in
                
                self.userAccount.yy_modelSet(with: dict)
                
                self.userAccount.saveAccount()
                
                completion(isSuccess)
            })
        }
    }
}

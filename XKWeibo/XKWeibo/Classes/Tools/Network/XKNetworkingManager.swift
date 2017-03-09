//
//  XKNetworkingManager.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/23.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import Alamofire

enum XKHTTPMethod {
    case POST
    case GET
}

class XKNetworkingManager {

    static let shared = XKNetworkingManager()
    
    lazy var userAccount = XKUserAccount()
    
    var userLogon: Bool {
        
        return userAccount.access_token != nil
    }
    
    
    func tokenRequest(method:XKHTTPMethod = .GET, url:String, parameters:[String:Any]?, completion:@escaping (_ result:AnyObject?, _ isSuccess:Bool) -> Void) {
        
        guard let token = userAccount.access_token else {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: XKUserShouldLoginNotification), object: "bad token")
            
            completion(nil, false)
            
            return
        }
        
        var parameters = parameters
        
        
        if parameters == nil {
            
            parameters = [String :AnyObject]()
        }
        
        parameters!["access_token"] = token
        
        request(url: url, parameters: parameters, completion: completion)
    }
    
    func request(method:XKHTTPMethod = .GET, url:String, parameters:[String:Any]?, completion:@escaping (_ result:AnyObject?, _ isSuccess:Bool) -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if method == .GET {
            
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON(completionHandler: { response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                    
                case .success:
                    
                    guard let result = response.result.value else {
                        
                        return
                    }
                    
                    if response.response?.statusCode == 403 {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XKUserShouldLoginNotification), object: "bad token")
                    }
                    
                    completion(result as AnyObject, true)
                    
                    break
                    
                case .failure:
                    
                    completion(nil, false)
                    
                    break
                }
            })
            
        } else {
            
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                    
                case .success:
                    
                    guard let result = response.result.value else {
                        
                        return
                    }
                    
                    completion(result as AnyObject, true)
                    
                    break
                    
                case .failure:
                    
                    completion(nil, false)
                    
                    break
                }
            })
        }
    }
}

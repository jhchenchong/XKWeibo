//
//  XKStatusListViewModel.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/25.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation
import YYWebImage

private var maxPullupTryTimes = 3

class XKStatusListViewModel {
    
    lazy var statusList = [XKStatusViewModel]()
    
    private var pullupErrorTimes = 0
    
    func loadStatus(pullup: Bool = false, completion:@escaping (_ isSuccess :Bool, _ shouldRefresh: Bool) ->())  {
        
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            
            completion(false, false)
            
            return
        }
        
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        XKNetworkingManager.shared.statusList(since_id: since_id, max_id: max_id) { (result, isSuccess) in
            
            if !isSuccess {
                
                completion(false, false)
                
                return
            }
            
            var array = [XKStatusViewModel]()
            
            for dict in result ?? [] {
                
                guard let model = XKStatus.yy_model(with: dict) else {
                    
                    continue
                }
                array.append(XKStatusViewModel(model: model))
            }
            
            print(array.count)
            
            pullup ? (self.statusList += array) : (self.statusList = array + self.statusList)
            
            if pullup && array.count == 0 {
                
                maxPullupTryTimes += 1
                
                completion(isSuccess, false)
                
            } else {
               
                self.cacheSingleImage(list: array, completion: completion)
            }
        }
    }
    
    private func cacheSingleImage(list: [XKStatusViewModel], completion:@escaping (_ isSuccess :Bool, _ shouldRefresh: Bool) ->()) {
        
        let group = DispatchGroup()
        
        var length = 0
        
        for viewModel in list {
            
            if viewModel.picURLs?.count != 1 {
                
                continue
            }
            
            guard let pic = viewModel.picURLs?[0].thumbnail_pic,
            let url = URL(string: pic) else {
                continue
            }
            
            group.enter()
            
            YYWebImageManager.shared().requestImage(with: url, options: [], progress: nil, transform: nil, completion: { (image, _, _, _, _) in
                
                if let image = image,
                    
                    let data = UIImagePNGRepresentation(image) {
                    
                    length += data.count
                    
                    viewModel.updateSingleImageSize(image: image)
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) { 
            
            completion(true, true)
        }
    }
}

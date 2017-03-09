//
//  UIImageView+WebImage.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import YYWebImage

extension UIImageView {
    
    func cc_setImage(urlString: String?, placeholder: UIImage?, backColor: UIColor = UIColor.white, isAvatar: Bool = false) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            
            image = placeholder
            
            return
        }
        
        yy_setImage(with: url, placeholder: placeholder, options: []) { (image,  _, _, _, _) in
            
            if isAvatar {
                
                self.image = image?.cc_avatarImage(size: self.bounds.size, backColor: backColor)
            }
        }
    }
}

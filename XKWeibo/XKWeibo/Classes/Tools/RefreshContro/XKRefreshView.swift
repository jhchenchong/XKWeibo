//
//  XKRefreshView.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/29.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKRefreshView: CCRefreshView {

    @IBOutlet weak var buildingIconView: UIImageView!
    
    @IBOutlet weak var earthIconView: UIImageView!
    
    @IBOutlet weak var kangarooIconView: UIImageView!

    override var parentViewHeight: CGFloat {
        didSet {
            
            if parentViewHeight < 23 {
                return
            }
            
            var scale: CGFloat
            
            if parentViewHeight > 126 {
                scale = 1
            } else {
                scale = 1 - ((126 - parentViewHeight) / (126 - 23))
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    override func awakeFromNib() {
        
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingIconView.image = UIImage.animatedImage(with: [bImage1, bImage2], duration: 0.5)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        
        anim.isRemovedOnCompletion = false
        
        earthIconView.layer.add(anim, forKey: nil)
        
        let kImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        
        kangarooIconView.image = UIImage.animatedImage(with: [kImage1, kImage2], duration: 0.5)
        
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 23
        kangarooIconView.center = CGPoint(x: x, y: y)
        
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
}

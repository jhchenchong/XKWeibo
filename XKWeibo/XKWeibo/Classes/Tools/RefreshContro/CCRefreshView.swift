//
//  CCRefreshView.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/29.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class CCRefreshView: UIView {
    
    
    var refreshState: CCRefreshState = .Normal {
        
        didSet {
            switch refreshState {
            case .Normal:
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                
                tipLabel?.text = "继续使劲拉..."
                
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel?.text = "放手就刷新..."
                
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.001))
                }
            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                
                tipIcon?.isHidden = true
                
                indicator?.startAnimating()
            }
        }
    }
    
    var parentViewHeight: CGFloat = 0
    
    @IBOutlet weak var tipIcon: UIImageView?
    
    @IBOutlet weak var tipLabel: UILabel?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    class func refreshView() -> CCRefreshView {
        
        let nib = UINib(nibName: "XKRefreshView", bundle: nil)
        
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CCRefreshView
    }

}

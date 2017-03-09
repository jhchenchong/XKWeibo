//
//  XKWelcomeView.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/26.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import YYWebImage

class XKWelcomeView: UIView {

    lazy var iconView: UIImageView = UIImageView()
    
    lazy var tipLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        iconView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(center)
            
            make.width.equalTo(85)
            
            make.height.equalTo(85)
            
            make.bottom.equalTo(snp.bottom).offset(-160)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(center)
            
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
        
        super.updateConstraints()
    }
    
    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { 
            
            self.iconView.snp.updateConstraints({ (make) in
                
                make.bottom.equalTo(self.snp.bottom).offset(-UIScreen.cz_screenHeight() + 200)
            })
            
            self.layoutIfNeeded()
            
        }) { (_) in
            
            UIView.animate(withDuration: 1, animations: { 
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                
                UIView.animate(withDuration: 1, animations: { 
                  
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    
                    self.alpha = 0
                    
                }, completion: { (_) in
                    
                    self.removeFromSuperview()
                })
            })
        }
    }
}

extension XKWelcomeView {
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.white
        
        tipLabel.text = "欢迎归来"
        
        tipLabel.alpha = 0
        
        let imageView:UIImageView = UIImageView(image: UIImage(named: "ad_background"))
        
        addSubview(imageView)
        
        addSubview(iconView)
        
        addSubview(tipLabel)
        
        setNeedsUpdateConstraints()
        
        guard let url = XKNetworkingManager.shared.userAccount.avatar_large else {
            
            return
        }
        
        iconView.cc_setImage(urlString: url, placeholder: #imageLiteral(resourceName: "avatar_default_big"), backColor: UIColor.cz_color(withRed: 248, green: 248, blue: 248), isAvatar: true)
    }
}

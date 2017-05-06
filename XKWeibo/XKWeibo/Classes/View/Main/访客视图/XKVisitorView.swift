//
//  XKVisitorView.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/24.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import SnapKit

class XKVisitorView: UIView {
    
    lazy var loginButton: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.darkGray, backgroundImageName: "common_button_white_disable")
    
    lazy var registorButton: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.darkGray, backgroundImageName: "common_button_white_disable")
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    var visitorInfo: [String: String]? {
        didSet {
            
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    
                    return
            }
            
            tipLabel.text = message
            
            if imageName == "" {
                
                startAnimation()
                
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            houseIconView.isHidden = true
            
            maskIconView.isHidden = true
            
            setNeedsUpdateConstraints()
        }
    }
    
    private func startAnimation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * Double.pi
        
        anim.repeatCount = MAXFLOAT
        
        anim.duration = 15
        
        anim.isRemovedOnCompletion = false
        
        iconView.layer.add(anim, forKey: nil)
    }
    
    fileprivate lazy var iconView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"))
    
    fileprivate lazy var maskIconView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    fileprivate lazy var houseIconView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_house"))
    
    fileprivate lazy var tipLabel: UILabel = UILabel.cz_label(withText: "关注一些人, 回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    
    override func updateConstraints() {
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.center.x)
            make.centerY.equalTo(self.center.y - 60)
        }
        
        houseIconView.snp.makeConstraints { (make) in
            make.center.equalTo(iconView)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(iconView.snp.bottom).offset(20)
            
            make.centerX.equalTo(self.center.x)
            
            make.width.equalTo(236)
        }
        
        registorButton.snp.makeConstraints { (make) in
            
            make.left.equalTo(tipLabel).offset(0)
            
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            
            make.width.equalTo(100)
        }
        
        loginButton.snp.makeConstraints { (make) in
            
            make.right.equalTo(tipLabel).offset(0)
            
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            
            make.width.equalTo(100)
        }
        
        maskIconView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(registorButton).offset(0)
            
            make.left.equalTo(registorButton).offset(0)
            
            make.width.equalTo(236)
            
            make.height.equalTo(300)
        }
        
        super.updateConstraints()
    }
}

extension XKVisitorView {
    
    func setupUI() {
        
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED)
        
        addSubview(iconView)
        
        addSubview(maskIconView)
        
        addSubview(houseIconView)
        
        addSubview(tipLabel)
        
        addSubview(registorButton)
        
        addSubview(loginButton)
        
        setNeedsUpdateConstraints()
    }
}

//
//  XKNewFeatureView.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/26.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKNewFeatureView: UIView {
    
    fileprivate lazy var scrollView = { ()->UIScrollView in
        
        let scrollView = UIScrollView()
        
        scrollView.backgroundColor = UIColor.clear
        
        scrollView.isPagingEnabled = true
        
        scrollView.bounces = false
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    fileprivate lazy var enterButton = { ()->UIButton in
        
        let enterButton = UIButton(type: .custom)
        
        enterButton.setTitle("进入微博", for: .normal)
        
        enterButton.setBackgroundImage(#imageLiteral(resourceName: "new_feature_finish_button"), for: .normal)
        
        enterButton.setBackgroundImage(#imageLiteral(resourceName: "new_feature_finish_button_highlighted"), for: .highlighted)
        
        enterButton.sizeToFit()
        
        enterButton.isHidden = true
        
        enterButton.addTarget(self, action: #selector(enterStatus), for: .touchUpInside)
        
        return enterButton
    }()
    
    fileprivate lazy var pageControl = { ()->UIPageControl in
        
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = 4
        
        pageControl.pageIndicatorTintColor = UIColor.black
        
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func enterStatus() {
        
        UIView.animate(withDuration: 1, animations: { 
            
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            self.alpha = 0
            
        }) { (_) in
            
            self.removeFromSuperview()
        }
    }
    
    override func updateConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
        }
        
        enterButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(center.x)
            make.bottom.equalTo(snp.bottom).offset(-120)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(center.x)
            make.top.equalTo(enterButton.snp.bottom).offset(16)
        }
        
        super.updateConstraints()
    }
    
    private func initUserInterface() {
        
        backgroundColor = UIColor.clear
        
        addSubview(scrollView)
        
        addSubview(enterButton)
        
        addSubview(pageControl)
        
        setNeedsUpdateConstraints()
        
        let count = 4
        
        let rect = UIScreen.main.bounds
        
        
        for i in 0..<count {
            
            let imageName = "new_feature_\(i + 1)"
            
            let imageView = UIImageView(image: UIImage(named: imageName))
            
            imageView.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        
        scrollView.delegate = self
    }
}

extension XKNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page == scrollView.subviews.count {
            
            removeFromSuperview()
        }
        
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        pageControl.currentPage = page
        
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}

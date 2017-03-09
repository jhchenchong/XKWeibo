//
//  XKStatusPicture.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKStatusPicture: UIView {
    
    var viewModel:XKStatusViewModel? {
        
        didSet {
            
            let imageView = subviews[0]
            
            if viewModel?.picURLs?.count == 1 {
                
                let viewSize = viewModel?.pictureSize ?? CGSize()
                
                let width = viewSize.width
                
                let height = viewSize.height - XKStatusPictureViewOutterMargin
                
                imageView.frame = CGRect(x: 0, y: XKStatusPictureViewOutterMargin, width: width, height: height)
                
            } else {
                
                imageView.frame = CGRect(x: 0, y: XKStatusPictureViewOutterMargin, width: XKStatusPictureItemWidth, height: XKStatusPictureItemWidth)
            }
            
            calcViewSize()
        }
    }
    
    private func calcViewSize() {
        
        heightCans.constant = viewModel?.pictureSize.height ?? 0
    }
    
    var urls:[XKPicturesModel]? {
        
        didSet {
            
            for view in subviews {
                
                view.isHidden = true
            }
            
            var index = 0
            
            for url in urls ?? []{
                
                let imageView = subviews[index] as! UIImageView
                
                if index == 1 && urls?.count == 4 {
                    
                    index += 1
                }
                
                imageView.cc_setImage(urlString: url.thumbnail_pic, placeholder: nil)
                
                imageView.isHidden = false
                
                index += 1
            }
        }
    }
    
    @IBOutlet weak var heightCans: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        setupUI()
    }
    
    @objc fileprivate func tapImageView(tap: UITapGestureRecognizer) {
        
        guard let imageView = tap.view,
            let picURLs = viewModel?.picURLs
            else {
                return
        }
        
        var selectedIndex = imageView.tag
        
        if picURLs.count == 4 && selectedIndex > 1 {
            
            selectedIndex -= 1
        }
        
        let urls = (picURLs as NSArray).value(forKey: "largePic") as! [String]
        
        var imageViewList = [UIImageView]()
        
        for imageView in subviews as! [UIImageView] {
            
            if !imageView.isHidden {
                imageViewList.append(imageView)
            }
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: XKStatusCellBrowserPhotoNotification),
            object: self,
            userInfo: [XKStatusCellBrowserPhotoURLsKey: urls,
                       XKStatusCellBrowserPhotoSelectedIndexKey: selectedIndex,
                       XKStatusCellBrowserPhotoImageViewsKey: imageViewList])
    }
}

extension XKStatusPicture {
    
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        
        clipsToBounds = true
        
        let rect = CGRect(x: 0, y: XKStatusPictureViewOutterMargin, width: XKStatusPictureItemWidth, height: XKStatusPictureItemWidth)
        
        
        for i in 0..<9 {
            
            let imageView = UIImageView()
            
            imageView.contentMode = .scaleAspectFill
            
            imageView.clipsToBounds = true
            
            let row = CGFloat(i / 3)
            
            let col = CGFloat(i % 3)
            
            let offsetX = col * (XKStatusPictureItemWidth + XKStatusPictureViewInnerMargin)
            
            let offsetY = row * (XKStatusPictureItemWidth + XKStatusPictureViewInnerMargin)
            
            imageView.frame = rect.offsetBy(dx: offsetX, dy: offsetY)
            
            addSubview(imageView)
            
            imageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImageView))
            
            imageView.addGestureRecognizer(tap)
            
            imageView.tag = i
            
        }
    }
}

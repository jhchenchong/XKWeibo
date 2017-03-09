//
//  XKStatusViewModel.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation

class XKStatusViewModel: CustomStringConvertible {
    
    var status: XKStatus
    
    var memberIcon: UIImage?
    
    var vipIcon: UIImage?
    
    var retweetedStr: String?
    
    var commetStr: String?
    
    var likeStr: String?
    
    var pictureSize = CGSize()
    
    var picURLs: [XKPicturesModel]? {
        
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    
    var statusText: NSAttributedString?
    
    var retweetedText: NSAttributedString?
    
    var rowheight: CGFloat = 0
    
    
    init(model: XKStatus) {
        
        self.status = model
        
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            
            memberIcon = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
            
        case 0:
            
            vipIcon = UIImage(named: "avatar_vip")
            
        case 2, 3, 5:

            vipIcon = UIImage(named: "avatar_enterprise_vip")
            
        case 220:
            
            vipIcon = UIImage(named: "avatar_grassroot")
            
        default:
            break
        }
        
        retweetedStr = countString(countInt: model.reposts_count, defaultStr: "转发")
        commetStr = countString(countInt: model.comments_count, defaultStr: "评论")
        likeStr = countString(countInt: model.attitudes_count, defaultStr: "赞")
        pictureSize = calcPictureViewSize(count: picURLs?.count)
        
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        // 微博正文的属性文本
        statusText = CZEmoticonManager.shared.emoticonString(string: model.text ?? "", font: originalFont)
        
        // 设置被转发微博的属性文本
        let rText = "@" + (status.retweeted_status?.user?.screen_name ?? "")
            + ":"
            + (status.retweeted_status?.text ?? "")
        retweetedText = CZEmoticonManager.shared.emoticonString(string: rText, font: retweetedFont)
        
        updateRowHeight()
    }
    
    private func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            
            return CGSize()
        }
        
        
        let row = (count! - 1) / 3 + 1
        
        let height = XKStatusPictureViewOutterMargin + CGFloat(row) * XKStatusPictureItemWidth + CGFloat((row - 1)) * XKStatusPictureViewInnerMargin
        
        return CGSize(width: XKStatusPictureItemWidth, height: height)
    }
    
    private func countString(countInt: Int, defaultStr: String) ->String {
        
        if countInt == 0 {
            
            return defaultStr
        }
        
        if countInt < 10000 {
            
            return countInt.description
        }
        
        return String(format: "%.2f万", Double(countInt) / 10000)
    }
    
    
    func updateRowHeight() {

        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        height = 2 * margin + iconHeight + margin
        
        if let text = statusText {
            
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        if status.retweeted_status != nil {
            
            height += 2 * margin
            
            if let text = retweetedText {
                
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        height += pictureSize.height
        
        height += margin
        
        height += toolbarHeight
        
        rowheight = height
    }
    
    func updateSingleImageSize(image: UIImage) {
        
        let imageWidth = image.size.width
        var imageHeight = image.size.height
        
        imageHeight += XKStatusPictureViewOutterMargin
        
        pictureSize = CGSize(width: imageWidth, height: imageHeight)
        
        updateRowHeight()
    }
    
    var description: String {
        
        return status.description
    }
}

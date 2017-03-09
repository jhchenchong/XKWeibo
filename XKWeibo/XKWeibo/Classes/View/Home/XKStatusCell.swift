//
//  XKStatusCell.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKStatusCell: UITableViewCell {

    var viewModel: XKStatusViewModel? {
        
        didSet {
            
            statusLabel.attributedText = viewModel?.statusText
            
            retweetedLabel?.attributedText = viewModel?.retweetedText
            
            nameLabel.text = viewModel?.status.user?.screen_name
            
            memeberIconView.image = viewModel?.memberIcon
            
            vipIconView.image = viewModel?.vipIcon
            
            sourceLabel.text = viewModel?.status.source
            
            timeLabel.text = viewModel?.status.createdDate?.cz_dateDescription
            
            iconView.cc_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholder: UIImage(named: "avatar_default_big"), isAvatar: true)
            
            toolBar.viewModel = viewModel
            
            pictureView.viewModel = viewModel
            
            pictureView.urls = viewModel?.picURLs
        }
    }
    
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员
    @IBOutlet weak var memeberIconView: UIImageView!

    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 认证
    @IBOutlet weak var vipIconView: UIImageView!
    
    /// 正文
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var toolBar: XKStatusToolBar!
    
    @IBOutlet weak var pictureView: XKStatusPicture!
    
    @IBOutlet weak var retweetedLabel: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        /// 表格性能优化 在有必要的时候添加离屏渲染和栅格化 注意在指定栅格化的同时 一定要指定当前屏幕的分辨率 不然cell会不清晰 (实质就是生成了将cell生成一张图片,在滚动的时候显示在屏幕上,停止滚动的时候允许交互)
//        
//        layer.drawsAsynchronously = true
//        
//        layer.shouldRasterize = true
//        
//        layer.rasterizationScale = UIScreen.cz_scale()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

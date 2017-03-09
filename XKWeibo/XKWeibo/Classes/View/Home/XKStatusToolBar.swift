//
//  XKStatusToolBar.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/27.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKStatusToolBar: UIView {

    var viewModel: XKStatusViewModel? {
        
        didSet {
            
            retweetedButton.setTitle(viewModel?.retweetedStr, for: .normal)
            
            commentButton.setTitle(viewModel?.commetStr, for: .normal)
            
            likeButton.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    
    @IBOutlet weak var retweetedButton:UIButton!
    
    @IBOutlet weak var commentButton:UIButton!
    
    @IBOutlet weak var likeButton:UIButton!

}

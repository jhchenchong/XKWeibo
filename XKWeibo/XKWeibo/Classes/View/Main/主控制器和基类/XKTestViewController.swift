//
//  XKTestViewController.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/22.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

class XKTestViewController: XKBasicViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    @objc fileprivate func showNext() {
        
        navigationController?.pushViewController(XKTestViewController(), animated: true)
    }

}

extension XKTestViewController {
    
    override func setupUI() {
        super.setupUI()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一页", target: self, action: #selector(showNext))
    }
}

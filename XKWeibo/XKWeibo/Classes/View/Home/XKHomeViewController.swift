//
//  XKHomeViewController.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/21.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage


private let orginalIdentifier = "orginalIdentifier"

private let retweetedIdentifier = "retweetedIdentifier"

class XKHomeViewController: XKBasicViewController {
    
    /// 列表视图模型
    fileprivate lazy var listViewModel = XKStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(browserPhoto), name: NSNotification.Name(rawValue: XKStatusCellBrowserPhotoNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadData() {
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            
            self.refreshControl?.endRefreshing()
            
            self.isPullup = false
            
            if shouldRefresh {
                
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc fileprivate func showFriends() {
        
        navigationController?.pushViewController(XKTestViewController(), animated: true)
    }
    
    @objc fileprivate func browserPhoto(notification: Notification) {
        
        guard let selectedIndex = notification.userInfo?[XKStatusCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = notification.userInfo?[XKStatusCellBrowserPhotoURLsKey] as? [String],
            let imageViewList = notification.userInfo?[XKStatusCellBrowserPhotoImageViewsKey] as? [UIImageView]
            else {
                return
        }
        
        // 2. 展现照片浏览控制器
        let vc = HMPhotoBrowserController.photoBrowser(
            withSelectedIndex: selectedIndex,
            urls: urls,
            parentImageViews: imageViewList)
        
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - 表格数据源方法
extension XKHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        
        let identifier = (viewModel.status.retweeted_status != nil) ? retweetedIdentifier : orginalIdentifier
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! XKStatusCell
        
        cell.viewModel = viewModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        
        return viewModel.rowheight
    }
}

// MARK: - 设置界面
extension XKHomeViewController {
    
    override func setupTableView() {
        
        super.setupTableView()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))

        tableView?.register(UINib(nibName: "XKStatusCell", bundle: nil), forCellReuseIdentifier: orginalIdentifier)
        
        tableView?.register(UINib(nibName: "XKRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedIdentifier)
        
        tableView?.separatorStyle = .none
        
        setupNavTitle()
    }
    
    /// 设置导航栏标题
    private func setupNavTitle() {
        
        let title: String = XKNetworkingManager.shared.userAccount.screen_name!
        
        let button = XKTitleButton(title: title)
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
    }
    
    @objc func clickTitleButton(btn: UIButton) {
        
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
}

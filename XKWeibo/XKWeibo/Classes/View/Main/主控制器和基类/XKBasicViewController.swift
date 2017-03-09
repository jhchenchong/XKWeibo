//
//  XKBasicViewController.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/21.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

/// 主控制器的基类
class XKBasicViewController: UIViewController {
    
    var visitorInfoDictionary: [String: String]?

    var tableView: UITableView?
    
    var refreshControl: CCRefreshContro?
    
    var isPullup = false
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        XKNetworkingManager.shared.userLogon ? loadData() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: XKUserLoginSuccessedNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    /// 加载数据 由子类负责
    func loadData() {
        self.refreshControl?.endRefreshing()
    }
    
    @objc fileprivate func loginSuccess(notification: NSNotification) {
        
        navItem.leftBarButtonItem = nil
        
        navItem.rightBarButtonItem = nil
        
        view = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func login() {
        
        print("点击登录")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: XKUserShouldLoginNotification), object: nil)
    }
    
    @objc fileprivate func register() {
        
        print("用户注册")
    }
}

// MARK: - 设置界面
extension XKBasicViewController {
    
    func setupUI()  {
        
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        XKNetworkingManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        
        view.addSubview(navigationBar)
        
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        navigationBar.items = [navItem]
        
        navigationBar.tintColor = UIColor.orange
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
    }
    
    /// 设置表格视图
    func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        tableView?.delegate = self
        
        tableView?.dataSource = self
        
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: (tabBarController?.tabBar.bounds.height)!, right: 0)
        
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        tableView?.tableFooterView = UIView()
        
        refreshControl = CCRefreshContro()
        
        tableView?.addSubview(refreshControl!)
        
        refreshControl?.beginRefreshing()
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
    }
    
    private func setupVisitorView() {
        
        let visitorView = XKVisitorView(frame: view.bounds)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        visitorView.visitorInfo = visitorInfoDictionary
        
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        visitorView.registorButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }
}

// MARK: -  UITableViewDataSource UITableViewDelegate
extension XKBasicViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        if row == (count - 1) && !isPullup {
            
            isPullup = true
            
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


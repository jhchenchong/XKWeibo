//
//  XKOAuthController.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/26.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit
import SVProgressHUD

class XKOAuthController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        
        webView.delegate = self
        
        webView.scrollView.isScrollEnabled = false
        
        view.backgroundColor = UIColor.white
        
        title = "登录新浪微博"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill), isBack: false)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(XKAppKey)&redirect_uri=\(XKRedirectURI)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }

    @objc fileprivate func close() {
        
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        
        let js = "document.getElementById('userId').value = '18780269064'; " +
        "document.getElementById('passwd').value = 'chenchong921209';"
        
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension XKOAuthController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(XKRedirectURI) == false {
            
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            
            close()
            
            return false
        }
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""

        XKNetworkingManager.shared.loadAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
                
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
                
            } else {
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: XKUserLoginSuccessedNotification),
                    object: nil)
                
                self.close()
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

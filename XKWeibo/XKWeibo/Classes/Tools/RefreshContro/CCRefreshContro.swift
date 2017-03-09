//
//  CCRefreshContro.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/29.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import UIKit

private let CCRefreshOffset: CGFloat = 126

enum CCRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

class CCRefreshContro: UIControl {
    
    private weak var scrollView: UIScrollView?
    
    fileprivate lazy var refreshView: CCRefreshView = CCRefreshView.refreshView()
    
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    override func removeFromSuperview() {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
        
        if sv.isDragging {
            
            if height > CCRefreshOffset && (refreshView.refreshState == .Normal) {
                
                refreshView.refreshState = .Pulling
                
            } else if height <= CCRefreshOffset && (refreshView.refreshState == .Pulling) {
                
                refreshView.refreshState = .Normal
            }
        } else {
            
            if refreshView.refreshState == .Pulling {
                
                beginRefreshing()
                
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func beginRefreshing() {
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        refreshView.refreshState = .WillRefresh
        
        var inset = sv.contentInset
        inset.top += CCRefreshOffset
        
        sv.contentInset = inset
        
        refreshView.parentViewHeight = CCRefreshOffset
    }

    
    func endRefreshing() {
        
        guard let sv = self.scrollView else {
            return
        }
        
        if self.refreshView.refreshState != .WillRefresh {
            return
        }
        
        self.refreshView.refreshState = .Normal
        
        var inset = sv.contentInset
        inset.top -= CCRefreshOffset
        
        UIView.animate(withDuration: 0.5, animations: {
            
            sv.contentInset = inset
            
        }, completion: nil)
    }
}

extension CCRefreshContro {
    
    fileprivate func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        addSubview(refreshView)
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}

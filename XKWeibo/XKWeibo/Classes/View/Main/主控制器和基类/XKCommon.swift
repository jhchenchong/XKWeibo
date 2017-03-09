//
//  XKCommon.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/26.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation

// MARK: - 应用程序信息
/// 应用程序 ID
let XKAppKey = "3203029149"
/// 应用程序加密信息(开发者可以申请修改)
let XKAppSecret = "9bd9e23dcff7182d03faf505f7344237"
/// 回调地址 - 登录完成调转的 URL，参数以 get 形式拼接
let XKRedirectURI = "http://baidu.com"

// MARK: - 全局通知定义
/// 用户需要登录通知
let XKUserShouldLoginNotification = "XKUserShouldLoginNotification"
/// 用户登录成功通知
let XKUserLoginSuccessedNotification = "XKUserLoginSuccessedNotification"

// MARK: - 照片浏览通知定义
/// @param selectedIndex    选中照片索引
/// @param urls             浏览照片 URL 字符串数组
/// @param parentImageViews 父视图的图像视图数组，用户展现和解除转场动画参照
/// 微博 Cell 浏览照片通知
let XKStatusCellBrowserPhotoNotification = "XKStatusCellBrowserPhotoNotification"
/// 选中索引 Key
let XKStatusCellBrowserPhotoSelectedIndexKey = "XKStatusCellBrowserPhotoSelectedIndexKey"
/// 浏览照片 URL 字符串 Key
let XKStatusCellBrowserPhotoURLsKey = "XKStatusCellBrowserPhotoURLsKey"
/// 父视图的图像视图数组 Key
let XKStatusCellBrowserPhotoImageViewsKey = "XKStatusCellBrowserPhotoImageViewsKey"

// MARK: - 微博配图视图常量
// 配图视图外侧的间距
let XKStatusPictureViewOutterMargin = CGFloat(12)
// 配图视图内部图像视图的间距
let XKStatusPictureViewInnerMargin = CGFloat(3)
// 视图的宽度的宽度
let XKStatusPictureViewWidth = UIScreen.cz_screenWidth() - 2 * XKStatusPictureViewOutterMargin
// 每个 Item 默认的宽度
let XKStatusPictureItemWidth = (XKStatusPictureViewWidth - 2 * XKStatusPictureViewInnerMargin) / 3

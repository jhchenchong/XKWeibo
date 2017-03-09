//
//  Date+Extension.swift
//  XKWeibo
//
//  Created by 浪漫恋星空 on 2016/12/25.
//  Copyright © 2016年 浪漫恋星空. All rights reserved.
//

import Foundation


private let dateFormatter = DateFormatter()

private let calendar = Calendar.current

extension Date {
    
    static func cz_dateString(delta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    static func cz_sinaDate(string: String) -> Date? {
        
        dateFormatter.dateFormat = "EEEE MMMM dd HH:mm:ss zzz yyyy"
        
        let locale = Locale.init(identifier: "en_US")
        
        dateFormatter.locale = locale
        
        return dateFormatter.date(from: string)
    }
    
    var cz_dateDescription: String {
        
        if calendar.isDateInToday(self) {
            
            let delta = -Int(self.timeIntervalSinceNow)
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
}

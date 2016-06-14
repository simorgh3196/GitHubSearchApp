//
//  DateFormatter.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/11.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation


final class DateFormatter: NSDateFormatter {
    
    static let instance = DateFormatter()
    
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stringToString(beforeFormat: String, _ afterFormat: String, string: String) -> String? {
        
        DateFormatter.instance.dateFormat = beforeFormat
        guard let date = DateFormatter.instance.dateFromString(string) else { return nil }
        DateFormatter.instance.dateFormat = afterFormat
        
        return DateFormatter.instance.stringFromDate(date)
    }
}
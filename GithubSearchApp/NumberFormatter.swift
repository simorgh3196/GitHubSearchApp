//
//  NumberFormatter.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/11.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation


final class NumberFormatter: NSNumberFormatter {
    
    static let instance = NumberFormatter()
    
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

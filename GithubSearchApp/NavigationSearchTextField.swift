//
//  NavigationSearchTextField.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/15.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import UIKit


// MARK: - NavigationSearchTextField -

final class NavigationSearchTextField: UITextField {
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        placeholder = "Search Repositories"
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 3
        prepareLeftView()
    }
    
    private func prepareLeftView() {
        
        let searchImageView = UIImageView(image: UIImage(named: "search"))
        searchImageView.frame = CGRect(x: 10, y: 0, width: 36, height: 20)
        searchImageView.contentMode = .ScaleAspectFit
        leftView = searchImageView
        leftViewMode = .Always
    }
    
}

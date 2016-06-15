//
//  SearchRepositoryFooterView.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/15.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import UIKit


// MARK: - SearchRepositoryFooterView -

final class SearchRepositoryFooterView: UIView {
    
    var label: UILabel!
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        prepareLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareLabel()
    }
    
    private func prepareLabel() {
        
        label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            Constraint.new(label, .CenterX, to: self, .CenterX),
            Constraint.new(label, .CenterY, to: self, .CenterY),
            ])
    }
    
}

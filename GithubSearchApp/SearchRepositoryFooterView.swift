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
    
    private var labelView: UIView!
    var label: UILabel!
    
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        prepareLabelView()
        prepareLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareLabelView()
        prepareLabel()
    }
    
    private func prepareLabelView() {
        
        labelView = UIView()
        labelView.backgroundColor = UIColor(white: 0.8, alpha: 0.7)
        labelView.layer.cornerRadius = 10
        addSubview(labelView)
        
        labelView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([
            Constraint.new(labelView, .CenterX, to: self, .CenterX),
            Constraint.new(labelView, .CenterY, to: self, .CenterY),
            Constraint.new(labelView, .Width, to: nil, .Width, constant: 200),
            Constraint.new(labelView, .Height, to: nil, .Height, constant: 44),
            ])
    }
    
    private func prepareLabel() {
        
        label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        labelView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        labelView.addConstraints([
            Constraint.new(label, .CenterX, to: labelView, .CenterX),
            Constraint.new(label, .CenterY, to: labelView, .CenterY),
            ])
    }
    
}

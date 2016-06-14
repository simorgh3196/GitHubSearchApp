//
//  Constraint.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/14.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import UIKit

final class Constraint: NSLayoutConstraint {
    
    static func new(item: AnyObject, _ attr: NSLayoutAttribute, to: AnyObject?, _ attrTo: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relate: NSLayoutRelation = .Equal, priority: UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
        let ret = NSLayoutConstraint(
            item:       item,
            attribute:  attr,
            relatedBy:  relate,
            toItem:     to,
            attribute:  attrTo,
            multiplier: multiplier,
            constant:   constant
        )
        ret.priority = priority
        return ret
    }
    
    static func new(visualFormats formats: [String], options opts: NSLayoutFormatOptions = NSLayoutFormatOptions(rawValue: 0), metrics: [String : AnyObject]? = nil, views: [String : AnyObject]) -> [NSLayoutConstraint] {
        
        var constraints: [NSLayoutConstraint] = []
        formats.forEach({
            NSLayoutConstraint.constraintsWithVisualFormat($0, options: opts, metrics: metrics, views: views).forEach({
                constraints.append($0)
            })
        })
        
        return constraints
    }
    
}

//
//  UINavigationBar+StatusBarColor.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/15.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import UIKit


extension UINavigationController {
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.visibleViewController
    }
}

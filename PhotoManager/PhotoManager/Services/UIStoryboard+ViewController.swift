//
//  UIStoryboard+ViewController.swift
//  PageViewControllerDemo
//
//  Created by Kushida　Eiji on 2016/12/04.
//  Copyright © 2016年 Kushida　Eiji. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func getViewController<T: UIViewController>(_ storyboardName: String, identifier: String) -> T? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as? T
    }
}

//
//  NavigationService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-01.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
class NavigationService{
    public static func initNavigationItem(title: String, navigationItem: UINavigationItem, editButtonItem: UIBarButtonItem){
    navigationItem.title = title
    navigationItem.rightBarButtonItem = editButtonItem
    
    }
}

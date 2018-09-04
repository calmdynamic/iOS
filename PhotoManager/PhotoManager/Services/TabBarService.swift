//
//  TabBarService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-01.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
class TabBarService{
    public static func tabBarChangeWhenSetEditing(tabBarController: UITabBarController,editing: Bool){
        tabBarController.tabBar.isHidden = editing
    }
    
    public static func initBarbarWhenWillAppear(tabBar: UITabBar){
         tabBar.isHidden = false
    }
}

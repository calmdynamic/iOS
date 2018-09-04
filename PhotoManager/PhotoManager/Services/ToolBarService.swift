//
//  ToolBarService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-31.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
class ToolBarService{
    
    public static func toolbarItemWhenCellIsClickedAndDeclicked(collectionView: UICollectionView, addButton: UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem){
        let numOfSelection = collectionView.indexPathsForSelectedItems?.count
        if numOfSelection == 0{
            updateButton.isEnabled = false
            deleteButton.isEnabled = false
            addButton.isEnabled = true
        }else if numOfSelection == 1{
            updateButton.isEnabled = true
            deleteButton.isEnabled = true
            addButton.isEnabled = false
        }else if numOfSelection! > 1{
            updateButton.isEnabled = false
        }
    }
    
    public static func initButtons(addButton: UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem){
        addButton.isEnabled = true
        updateButton.isEnabled = false
        deleteButton.isEnabled = false
    }
    
    public static func toolbarItemChangeWhenSetEditing(toolbar: UIToolbar, addButton: UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, editing: Bool){
        toolbar.isHidden = !editing
        addButton.isEnabled = true
        deleteButton.isEnabled = false
        updateButton.isEnabled = false
    }
    
    public static func initToolBarWhenWillAppear(toolbar: UIToolbar){
        toolbar.isHidden = true
    }
    
}

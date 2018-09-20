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
    
    public static func toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder: Folder, collectionView:UICollectionView ,hashTagBtn: UIBarButtonItem, deleteButton: UIBarButtonItem, cameraBtn: UIButton, downloadBtn: UIButton){
        //let numOfSelection = collectionView.indexPathsForSelectedItems?.count
        selectedFolder.setNumOfImageSelection(number: (collectionView.indexPathsForSelectedItems?.count)!)
        if selectedFolder.getNumOfImageSelection() == 0{
            deleteButton.isEnabled = false
            hashTagBtn.isEnabled = false
            //uploadBtn.isEnabled = false
            cameraBtn.isEnabled = true
            downloadBtn.isEnabled = true
        }else if selectedFolder.getNumOfImageSelection() == 1{
            deleteButton.isEnabled = true
            hashTagBtn.isEnabled = true
            //uploadBtn.isEnabled = true
            cameraBtn.isEnabled = false
            downloadBtn.isEnabled = false
        }
    }
    
    
   
    
    public static func initButtons(addButton: UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem){
        addButton.isEnabled = true
        updateButton.isEnabled = false
        deleteButton.isEnabled = false
    }
    
    public static func initButtons(deleteButton: UIBarButtonItem, hashTagBtn: UIBarButtonItem){
        deleteButton.isEnabled = false
        hashTagBtn.isEnabled = false
        //uploadBtn.isEnabled = false
    }
    
    public static func toolbarItemChangeWhenSetEditing(toolbar: UIToolbar, addButton: UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem,navigationItem:UINavigationItem, editing: Bool){
        navigationItem.hidesBackButton = editing
        toolbar.isHidden = !editing
        addButton.isEnabled = true
        deleteButton.isEnabled = false
        updateButton.isEnabled = false
    }
    
    public static func toolbarItemChangeWhenSetEditing(toolbar: UIToolbar, hashTagBtn: UIBarButtonItem, deleteButton: UIBarButtonItem,downloadBtn: UIButton, cameraBtn:UIButton, navigationItem:UINavigationItem, editing: Bool){
        navigationItem.hidesBackButton = editing
        cameraBtn.isEnabled = !editing
        downloadBtn.isEnabled = !editing
        toolbar.isHidden = !editing
        deleteButton.isEnabled = false
        hashTagBtn.isEnabled = false
        //uploadBtn.isEnabled = false
    }
    
    public static func initToolBarWhenWillAppear(toolbar: UIToolbar){
        toolbar.isHidden = true
    }
    
}

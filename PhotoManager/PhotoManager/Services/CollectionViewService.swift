//
//  CollectionViewService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-01.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewService{
    public static func collectionViewChnageWhenSetEditing(collectionView:UICollectionView,editing: Bool){
        collectionView.allowsMultipleSelection = editing
        collectionView.reloadData()
    }
    
    public static func deselectAll(collectionView: UICollectionView){
        if let indexpaths = collectionView.indexPathsForSelectedItems{
            for i in indexpaths{
                let cell = collectionView.cellForItem(at: i as IndexPath)
                if (cell?.isSelected)!{
                    collectionView.deselectItem(at: i, animated: false)
                }
            }
        }
    }
    
    public static func pinHeaderToTopWhenScrolling(collectionView: UICollectionView){
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }
    
    public static func initCollectionView(collectionView: UICollectionView, collectionDataSource: UICollectionViewDataSource, collectionDelegate: UICollectionViewDelegate){
        collectionView.dataSource = collectionDataSource
        collectionView.delegate = collectionDelegate
    }
    
    public static func initCollectionViewWhenWillAppear(tabBar: UITabBar, toolbar: UIToolbar, searchBar: UISearchBar, collectionView: UICollectionView){
        TabBarService.initBarbarWhenWillAppear(tabBar: tabBar)
        
        ToolBarService.initToolBarWhenWillAppear(toolbar: toolbar)

        CollectionViewService.deselectAll(collectionView: collectionView)

        SearchBarService.setDefaultSortImage(searchBar: searchBar)
        collectionView.reloadData()
        
    }
    
    public static func addTypesToRealm(folderTypes: TypeList, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        AlertDialog.showAlertMessage(controller: controller, title: "Add a new type", message: "Enter a new folder type name", leftBtnTitle: "Cancel", rightBtnTitle: "Confirm", textFieldDelegate: textFieldDelegate, completion: { folderType in
            
            let tempTypeName = folderType.trimmingCharacters(in: .whitespaces)
            if !StringService.isTextEmpty(tempTypeName){
                
                if folderTypes.foundRepeatedType(folderType){
                    AlertDialog.showAlertMessage(controller: controller, title: "Existed Folder Error", message: "The folder type is already existed, please create another unique name for this folder type", btnTitle: "Confirm")
                }else{
                    //add a new folder type to the collection view
                    folderTypes.addFolderTypeToRealm(typename: tempTypeName)
                    collectionView.reloadData()
                    
                }
            }else{
                AlertDialog.showAlertMessage(controller: controller, title: "Null String Error", message: "We don't accept the empty string; please give your folder a descriptive name", btnTitle: "Confirm")
            }
            
            ToolBarService.initButtons(addButton: addButton, updateButton: updateButton, deleteButton: deleteButton)
            
        }, textFieldPlaceHolderTitle: "Enter Folder Type Name")
    }
    
    public static func addFoldersToRealm(folderType: Type, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        
        AlertDialog.showAlertMessage(controller: controller, title: "Add a new folder", message: "Enter a new folder name", leftBtnTitle: "Cancel", rightBtnTitle: "Confirm", textFieldDelegate: textFieldDelegate, completion: { folderName in
            
            let tempFolderName = folderName.trimmingCharacters(in: .whitespaces)
            
            if !StringService.isTextEmpty(tempFolderName) {
                
                if folderType.repeatedFolderFound(folderName){
                    AlertDialog.showAlertMessage(controller: controller, title: "Existed Folder Error", message: "The folder type is already existed, please create another unique name for this folder type", btnTitle: "Confirm")
                }else{
                    folderType.addFoldersToRealm(folderName: tempFolderName)
                    
                    collectionView.reloadData()
                    
                }
            }else{
                AlertDialog.showAlertMessage(controller: controller, title: "Null String Error", message: "We don't accept the empty string; please give your folder a descriptive name", btnTitle: "Confrim")
            }
            
            ToolBarService.initButtons(addButton: addButton, updateButton: updateButton, deleteButton: deleteButton)
            
        }, textFieldPlaceHolderTitle: "Enter Folder Name")
    
    }
    
    public static func deleteTypesToRealm(folderTypes: TypeList, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        
        AlertDialog.showAlertMessage(controller: controller, title: "Delete this folder type", message: "Ensure to delete this folder type?", leftBtnTitle: "Cancel",rightBtnTitle: "Delete", textFieldDelegate: textFieldDelegate, completion: { (_) in
            
            let indexpaths = collectionView.indexPathsForSelectedItems
            if let indexpaths = indexpaths {
                
                for item  in indexpaths {
                    collectionView.deselectItem(at: (item), animated: true)
                }
                folderTypes.deleteFolderTypeFromRealm(indexpaths: indexpaths)
                
                collectionView.deleteItems(at: indexpaths)
                ToolBarService.initButtons(addButton: addButton, updateButton: updateButton, deleteButton: deleteButton)
            }
            
        }, textFieldPlaceHolderTitle: "")
        
        
        
    }
    
    public static func deleteTypesToRealm(folders: Type, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        
        AlertDialog.showAlertMessage(controller: controller, title: "Delete the folder(s)", message: "Ensure to delete the folder(s)?", leftBtnTitle: "Cancel",rightBtnTitle: "Delete", textFieldDelegate: textFieldDelegate, completion: { (_) in
            
            let indexpaths = collectionView.indexPathsForSelectedItems
            
            if let indexpaths = indexpaths {
                for item  in indexpaths {
                    collectionView.deselectItem(at: (item), animated: true)
                    
                }
                
                folders.deleteFolderFromRealm(indexpaths: indexpaths)
                
                
                collectionView.deleteItems(at: indexpaths)
                ToolBarService.initButtons(addButton: addButton, updateButton: updateButton, deleteButton: deleteButton)
                
            }
            
        }, textFieldPlaceHolderTitle: "")
        
        
        
    }
    
    public static func updateTypesToRealm(folderTypes: TypeList, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        AlertDialog.showAlertMessage(controller: controller, title: "Modify name?", message: "Enter a new folder type name", leftBtnTitle: "Cancel", rightBtnTitle: "Update", completion: {(modifiedName) in

       
            let indexpaths = collectionView.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                folderTypes.updateFolderTypeFromRealm(indexpaths: indexpaths!, modifiedName: modifiedName)
                ToolBarService.initButtons(addButton: addButton, updateButton: updateButton, deleteButton: deleteButton)
                collectionView.reloadData()
            }
            
        }, completion2: {(textField, confirmAction, alertController) in
            
            let indexpaths = collectionView.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                    
                    let folderTypeName = folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getName()
                    textField.text = folderTypeName
                    confirmAction.isEnabled = false
                    
                    textField.delegate = textFieldDelegate
                    textField.placeholder = "Enter Folder Type Name"
                    
                    AlertDialog.textFieldObserver(textField: textField, alertController: alertController, folderTypes: folderTypes, confirmAction: confirmAction)
                    
                }
            }
            
        })
        
    }
    
    public static func updateFolderToRealm(folderType: Type, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        
        
        AlertDialog.showAlertMessage(controller: controller, title: "Modify name?", message: "Enter a new folder name", leftBtnTitle: "Cancel", rightBtnTitle: "Update", completion: {(modifiedName) in
            
            let indexpaths = collectionView.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                //let modifiedName = alertController.textFields?[0].text
                
                folderType.updateFolderFromRealm(indexpaths: indexpaths!, modifiedName: modifiedName)
                
                ToolBarService.initButtons(addButton: addButton, updateButton: updateButton, deleteButton: deleteButton)
                collectionView.reloadData()
                
            }
            
        }, completion2: {(textField, confirmAction, alertController) in
            
            let indexpaths = collectionView.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                    let folderTypeName = folderType.getFolderArray()[indexPath.item].getName()
                    textField.text = folderTypeName
                    confirmAction.isEnabled = false
                    
                    textField.delegate = textFieldDelegate
                    textField.placeholder = "Enter Folder Name"
                    
                    
                    AlertDialog.textFieldObserver(textField: textField, alertController: alertController, folders: folderType, confirmAction: confirmAction)
                    
                }}
            
        })
        
        
        
    }
    
    

}

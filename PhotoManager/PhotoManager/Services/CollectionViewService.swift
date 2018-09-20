//
//  CollectionViewService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-01.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import FirebaseAuth

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
    
    public static func initCollectionViewWhenWillAppear(tabBar: UITabBar, toolbar: UIToolbar, searchBar: UISearchBar, collectionView: UICollectionView, tapGesture: UITapGestureRecognizer){
        tapGesture.isEnabled = false
        TabBarService.initBarbarWhenWillAppear(tabBar: tabBar)
        
        ToolBarService.initToolBarWhenWillAppear(toolbar: toolbar)

        CollectionViewService.deselectAll(collectionView: collectionView)

        SearchBarService.setDefaultSortImage(searchBar: searchBar)
        collectionView.reloadData()
        
    }
    
    public static func initCollectionViewWhenWillAppear(tabBar: UITabBar, toolbar: UIToolbar, collectionView: UICollectionView){
        
        TabBarService.initBarbarWhenWillAppear(tabBar: tabBar)
        
        ToolBarService.initToolBarWhenWillAppear(toolbar: toolbar)
        
        CollectionViewService.deselectAll(collectionView: collectionView)
        
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
    
    public static func deleteFoldersFromRealm(folders: Type, controller: UIViewController, collectionView: UICollectionView, addButton:UIBarButtonItem, updateButton: UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        
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
    
    public static func deleteImageFromRealm(selectedFolder: Folder, controller: UIViewController, collectionView: UICollectionView, hashTagBtn:UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
    
        AlertDialog.showAlertMessage(controller: controller, title: "Delete the image(s)", message: "Ensure to delete the image(s)?", leftBtnTitle: "Cancel",rightBtnTitle: "Delete", textFieldDelegate: textFieldDelegate, completion: { (_) in
            
            let indexpaths = collectionView.indexPathsForSelectedItems
            if let indexpaths = indexpaths {
                for item  in indexpaths {
                    collectionView.deselectItem(at: (item), animated: true)
                    
                }
                
                selectedFolder.deletImages(indexpaths: indexpaths)
                
                collectionView.deleteItems(at: indexpaths)
                
                
                ToolBarService.initButtons(deleteButton: deleteButton, hashTagBtn: hashTagBtn)
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
    
    public static func addHashtagOperation(controller: UIViewController,collectionView: UICollectionView, selectedFolder: Folder, hashTagBtn:UIBarButtonItem, deleteButton: UIBarButtonItem, textFieldDelegate: UITextFieldDelegate){
        let indexpaths = collectionView.indexPathsForSelectedItems
        let selectedImage = selectedFolder.getImageArray()[indexpaths![0].item]
        
        let currentHashTags = selectedImage.getHashTags()
        
        var hashtagsString = ""
        for i in currentHashTags{
            hashtagsString += "\(i.getHashTag()) "
            
        }
        
        let actionSheet = UIAlertController(title: "This image includes the following hashtags:\n \(hashtagsString)", message: nil, preferredStyle: .actionSheet)
        
        let updateHashtags = CollectionViewService.updateOneOrMoreHashtagToImage(hashtagsString: hashtagsString, selectedImage: selectedImage, controller: controller, collectionView: collectionView, hashTagBtn: hashTagBtn, deleteButton: deleteButton)
        
        actionSheet.addAction(updateHashtags)
        if selectedFolder.getNumOfImageSelection() != 1{
            updateHashtags.isEnabled = false
        }else{
            updateHashtags.isEnabled = true
        }
        
        let addHashtagToMultipleImage  = CollectionViewService.addOneOrMoreHashtagToImages(selectedFolder: selectedFolder, selectedImage: selectedImage, controller: controller, collectionView: collectionView, textFieldDelegate: textFieldDelegate, hashTagBtn: hashTagBtn, deleteButton: deleteButton)
        
        actionSheet.addAction(addHashtagToMultipleImage)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        controller.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    private static func updateOneOrMoreHashtagToImage(hashtagsString: String, selectedImage: Image, controller: UIViewController, collectionView: UICollectionView,  hashTagBtn:UIBarButtonItem, deleteButton: UIBarButtonItem) -> UIAlertAction{
        
        
        return UIAlertAction(title: "Update hashtags", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            
            AlertDialog.showTextViewDialog(origianlController: controller, title: "Update Hashtags?", message: "Ensure to update this image's hashtag(s)?", leftBtnTitle: "Cancel", rightBtnTitle: "Update", textViewText: hashtagsString , completion: { (textViewText) in
                
                let indexpaths = collectionView.indexPathsForSelectedItems
                if indexpaths!.count == 1 {
                    
                    var tempHashTags = textViewText.components(separatedBy: " ")
                    if(tempHashTags[tempHashTags.count-1]==""){
                        tempHashTags.remove(at: tempHashTags.count-1)
                    }
                    
                    let title = selectedImage.anyProblemForHashtag(tempHashTags: tempHashTags)
                    
                    if(title != ""){
                        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
                        alert.addAction(cancelAction)
                        controller.present(alert, animated: true)
                    }else{
                        selectedImage.addOneOrMultipleHashtagToRealm(tempHashTags: tempHashTags)
                        for item  in indexpaths! {
                            collectionView.deselectItem(at: (item), animated: true)
                            
                        }
                        ToolBarService.initButtons(deleteButton: deleteButton, hashTagBtn: hashTagBtn)
                    }
                }
                
            })
            
            
            
            
            
        })
        
        
    }
    
    
    
    
    
    private static func addOneOrMoreHashtagToImages(selectedFolder: Folder, selectedImage: Image, controller: UIViewController, collectionView: UICollectionView, textFieldDelegate: UITextFieldDelegate, hashTagBtn:UIBarButtonItem, deleteButton: UIBarButtonItem) -> UIAlertAction{
        return UIAlertAction(title: "Add a HashTag to one or multiple Image(s)", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            AlertDialog.showAlertMessage(controller: controller, title: "Add name?", message: "Enter the hashtag name", leftBtnTitle: "Cancel", rightBtnTitle: "Add", completion: { (newHashtagName) in
                let indexpaths = collectionView.indexPathsForSelectedItems
                if let indexpaths = indexpaths {
                    for item  in indexpaths {
                        collectionView.deselectItem(at: (item), animated: true)
                        
                    }
                    selectedFolder.addOneOrMultipleHashtagToImages(indexpaths: indexpaths, newHashtagName: newHashtagName)
                    ToolBarService.initButtons(deleteButton: deleteButton, hashTagBtn: hashTagBtn)
                }
                
            }, completion2: { (textField, confirmAction, alertController) in
                let indexpaths = collectionView.indexPathsForSelectedItems
                for _ in indexpaths!{
                    
                    confirmAction.isEnabled = false
                    
                    textField.placeholder = "Enter a New Hashtag name"
                    textField.delegate = textFieldDelegate
                    AlertDialog.textFieldObserver(indexpaths: indexpaths!,textField: textField, alertController: alertController, selectedFolder: selectedFolder, image: selectedImage, confirmAction: confirmAction)
                    
                }
                
            })
            
            
        })
    }
    
    
 
    
    
    
    

}

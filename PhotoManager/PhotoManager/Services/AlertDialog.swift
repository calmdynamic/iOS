//
//  AlertDialog.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-21.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit

class AlertDialog{
    public static func showAlertMessage(controller: UIViewController,title: String, message: String, btnTitle: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the cancel action doing nothing
        let okAction = UIAlertAction(title: btnTitle, style: .default) { (_) in }
        
        alertController.addAction(okAction)
        
        //finally presenting the dialog box
        controller.present(alertController, animated: true, completion: nil)
    }
    
    public static func showAlertMessage(controller: UIViewController,title: String, message: String, leftBtnTitle: String, rightBtnTitle: String, handler: ((UIAlertAction)->Void)?){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: rightBtnTitle, style: .default, handler: handler)
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: leftBtnTitle, style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        controller.present(alertController, animated: true, completion: nil)
    }
    
    public static func showAlertMessage(controller: UIViewController,title: String, message: String, leftBtnTitle: String, rightBtnTitle: String, completion: @escaping (String) -> Void, textFieldPlaceHolderTitle: String){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: rightBtnTitle, style: .default) { (_) in
            if textFieldPlaceHolderTitle != ""{
                
                let textField = alertController.textFields![0] as UITextField
            
                let text = textField.text
            
                completion(text ?? "")
                
            }else{
                completion("")
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: leftBtnTitle, style: .cancel) { (_) in }
        if textFieldPlaceHolderTitle != "" {
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = textFieldPlaceHolderTitle
            })

        
        
        }
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //update
    public static func showAlertMessage(controller: UIViewController,title: String, message: String, leftBtnTitle: String, rightBtnTitle: String, completion: @escaping (String) -> Void, completion2: @escaping (UITextField, UIAlertAction, UIAlertController) -> Void){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: rightBtnTitle, style: .default) { (_) in
            //if textFieldPlaceHolderTitle != ""{
            
            let textField = alertController.textFields![0] as UITextField
            
            let text = textField.text
            
            completion(text ?? "")
            
            //}else{
            //completion("")
            //}
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: leftBtnTitle, style: .cancel) { (_) in }
        //if textFieldPlaceHolderTitle != "" {
//        alertController.addTextField{ (textField) in
//
//            //
//
//        }
        alertController.addTextField { (textField) in
            completion2(textField, confirmAction, alertController)
        }
        
        
        //alertController.addTextField(configurationHandler: configurationHandler)
        // }
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        controller.present(alertController, animated: true, completion: nil)
    }
    
//    public static func showSortAlertMessage(title: String, btnTitle1: String, handler1: ((UIAlertAction) -> Void)?, btnTitle2: String, handler2: ((UIAlertAction)-> Void)?, btnTitle3: String, handler3: ((UIAlertAction)->Void)?, btnTitle4:((UIAlertAction)_>Void)?){
//        let actionSheet = UIAlertController(title: title, message: nil , preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: { (_) in
//            
//            self.folderTypes.sortByName()
//            self.collectionView.reloadData()
//        }))
//        
//        actionSheet.addAction(UIAlertAction(title: "Sort by created date", style: .default, handler: { (_) in
//            self.folderTypes.sortByDateCreated()
//            self.collectionView.reloadData()
//        } ))
//        actionSheet.addAction(UIAlertAction(title: "Sort by number of folders", style: .default, handler: {(_) in
//            self.folderTypes.sortByNumOfFolder()
//            self.collectionView.reloadData()
//        } ))
//        
//        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: {
//            (action: UIAlertAction) -> Void in
//            actionSheet.dismiss(animated: true, completion: nil)
//        }))
//        present( actionSheet , animated:  true , completion:  nil)
//
//    }
    
    
}

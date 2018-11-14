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
    
    /**
     a basic Alert Dialog function with handler
     */
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
    
    /**
     a basic Alert Dialog function with handler
     */
    public static func showAlertMessage(controller: UIViewController,title: String, message: String, btnTitle: String, handler: ((UIAlertAction)->Void)?){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: btnTitle, style: .default, handler: handler)

        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        
        //finally presenting the dialog box
        controller.present(alertController, animated: true, completion: nil)
    }
    
    public static func showAlertMessage(controller: UIViewController,title: String, message: String, leftBtnTitle: String, rightBtnTitle: String, textFieldDelegate: UITextFieldDelegate, completion: @escaping (String) -> Void, textFieldPlaceHolderTitle: String){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: rightBtnTitle, style: .default) { (_) in
            if textFieldPlaceHolderTitle != ""{
                
                let textField = alertController.textFields![0] as UITextField
            
//                var text = textField.text
//                let first = String((text?.prefix(1))!).capitalized
//                let other = String((text?.dropFirst())!)
                let text = StringService.formattedTextField(textField: textField.text!)
            
                completion(text)
                
            }else{
                completion("")
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: leftBtnTitle, style: .cancel) { (_) in }
        if textFieldPlaceHolderTitle != "" {
            alertController.addTextField(configurationHandler: { (textField) in
                textField.delegate = textFieldDelegate
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
            
            let text = StringService.formattedTextField(textField: textField.text!)
            
            
            completion(text)
            
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
    
    public static func showSortAlertMessage(title: String, btnTitle1: String, handler1: ((UIAlertAction) -> Void)?, btnTitle2: String, handler2: ((UIAlertAction)-> Void)?, btnTitle3: String, handler3: ((UIAlertAction)->Void)?, cancelBtnTitle:String, controller: UIViewController){
        let actionSheet = UIAlertController(title: title, message: nil , preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: btnTitle1, style: .default, handler: handler1))
        
        actionSheet.addAction(UIAlertAction(title: btnTitle2, style: .default, handler: handler2 ))
        actionSheet.addAction(UIAlertAction(title: btnTitle3, style: .default, handler: handler3 ))
        
        
        actionSheet.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel , handler: {
            (action: UIAlertAction) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        controller.present( actionSheet , animated:  true , completion:  nil)

    }
    
    public static func showSortAlertMessage(title: String, btnTitle1: String, handler1: ((UIAlertAction) -> Void)?, cancelBtnTitle:String, controller: UIViewController){
        let actionSheet = UIAlertController(title: title, message: nil , preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: btnTitle1, style: .default, handler: handler1))
        
        
        actionSheet.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel , handler: {
            (action: UIAlertAction) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        controller.present( actionSheet , animated:  true , completion:  nil)
        
    }
    
    public static func showSharingAlertMessage(title: String, btnTitle1: String, handler1: ((UIAlertAction) -> Void)?, btnTitle2: String, handler2: ((UIAlertAction)-> Void)?, cancelBtnTitle:String, controller: UIViewController){
        let actionSheet = UIAlertController(title: title, message: nil , preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: btnTitle1, style: .default, handler: handler1))
        
        actionSheet.addAction(UIAlertAction(title: btnTitle2, style: .default, handler: handler2 ))

        actionSheet.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel , handler: {
            (action: UIAlertAction) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        controller.present( actionSheet , animated:  true , completion:  nil)
        
    }
    

    public static func showTextViewDialog(origianlController: UIViewController,title: String, message: String, leftBtnTitle: String, rightBtnTitle: String, textViewText: String, completion: @escaping (String) -> Void){
        let textView = UITextView()
        textView.keyboardType = UIKeyboardType.twitter
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: rightBtnTitle, style: .destructive) { (_) in
            completion(textView.text)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: leftBtnTitle, style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        
//        textView.frame =  CGRect(x: 30, y: 0, width: 335, height: 667)
        
        textView.frame = controller.view.frame
        controller.view.addSubview(textView)
        textView.text = textViewText
        alertController.setValue(controller, forKey: "contentViewController")
        
        //finally presenting the dialog box
        origianlController.present(alertController, animated: true, completion: nil)
        
        
    }
    
    public static func textFieldObserver(textField: UITextField, alertController: UIAlertController, folderTypes: TypeList, confirmAction: UIAlertAction){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
            
            let modifiedName = alertController.textFields?[0].text
            
            if !folderTypes.foundRepeatedType(modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)!{
                confirmAction.isEnabled = true
            }else{
                confirmAction.isEnabled = false
            }
            
            
        }
    }
    
    
    public static func textFieldObserver(textField: UITextField, alertController: UIAlertController, folders: Type, confirmAction: UIAlertAction){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
            
            let modifiedName = alertController.textFields?[0].text
            
            if !folders.repeatedFolderFound(modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)!{
                confirmAction.isEnabled = true
            }else{
                confirmAction.isEnabled = false
            }
            
            
        }
    }
    
    
    
    public static func textFieldObserver(indexpaths: [IndexPath],textField: UITextField, alertController: UIAlertController, selectedFolder: Folder, image: Image, confirmAction: UIAlertAction){
       
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
            
            let modifiedName = alertController.textFields?[0].text
            //if let indexpaths = indexpaths {
                for item  in indexpaths {
                    
                    let image = selectedFolder.getImageArray()[item.row]
                    if !image.repeatedHashTagFound(modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)! && modifiedName?.prefix(1) == "#"{
                        confirmAction.isEnabled = true
                    }else{
                        confirmAction.isEnabled = false
                    }
                }
            //}
        
    }
    
  
}
    
}

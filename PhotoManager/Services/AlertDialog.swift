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
}

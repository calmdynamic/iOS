//
//  CameraService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-04.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CameraService{
    
//    public static func cameraChecker(pickerController: UIImagePickerController, viewController: UIViewController) -> Bool{
//        if !UIImagePickerController.isSourceTypeAvailable(.camera){
//
//            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
//
//            let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
//            })
//
//            alertController.addAction(okAction)
//            viewController.present(alertController, animated: true, completion: nil)
//        }
//        else{
//            pickerController.sourceType = UIImagePickerControllerSourceType.camera
//            viewController.present(pickerController, animated: true, completion: nil)
//            return true
//        }
//        return false
//    }
//
//
    
    public static func takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: Folder, locationMgr: CLLocationManager, picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], collectionView: UICollectionView){
        if Reachability.isConnectedToNetwork() && CLLocationManager.locationServicesEnabled() {
            locationMgr.startUpdatingLocation()
            picker.dismiss(animated: true, completion: nil)
            selectedFolder.setNewImage(newImage:  (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        }else{
            picker.dismiss(animated: true, completion: nil)
            selectedFolder.setNewImage(newImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            print("no networking")
            //self.location = Location()
            selectedFolder.addImageToRealm(newImage: selectedFolder.getNewImage(), location: Location())
            collectionView.reloadData()
            
        }
    }
    
    public static func initCameraPicker(controller:UIViewController ,pickerController: UIImagePickerController){
        pickerController.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
}

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
    
    static var newImage = UIImage()
    
    public static func takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: Folder, locationMgr: CLLocationManager, picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], collectionView: UICollectionView){
        
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        
        if Reachability.isConnectedToNetwork() && CLLocationManager.locationServicesEnabled() && !isSim {
            locationMgr.startUpdatingLocation()
            picker.dismiss(animated: true, completion: nil)
            selectedFolder.setNewImage(newImage:  (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            
            
           
            
            
        }else{
            picker.dismiss(animated: true, completion: nil)
            selectedFolder.setNewImage(newImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            print("no networking")
            //self.location = Location()
            selectedFolder.addImageToRealm(newImage: selectedFolder.getNewImage(), location: Location(), date: Date())
            
            collectionView.reloadData()
            
        }
    }
    
    
    public static func takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: Folder, locationMgr: CLLocationManager, picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        
        if Reachability.isConnectedToNetwork() && CLLocationManager.locationServicesEnabled() && !isSim {
           locationMgr.startUpdatingLocation()
            picker.dismiss(animated: true, completion: nil)
            self.newImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            selectedFolder.setNewImage(newImage:  (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            
            print("new  ")
            print(selectedFolder.getNewImage())
            
            
        }else{
            picker.dismiss(animated: true, completion: nil)
            selectedFolder.setNewImage(newImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            print("no networking")
            //self.location = Location()
            selectedFolder.addImageToRealm(newImage: selectedFolder.getNewImage(), location: Location(), date: Date())
            
        }
    }
    
    public static func initCameraPicker(controller:UIViewController ,pickerController: UIImagePickerController){
        pickerController.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    public static func addPhotoWhenClickingCameraBtn(selectedFolder: Folder, controller: UIViewController, pickerController: UIImagePickerController){
        //if in simulator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            AlertDialog.showAlertMessage(controller: controller, title: "", message:"Device has no camera" , btnTitle: "Ok")
            //for _ in 1...100{
            selectedFolder.addImageToRealm(newImage: #imageLiteral(resourceName: "testing"), location: Location(), date: Date())
            //}
            
        }//if in real device
        else{
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            controller.present(pickerController, animated: true, completion: nil)
            selectedFolder.setDidAddAlready(didAddAlready: false)
            
        }
    }
    
    public static func addImageToRealmWhenOnDeviceWithNetworking(locationMgr: CLLocationManager, locations: [CLLocation], selectedFolder: Folder){
        LocationService.getLocationDate(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder) { (location) in
            
            print(location)
            
            if !selectedFolder.getDidAddAlready(){
                //for _ in 1...100{
                
                print(selectedFolder.getNewImage())
                
                selectedFolder.addImageToRealm(newImage: self.newImage, location: location, date: Date())
                //}
                //DispatchQueue.main.async {
               
                // }
                selectedFolder.setDidAddAlready(didAddAlready: true)
                
            }
        }
    }
    
    
    public static func addImageToRealmWhenOnDeviceWithNetworking(locationMgr: CLLocationManager, locations: [CLLocation], selectedFolder: Folder, collectionView: UICollectionView){
        LocationService.getLocationDate(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder) { (location) in
            
            if !selectedFolder.getDidAddAlready(){
                //for _ in 1...100{
                selectedFolder.addImageToRealm(newImage: selectedFolder.getNewImage(), location: location, date: Date())
                //}
                //DispatchQueue.main.async {
                
                collectionView.reloadData()
                // }
                selectedFolder.setDidAddAlready(didAddAlready: true)
                
            }
        }
    }
    
    public static func addPhotoWhenClickingCameraBtn(selectedFolder: Folder, controller: UIViewController, collectionView: UICollectionView, pickerController: UIImagePickerController){
        //if in simulator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            AlertDialog.showAlertMessage(controller: controller, title: "", message:"Device has no camera" , btnTitle: "Ok")
            //for _ in 1...100{
            selectedFolder.addImageToRealm(newImage: #imageLiteral(resourceName: "testing"), location: Location(), date: Date())
            //}
            collectionView.reloadData()
            
        }//if in real device
        else{
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            controller.present(pickerController, animated: true, completion: nil)
            selectedFolder.setDidAddAlready(didAddAlready: false)
            
        }
    }
    
    
}

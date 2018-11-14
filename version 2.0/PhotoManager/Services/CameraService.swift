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
import ReachabilitySwift

class CameraService{
    
    static var newImage = UIImage()
    
    
    
    //image view
    public static func takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: Folder, locationMgr: CLLocationManager, picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any], collectionView: UICollectionView){
        
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        if  !isSim {

                print("Network is available")
                print("Internet connection is good")
                    locationMgr.startUpdatingLocation()
                    print("123")
                    picker.dismiss(animated: true, completion: nil)
                    selectedFolder.setNewImage(newImage:  (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        }
        else{
            print("Network is Unavailable")
            print("No internet connection can be found")
            picker.dismiss(animated: true, completion: nil)
            selectedFolder.setNewImage(newImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            print("no networking")
            //self.location = Location()
            selectedFolder.addImageToRealm(newImage: selectedFolder.getNewImage(), location: Location(), date: Date())

            collectionView.reloadData()
        }
   
    }
    
    //navigation
    public static func takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: Folder, locationMgr: CLLocationManager, picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        print("ahsfkjsldjfldsjfkldsfjklsd")
        
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        
        
        if  !isSim {

                print("Internet connection is good")
                
                locationMgr.startUpdatingLocation()
                picker.dismiss(animated: true, completion: nil)
                self.newImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
                selectedFolder.setNewImage(newImage:  (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
                
                print("new  ")
                print(selectedFolder.getNewImage())
            
        }else{
            print("Network is Unavailable")
            print("No internet connection can be found")
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
            pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.off
            controller.present(pickerController, animated: true, completion: nil)
            selectedFolder.setDidAddAlready(didAddAlready: false)
            
        }
    }
    
    //for navigation
    public static func addImageToRealmWhenOnDeviceWithNetworking(locationMgr: CLLocationManager, locations: [CLLocation], selectedFolder: Folder){
        LocationService.getLocationDate(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder, uiImage: self.newImage ) { (location) in
            
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
    
    
    //for imageView
    public static func addImageToRealmWhenOnDeviceWithNetworking(locationMgr: CLLocationManager, locations: [CLLocation], selectedFolder: Folder, collectionView: UICollectionView){
        print("22452")
        LocationService.getLocationDate(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder, uiImage: selectedFolder.getNewImage()) { (location) in
            print("222")
//            if location.getAddressString() != "Address is unavailable"{
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
            pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashMode.off
            controller.present(pickerController, animated: true, completion: nil)
            selectedFolder.setDidAddAlready(didAddAlready: false)
            
        }
    }
    
    
}

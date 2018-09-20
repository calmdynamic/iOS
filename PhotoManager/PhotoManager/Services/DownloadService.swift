//
//  DownloadService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-16.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class DownloadService{
    
//    static var currentKey:String!
//    static var currentID:String!
//
    
    
    
    static func downlaodAllDataAfterFirstTime(imageArray: ImageArray, activityIndicator: UIActivityIndicatorView, tableView: UITableView, noDataAvailableLabel: UILabel){
        print("2")
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        
        Database.database().reference().child(userEmail).queryOrdered(byChild: "imageID").queryEnding(atValue: imageArray.getCurrentID()).queryLimited(toLast: 5).observeSingleEvent(of: .value , with: { (snap:DataSnapshot) in
            
            
            // let index = self.imagesURL.count
            
            if snap.childrenCount > 0 {
                
                DownloadService.fetchAllData(snap: snap, image: imageArray, activityIndicator: activityIndicator)
                showNoDataLabel(imageArray: imageArray, noDataAvailableLabel: noDataAvailableLabel)
                tableView.reloadData()
            }else{
                
                activityIndicator.stopAnimating()
                
            }
            
        })
    }
    
    
    
    static func downlaodSpecificDataAfterFirstTime(category: String, subCategory: String, imageArray: ImageArray, activityIndicator: UIActivityIndicatorView, tableView: UITableView, noDataAvailableLabel: UILabel){
        print("2")
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        
        Database.database().reference().child(userEmail).queryOrdered(byChild: "imageID").queryEnding(atValue: imageArray.getCurrentID()).queryLimited(toLast: 5).observeSingleEvent(of: .value , with: { (snap:DataSnapshot) in
            
            
            // let index = self.imagesURL.count
            
            if snap.childrenCount > 0 {
                
                //DownloadService.fetchSpecificData(category: category, subCategory: subCategory, snap: snap, image: imageArray, activityIndicator: activityIndicator)
                
                DownloadService.fetchAllData(snap: snap, image: imageArray, activityIndicator: activityIndicator)
                
                imageArray.filterImage(categoryName: category, subcategoryName: subCategory)
                
                showNoDataLabel(imageArray: imageArray, noDataAvailableLabel: noDataAvailableLabel)
                tableView.reloadData()
            }else{
                
                activityIndicator.stopAnimating()
                
            }
            
        })
    }
    
    static func downlaodAllDataForTheFirstTime(imageArray: ImageArray, activityIndicator: UIActivityIndicatorView, tableView: UITableView, noDataAvailableLabel: UILabel){
        print("1")
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        
        Database.database().reference().child(userEmail).queryOrdered(byChild: "imageID").queryLimited(toLast: 8).observeSingleEvent(of: .value) { (snap:DataSnapshot) in
            
            
            // let index = self.imagesURL.count
            
            if snap.childrenCount > 0 {
                DownloadService.fetchAllData(snap: snap, image: imageArray, activityIndicator: activityIndicator)
                showNoDataLabel(imageArray: imageArray, noDataAvailableLabel: noDataAvailableLabel)
                tableView.reloadData()
            }else{
                
                activityIndicator.stopAnimating()
                noDataAvailableLabel.isHidden = false
            }
        }
    }
    
    
    static func downlaodSpecificDataForTheFirstTime(imageArray: ImageArray, activityIndicator: UIActivityIndicatorView, tableView: UITableView, noDataAvailableLabel: UILabel, category: String, subCategory: String){
        print("1")
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        
        Database.database().reference().child(userEmail).queryOrdered(byChild: "imageID").queryLimited(toLast: 8).observeSingleEvent(of: .value) { (snap:DataSnapshot) in
            
            
            // let index = self.imagesURL.count
            
            if snap.childrenCount > 0 {
//                DownloadService.fetchSpecificData(category: category, subCategory: subCategory, snap: snap, image: imageArray, activityIndicator: activityIndicator)
                
                DownloadService.fetchAllData(snap: snap, image: imageArray, activityIndicator: activityIndicator)
                
                imageArray.filterImage(categoryName: category, subcategoryName: subCategory)
                
                
                showNoDataLabel(imageArray: imageArray, noDataAvailableLabel: noDataAvailableLabel)
                tableView.reloadData()
            }else{
                
                activityIndicator.stopAnimating()
                noDataAvailableLabel.isHidden = false
            }
        }
    }
    
    static func showNoDataLabel(imageArray: ImageArray, noDataAvailableLabel: UILabel){
        if imageArray.isEmpty(){
            noDataAvailableLabel.isHidden = false
        }else{
            noDataAvailableLabel.isHidden = true
        }
    }
    
    static func fetchSpecificData(category: String, subCategory: String, snap: DataSnapshot, image: ImageArray, activityIndicator: UIActivityIndicatorView){
        
//        if snap.childrenCount > 0 {
        
            
            var totalCount = 0
            var count = 0
            
            for s in snap.children.allObjects as! [DataSnapshot]{
                let item = s.value as! Dictionary<String,AnyObject?>
                
                let subCategoryName = item["subCategoryName"] as? String
                let categoryName = item["categoryName"] as? String
                
                if (subCategoryName == subCategory && categoryName == category) {
                    totalCount = count+1
                }
            }
            
            
            let first = snap.children.allObjects.first as! DataSnapshot
            
            for s in snap.children.allObjects as! [DataSnapshot]{
                
                let item = s.value as! Dictionary<String,AnyObject?>
                
                let subCategoryName = item["subCategoryName"] as? String
                let categoryName = item["categoryName"] as? String
                
                if subCategoryName == subCategory && categoryName == category{
                    count = count + 1
                    image.downloadFromFirebase(item)
                }
                
                if count == totalCount{
                    activityIndicator.stopAnimating()
                }
            }
            
            
            
            image.setCurrentKey(currentKey: first.key)
        
            image.setCurrentID(currentID: first.childSnapshot(forPath: "imageID").value as! String)
        
            
//    }
    }
    static func fetchAllData(snap: DataSnapshot, image: ImageArray, activityIndicator: UIActivityIndicatorView){
        
//        if snap.childrenCount > 0 {
        
            let first = snap.children.allObjects.first as! DataSnapshot
            
            
            
            var totalCount = 0
            var count = 0
            
            for _ in snap.children.allObjects as! [DataSnapshot]{
                totalCount = count+1
            }
            
            
            
            for s in snap.children.allObjects as! [DataSnapshot]{
                count = count + 1
                if s.key != image.getCurrentKey(){
                    let item = s.value as! Dictionary<String,AnyObject?>
                    
                    image.downloadFromFirebase(item)
                    
                }
                
                if count == totalCount{
                    activityIndicator.stopAnimating()
                }
            }
            
        image.setCurrentKey(currentKey: first.key)
        
        image.setCurrentID(currentID: first.childSnapshot(forPath: "imageID").value as! String)
//    }
    }
    
    public static func saveDownloadedImage(selectedFolder: Folder, imageArray: ImageArray, tableView: UITableView, controller:UIViewController, indexPath: IndexPath){
        
        let currentCell = tableView.cellForRow(at: indexPath) as! DownloadTableViewCell
        
        
        selectedFolder.addImageToRealm(newImage: currentCell.imagePicture.image!, location: imageArray.getImageFromArray(index: indexPath.item).getLocation(), date: imageArray.getImageFromArray(index: indexPath.item).getDateCreated())
        
        AlertDialog.showAlertMessage(controller: controller, title: "Message", message: "Saved Successfully", btnTitle: "Ok")
        
    }
    





    static func fetechSpecificData(imagesArray: ImageArray, activityIndicator: UIActivityIndicatorView, tableView: UITableView, noDataAvailableLabel: UILabel, newFolderType: String, newFolder: String, controller: UIViewController)
{
    
    
    if Reachability.isConnectedToNetwork(){
        if Auth.auth().currentUser != nil{
            
            activityIndicator.startAnimating()
            if imagesArray.getCurrentKey() == ""{
                
                DownloadService.downlaodSpecificDataForTheFirstTime(imageArray: imagesArray, activityIndicator: activityIndicator, tableView: tableView, noDataAvailableLabel: noDataAvailableLabel, category: newFolderType, subCategory: newFolder)
                
            }else{
                DownloadService.downlaodSpecificDataAfterFirstTime(category: newFolderType, subCategory: newFolder, imageArray: imagesArray, activityIndicator: activityIndicator, tableView: tableView, noDataAvailableLabel: noDataAvailableLabel)
                
            }
            
            
            
            
        }else{
            AlertDialog.showAlertMessage(controller: controller, title: "Message", message: "You have not signed in the firebase account; You cannot upload images", btnTitle: "Ok")
            
        }
    }else{
        AlertDialog.showAlertMessage(controller: controller, title: "No Networking Message", message: "No Networking Detection", btnTitle: "Ok")
    }
    
    
    
    
    }
    
    
    static func fetechAllData(imagesArray: ImageArray, activityIndicator: UIActivityIndicatorView, tableView: UITableView, noDataAvailableLabel: UILabel, controller: UIViewController)
    {
        
        
        
        if Reachability.isConnectedToNetwork(){
            if Auth.auth().currentUser != nil{
                
                activityIndicator.startAnimating()
                if imagesArray.getCurrentKey() == ""{
                    
                    DownloadService.downlaodAllDataForTheFirstTime(imageArray: imagesArray, activityIndicator: activityIndicator, tableView: tableView, noDataAvailableLabel: noDataAvailableLabel)
                    
                }else{
                    DownloadService.downlaodAllDataAfterFirstTime(imageArray: imagesArray, activityIndicator: activityIndicator, tableView: tableView, noDataAvailableLabel: noDataAvailableLabel)
                    
                }
                
                
                
                
            }else{
                AlertDialog.showAlertMessage(controller: controller, title: "Message", message: "You have not signed in the firebase account; You cannot download images", btnTitle: "Ok")
                
            }
        }else{
            AlertDialog.showAlertMessage(controller: controller, title: "No Networking Message", message: "No Networking Detection", btnTitle: "Ok")
        }
        
        
        
    }
    
}

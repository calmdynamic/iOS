//
//  SharingService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-14.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
class SharingService{
    public static func shareImageWithFriends(controller: UIViewController ,currentIndex: Int, selectedFolder: Folder){
        let imageTitle = "Image #\(currentIndex+1)"
        let image = selectedFolder.getImageArray()[currentIndex]
        let imagePicture = image.loadImageFromPath()
        let typeName = selectedFolder.getCategoryName()
        let folderName = selectedFolder.getName()
        let imageLocationString = selectedFolder.getImageArray()[currentIndex].getLocation().getStreet() != "" ? image.getLocation().getStreet() + " " + image.getLocation().getCity() + " " + image.getLocation().getProvince() : "Address is unavailable"
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        let mydt = dateFormatter.string(from: image.getDateCreated())
        let dateCreated = "Date Created: " + mydt
        
        dateFormatter.dateFormat = "hh:mm:ss a"
        let mytt = dateFormatter.string(from: image.getDateCreated())
        let timeCreated = "Time Created: " + mytt
        
        
        var hashTagsString = ""
        for i in image.getHashTags(){
            hashTagsString += i.getHashTag() + " "
        }
        hashTagsString = "Hashtag(s): " + hashTagsString
        
        
        let shareAll = [imageTitle, imagePicture!, typeName, folderName, imageLocationString, dateCreated, timeCreated, hashTagsString] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.setValue("PhotoManager: " + imageTitle, forKey: "Subject")
        activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
        
        // present the view controller
        controller.present(activityViewController, animated: true, completion: nil)
        
        
    }
}

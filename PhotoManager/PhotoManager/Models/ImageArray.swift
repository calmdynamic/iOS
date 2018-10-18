//
//  ImageArray.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-17.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
class ImageArray{
    
    private var imageArray: [Image] = [Image]()
    private var currentKey:String! = ""
    private var currentID:String! = ""
    
    public func getCurrentKey()->String{
        return self.currentKey
    }
    
    public func getCurrentID()->String{
        return self.currentID
    }
    
    public func setCurrentKey(currentKey: String){
        self.currentKey = currentKey
    }
    
    public func setCurrentID(currentID: String){
        self.currentID = currentID
    }
    
    public func getImageArray()-> [Image]{
        return self.imageArray
    }
    
    public func setImageArray(imageArray: [Image]){
        self.imageArray = imageArray
    }
    
    public func getImageFromArray(index: Int)->Image{
        return self.imageArray[index]
    }
    
    public func addOneElementToImageArray(image: Image){
        self.imageArray.append(image)
    }
    
    public func removeOneElementFromImageArray(index: Int){
        self.imageArray.remove(at: index)
    }
    
    public func getTotalSize()->Int{
        return self.imageArray.count
    }
    
//    public func downloadFromFirebase(_ item : Dictionary<String,AnyObject?>){
//        let userImageID = item["imageID"] as? String
//        let userHashtag = item["Hashtag"] as? [String: String]
//        let userLocation = item["location"] as? NSDictionary
//        let userDate = item["dateCreated"] as? NSDictionary
//        let imageURL = item["imageURL"] as? String
//        let subCategoryName = item["subCategoryName"] as? String
//        let categoryName = item["categoryName"] as? String
//        
//        let uploadedDate = item["uploadedDate"] as? NSDictionary
//        
//        let newImage = Image(imageID: userImageID!,
//                             categoryName: categoryName!, subCategoryName: subCategoryName! ,dateCreated: FirebaseService.getDateFromFirebase(userDate!), imagePath: imageURL!, hashTags: FirebaseService.getHashTagDataFromFirebase(userHashtag!), location: FirebaseService.getLocationDataFromFirebase(userLocation!))
//        newImage.setUploadedTime(FirebaseService.getDateFromFirebase(uploadedDate!))
//        
//        
//        
//        self.imageArray.append(newImage)
//    }
    
    public func emptyArray(){
        self.imageArray = [Image]()
    }
    
    public func isEmpty() -> Bool{
        return self.imageArray.isEmpty
    }
    
    func filterImage(categoryName: String, subcategoryName: String){
        let newImageArray = self.imageArray.filter{ $0.getCategoryName().contains(categoryName) && $0.getSubcategoryName().contains(subcategoryName)}
        self.emptyArray()
        self.imageArray = newImageArray
    }
}

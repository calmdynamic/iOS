//
//  Folder.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift

class Folder: Object{
    @objc private dynamic  var folderID: String = UUID().uuidString
    @objc private dynamic var name: String = ""
    @objc private dynamic var categoryName: String = ""
    @objc private dynamic var createdDate: Date = Date()
    @objc private dynamic var imageCount: Int = 0
    
//    private let folders = LinkingObjects(fromType: Type.self, property: "folders")
//    var folder: Type {
//        return self.folders.first!
//    }
    //private var locations = List<Location>()
    private var images = List<Image>()
    private var imageArray:[Image] = [Image]()
    
    
    

    override class func primaryKey() -> String?{
        return "folderID"
    }
    
    convenience init(name: String, createdDate: Date, images: List<Image>, imageCount: Int, categoryName: String){
        self.init()
        self.name = name
        self.createdDate = createdDate
        self.images = images
        self.imageCount = imageCount
        self.categoryName = categoryName
    }

    public func setName(_ name: String){
        self.name = name
    }
    
    public func setCreatedDate(_ createdDate: Date){
        self.createdDate = createdDate
    }
    public func setImages(_ images: List<Image>){
        self.images = images
    }
    
    public func getImageCount() -> Int{
        return self.imageCount
    }
    public func getFolderID() -> String{
        return self.folderID
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getCreatedDate() -> Date{
        return self.createdDate
    }
    
    public func getImages() -> List<Image>{
        return self.images
    }
    
    public func getImageArray()->[Image]{
        return self.imageArray
    }
    
    public func setImageArray(imageArray: [Image]){
        self.imageArray = imageArray
    }
    
    public func addElementToImageArray(image: Image){
        self.imageArray.append(image)
    }
    
    public func clearImageArray(){
        self.imageArray = [Image]()
    }
    
    func addImageForTestingToRealm(){
        let realmImages = self.getImages()
        
        var images: List<Image>
        if realmImages.isEmpty{
            images = List<Image>()
        }else{
            images = List<Image>()
            for image in realmImages{
                images.append(image)
            }
        }
        
        let data = NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "testing"), 0.9)!)
        
        let hashTags = List<HashTag>()
        
        let hashTag1 = HashTag(hashTag: "#"+self.getName())
        let hashTag2 = HashTag(hashTag: "#"+self.categoryName)
        
        if self.getName() == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        
        // in simulator it goes so quickly no enough time to get valiue so nil
        /// in real device you need time to take a photo so 8000millisecond
        //it neeeds at least 1 second to get value
        // i could delay it se not good
        let newLocation = Location(latitude: 47, longtitude: -122, street: "", city: "", province: "")
        //if location != nil{
//            newLocation = Location(latitude: self.images.location.getLatitude(), longtitude: self.location.getLongtitude(), street: self.location.getStreet(), city: self.location.getCity(), province: self.location.getProvince())
        //}
        let newRealmFormattedDate = Image(dateCreated: Date(), imageBinaryData: data, hashTags: hashTags, location: newLocation)
        //print(self.location)
        
        images.append(newRealmFormattedDate)
        
        RealmService.shared.update(self, with: ["name": self.getName(), "createdDate": self.getCreatedDate(), "imageCount": images.count, "images": images])
        
        
        self.imageArray.append(newRealmFormattedDate)
        //return newRealmFormattedDate
    }
    
    func addOneOrMultipleHashtagToImages(indexpaths: [IndexPath], newHashtagName: String){
        
        //if let indexpaths = indexpaths {
            for item  in indexpaths {
                //self.collectionView?.deselectItem(at: (item), animated: true)
                
                let image = self.getImageArray()[item.row]
                
                image.addOneHashtagToRealm(newHashtagName: newHashtagName)
                
              
                
            }
            
        //}
    }
        

}

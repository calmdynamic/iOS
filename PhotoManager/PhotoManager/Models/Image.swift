//
//  Image.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
class Image: Object{
    @objc private dynamic var imageID: String = UUID().uuidString
    @objc private dynamic var dateCreated: Date = Date()
    @objc private dynamic var imageBinaryData: NSData?
    @objc private dynamic var location: Location?
    private var hashTags = List<HashTag>()
   // private let hashTags = LinkingObjects<HashTag>(fromType: HashTag.self, property: "images")

    override class func primaryKey() -> String?{
        return "imageID"
    }
    
    convenience init(dateCreated: Date ,imageBinaryData: NSData, hashTags: List<HashTag>, location: Location){
        self.init()
        self.dateCreated = dateCreated
        self.imageBinaryData = imageBinaryData
        self.hashTags = hashTags
        self.location = location

    }
    
    convenience init(dateCreated: Date ,image: UIImage, hashTags: List<HashTag>, location: Location){
        self.init()
        self.dateCreated = dateCreated
        self.setImageBinaryData(image)
        self.hashTags = hashTags
        self.location = location
        
    }
    
    convenience init(imageID: String, dateCreated: Date ,image: UIImage, hashTags: List<HashTag>, location: Location){
        self.init()
        self.imageID = imageID
        self.dateCreated = dateCreated
        self.setImageBinaryData(image)
        self.hashTags = hashTags
        self.location = location
        
    }
    
    public func setLocation(_ location: Location){
        self.location = location
    }
    
    
    public func setHashTags(_ hashtags: List<HashTag>){
        self.hashTags = hashtags
    }
    
    public func setDateCreated(_ dateCreated: Date){
        self.dateCreated = dateCreated
    }
    
    public func setImageBinaryData(_ imageBinaryData: NSData){
        self.imageBinaryData = imageBinaryData
    }
    
    public func setImageBinaryData(_ image: UIImage){
        self.imageBinaryData = NSData(data: UIImageJPEGRepresentation(image, 0.9)!)
    }
    
    public func getLocation() -> Location{
        return self.location!
    }
    
    public func getImageID() -> String{
        return self.imageID
    }
    
    public func getHashTags() -> List<HashTag>{
        return self.hashTags
    }
    
    
    public func getDateCreated() -> Date{
        return self.dateCreated
    }
    
    public func getImageBinaryData() -> NSData{
        return self.imageBinaryData!
    }
    
    public func getUIImage() -> UIImage{
        return  UIImage(data: (self.imageBinaryData)! as Data, scale:1.0)!
    }
//    
//    public func getHashTags() -> LinkingObjects<HashTag>{
//        return self.hashTags
//    }
    public func getHashTagDictionary() -> NSDictionary{
        var dict = [String: String]()
        for hashtag in self.hashTags {
            dict[hashtag.getHashTagID()] = hashtag.getHashTag()
        }
        
        return dict as NSDictionary
    }
    
    public func repeatedHashTagFound(_ typeText: String!) -> Bool{
            
        if let tempTypeName = typeText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in self.hashTags{
                if tempTypeName == i.getHashTag(){
                    return true
                }
                
            }
            
        }
        return false
        
    }
    
    public func addOneHashtagToRealm(newHashtagName: String){
                
        var hashtags: List<HashTag>
        hashtags = List<HashTag>()
        
        for i in self.getHashTags(){
            
            hashtags.append(HashTag(hashTag: i.getHashTag()))
        }
        
        hashtags.append(HashTag(hashTag: newHashtagName))
        
        for i in self.getHashTags(){
            RealmService.shared.delete(i)
        }
        
        
        RealmService.shared.update(self, with: ["dateCreated": self.getDateCreated(), "imageBinaryData": self.getImageBinaryData(),"hashTags": hashtags])
        
    }

   
    
}


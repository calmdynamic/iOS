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
    
//    public func getHashTags() -> LinkingObjects<HashTag>{
//        return self.hashTags
//    }
    
}


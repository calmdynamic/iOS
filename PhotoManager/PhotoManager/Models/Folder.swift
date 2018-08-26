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
    @objc private dynamic var createdDate: Date = Date()
    @objc private dynamic var imageCount: Int = 0
    private let folders = LinkingObjects(fromType: Type.self, property: "folders")
    var folder: Type {
        return self.folders.first!
    }
    //private var locations = List<Location>()
    private var images = List<Image>()

    override class func primaryKey() -> String?{
        return "folderID"
    }
    
    convenience init(name: String, createdDate: Date, images: List<Image>, imageCount: Int){
        self.init()
        self.name = name
        self.createdDate = createdDate
        self.images = images
        self.imageCount = imageCount
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
        

}

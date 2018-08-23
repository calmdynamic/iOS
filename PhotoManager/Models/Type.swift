//
//  Type.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
class Type: Object{
    @objc private dynamic var typeID: String = UUID().uuidString
    @objc private dynamic var name: String = ""
    @objc private dynamic var dateCreated: Date = Date()
    @objc private dynamic var folderCount: Int = 0
    private var folders = List<Folder>()//from realm not swift itself
    
    override class func primaryKey() -> String?{
        return "typeID"
    }
    
    convenience init(name: String, folders: List<Folder>, folderCount: Int){
        self.init()
        self.name = name
        self.folders = folders
        self.dateCreated = Date()
        self.folderCount = folderCount
    }
    
    public func setName(_ name: String){
        self.name = name
    }
    
    
    public func setFolder(_ folders: List<Folder>){
        self.folders = folders
    }
    
    public func getFolderCount() -> Int{
        return self.folderCount
    }
    
    
    public func getDateCreated() -> Date{
        return self.dateCreated
    }
    
    public func getTypeID() -> String{
        return self.typeID
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getFolders() -> List<Folder>{
        return self.folders
    }
    
}

//
//  UserDefaultService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-17.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift

class UserDefaultService{
    static let defaults = UserDefaults.standard
    
    
    public static func isFolderTypeExisted(selectedFolderType: String)->Bool{
        let folderType = TypeList()
        folderType.getFolderTypeDataFromRealm()
        
        for i in folderType.getFolderTypes(){
            if i.getName() == selectedFolderType{
                return true
            }
        }
        
        return false
    }
    
    public static func isFolderExistedWithinFolderType(selectedFolderType: String, selectedFolder: String)->Bool{
        let folderType = TypeList()
        folderType.getFolderTypeDataFromRealm()
        
        for i in folderType.getFolderTypes(){
            if i.getName() == selectedFolderType{
                for j in i.getFolders(){
                    if j.getName() == selectedFolder{
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    
    public static func getUserDefaultFolderName2()->String{
        let selectedFolderName = self.defaults.string(forKey: "selectedFolder") ?? ""
        let selectedFolderTypeName = defaults.string(forKey: "selectedFolderType") ?? ""
        
        
        if !self.isFolderExistedWithinFolderType(selectedFolderType: selectedFolderTypeName, selectedFolder: selectedFolderName){
            
            defaults.set("Default", forKey: "selectedFolderType")
            defaults.set("Default", forKey: "selectedFolder")
            
        }
        
        return self.defaults.string(forKey: "selectedFolder") ?? ""
    }
    
    
    public static func getUserDefaultFolderTypeName2()->String{
        let selectedFolderTypeName = self.defaults.string(forKey: "selectedFolderType") ?? ""
        
        if !self.isFolderTypeExisted(selectedFolderType: selectedFolderTypeName){
            
            defaults.set("Default", forKey: "selectedFolderType")
            defaults.set("Default", forKey: "selectedFolder")
            
        }
        
        return self.defaults.string(forKey: "selectedFolderType") ?? ""
    }
    

}

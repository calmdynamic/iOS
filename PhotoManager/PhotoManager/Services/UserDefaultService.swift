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
    
    
    public static func getUserDefaultFolderTypeName()-> String{
        var isEmpty: Bool
        isEmpty = false
        var tempFolderType: Results<Type>?
        if let selectedFolderTypeName = defaults.string(forKey: "selectedFolderType"){
            tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", selectedFolderTypeName)
            if(!(tempFolderType?.isEmpty)!){
                isEmpty = false
            }else{
                isEmpty = true
            }
        }
        
        let selectedFolderName = self.defaults.string(forKey: "selectedFolder")
        
        for i in tempFolderType!{
            print("folder printing...")
            print(i.getName())
            if i.getFolders().count == 0{
                 defaults.set("Default", forKey: "selectedFolderType")
            }else{
            
            for j in i.getFolders(){
                if j.getName() != selectedFolderName{
                defaults.set("Default", forKey: "selectedFolderType")
                }
            }
            }

        }
        

        if (isEmpty){
            tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", "Default")
            defaults.set("Default", forKey: "selectedFolderType")
            //defaults.set("Default", forKey: "selectedFolder")
        }

            return self.defaults.string(forKey: "selectedFolderType") ?? ""

    }
    
    
    
    
    public static func getUserDefaultFolderName()-> String{
        var isEmpty: Bool
        isEmpty = false
        var tempFolder: Results<Folder>?
        if let selectedFolderName = defaults.string(forKey: "selectedFolder"){
            tempFolder = RealmService.shared.realm.objects(Folder.self).filter("name = %@", selectedFolderName)
            if(!(tempFolder?.isEmpty)!){
                isEmpty = false
            }else{
                isEmpty = true
            }
        }
        
        if (isEmpty){
            tempFolder = RealmService.shared.realm.objects(Folder.self).filter("name = %@", "Default")
            //defaults.set("Default", forKey: "selectedFolderType")
            defaults.set("Default", forKey: "selectedFolder")
            
        }
//
//        if self.defaults.string(forKey: "selectedFolderType") ?? "" == "Default"{
//            print("3")
//            return "Default"
//        }else{
//            print("4")
            return self.defaults.string(forKey: "selectedFolder") ?? ""
//        }
    }
}

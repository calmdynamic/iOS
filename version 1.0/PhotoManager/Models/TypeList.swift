//
//  TypeList.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-24.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
class TypeList{
    
    private var folderTypes: [Type]!
    private var numOfSelection: Int!
    private var ascSort: Bool!
    
    init() {
        self.folderTypes = [Type]()
    }
    
    func setFolderTypes(_ folderTypes: [Type]){
        self.folderTypes = folderTypes
    }
    
    
    func getFolderTypes() -> [Type]{
        return self.folderTypes
    }
    
    func getASCSort()-> Bool{
        return self.ascSort
    }
    
    func addFolderTypeToRealm(typename: String){
        var folders: List<Folder>
        folders = List<Folder>()
        let newType = Type(name: typename, folders: folders)
        
        newType.addToRealm()
        self.folderTypes.append(newType)
    }
    
    func getNumOfEmptyFolderType()->Int{
        var count = 0
        
        for i in self.folderTypes{
            if i.getFolderCount() == 0{
                count = count + 1
            }
            
        }
        return count
    }
    
    func getNumOfReaminingFolderType()->Int{
        var count = 0
        
        for i in self.folderTypes{
            if i.getFolderCount() != 0{
                count = count + 1
            }
            
        }
        if self.folderTypes.count == count{
            return 0
        }else{
            return count
        }
    }
    
    func createTypeData(){
        self.addFolderTypeToRealm(typename: "Default")
        self.addFolderTypeToRealm(typename: "Mountains")
        self.addFolderTypeToRealm(typename: "Sports")
        self.addFolderTypeToRealm(typename: "Animals")
        self.addFolderTypeToRealm(typename: "Buildings")
        self.addFolderTypeToRealm(typename: "Movies")
        self.addFolderTypeToRealm(typename: "Science")
        self.addFolderTypeToRealm(typename: "Fruits")
        self.addFolderTypeToRealm(typename: "Plant")
        self.addFolderTypeToRealm(typename: "Planets")
        self.addFolderTypeToRealm(typename: "Games")
        self.addFolderTypeToRealm(typename: "Food")
        self.addFolderTypeToRealm(typename: "Weather")

    }
    
    func deletedAllTypeImage(deletedFolderTypes: [Type]){
        for i in deletedFolderTypes{
            for j in i.getFolders(){
                j.deleteImageFromFileDirectory(deletedImages: j.getImages())
            }
        }
    }
    
    
    func deleteFolderTypeFromRealm(indexpaths: [IndexPath]){
        
        var deletedFolderTypes:[Type] = []

        for item  in indexpaths {
            let folderType = self.getOneFolderTypeByIndedx(index: item.row)

            deletedFolderTypes.append(folderType)
        }
        
        self.deletedAllTypeImage(deletedFolderTypes: deletedFolderTypes)
        
        guard let database = try? Realm() else { return }
        // to delete Result<ContactEntity>
        //let contacts = database.objects(Type.self)
        do {
            try database.write {
                database.delete(deletedFolderTypes, cascading: true)
            }
        } catch {
            // handle write error here
        }

            let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)


            self.folderTypes = [Type]()
            for i in tempFolderTypes{
                self.folderTypes.append(i)
            }
    }
    
    func updateFolderTypeFromRealm(indexpaths: [IndexPath], modifiedName: String){
        for indexPath in indexpaths{
            var sectionFolders: List<Folder>
            if (!self.getOneFolderTypeByIndedx(index: indexPath.item).getFolders().isEmpty){
                sectionFolders = List<Folder>()
                for s in self.getOneFolderTypeByIndedx(index: indexPath.item).getFolders(){
                    sectionFolders.append(s)
                }
            }else{
                sectionFolders = List<Folder>()
            }
            
            
            RealmService.shared.update(self.getOneFolderTypeByIndedx(index: indexPath.item), with: ["name": modifiedName, "folders": sectionFolders])
            
        }
    }
    
    func getOneFolderTypeByName(typeName: String) ->Type{
        for i in self.folderTypes{
            if i.getName() == typeName{
                return i
            }
        }
        return Type()
    }
    
    func getOneFolderTypeByIndedx(index: Int) -> Type{
        return self.folderTypes[index]
    }
    
    func getFolderTypeSize() -> Int{
        return self.folderTypes.count
    }
    
    func foundRepeatedType(_ typeText: String!) -> Bool{
        
        if let tempTypeName = typeText?.trimmingCharacters(in: .whitespaces){
            for i in self.folderTypes{
                if tempTypeName == i.getName(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func getFolderTypeDataFromRealm(){
        let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)

        for i in tempFolderTypes{
            self.folderTypes.append(i)
        }
    }
    
    func clearFolderTypeList(){
        self.folderTypes = [Type]()
    }
    
    func filterFolderType(sortBy: String){
        self.folderTypes = self.folderTypes.filter{ $0.getName().lowercased().contains(sortBy.lowercased() )}
    }
    
    func sortByName(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.folderTypes = self.folderTypes.sorted(by: { $0.getName() > $1.getName() })
        }else{
            self.folderTypes = self.folderTypes.sorted(by: { $0.getName() < $1.getName() })
        }
        
    }
    
    func sortByDateCreated(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.folderTypes = self.folderTypes.sorted(by: { $0.getDateCreated() > $1.getDateCreated() })
        }else{
            self.folderTypes = self.folderTypes.sorted(by: { $0.getDateCreated() < $1.getDateCreated() })
        }
        
    }
    
    func sortByNumOfFolder(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.folderTypes = self.folderTypes.sorted(by: { $0.getFolderCount() > $1.getFolderCount() })
        }else{
            self.folderTypes = self.folderTypes.sorted(by: { $0.getFolderCount() < $1.getFolderCount() })
            
        }
    }
    
    func setDefaultSort(){
        self.ascSort = false
    }

}


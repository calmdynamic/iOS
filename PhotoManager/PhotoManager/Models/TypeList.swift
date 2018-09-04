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
        let newType = Type(name: typename, folders: folders, folderCount: folders.count)
        newType.addToRealm()
        self.folderTypes.append(newType)
    }
    
    func deleteFolderTypeFromRealm(indexpaths: [IndexPath]){
        
        var deletedFolderTypes:[Type] = []
        var folders: List<Folder>
        
        for item  in indexpaths {
            let folderType = self.getOneFolderTypeByIndedx(index: item.row)
//            folders = folderType.getFolders()
//            folderType.deleteFoldersFromRealm(folders: folders)
//
            deletedFolderTypes.append(folderType)
        }
        
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
        
//        for i in deletedFolderTypes{
//            RealmService.shared.delete(i)
//        }
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


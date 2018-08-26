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
    private var nameASCSort: Bool!
    private var dateCreatedASCSort: Bool!
    private var numOfFolderASCSort: Bool!
    
    init() {
        //self.init()
        self.folderTypes = [Type]()
    }
    
    func setFolderTypes(_ folderTypes: [Type]){
        self.folderTypes = folderTypes
    }
    
    func getFolderTypes() -> [Type]{
        return self.folderTypes
    }
    
    
    func addFolderTypeToRealm(typename: String){
        //add a new folder type to the collection view
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
            folders = folderType.getFolders()
            folderType.deleteFoldersFromRealm(folders: folders)
            
            deletedFolderTypes.append(folderType)
        }
        
        
        // no bugs for following code but need to debug test.
//            let realm = try! Realm()
//            try! realm.write {
//                realm.delete(folderTypes)
//            }
        
        
        
        for i in deletedFolderTypes{
            RealmService.shared.delete(i)
        }
            let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)
            
            
            self.folderTypes = [Type]()
            for i in tempFolderTypes{
                self.folderTypes.append(i)
            }
//    }
    }
    
    func updateFolderTypeFromRealm(indexpaths: [IndexPath], modifiedName: String){
        for indexPath in indexpaths{
            // let modifiedName = alertController.textFields?[0].text
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
            
            //self.initButtons()
            //self.collectionView?.reloadData()
            
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
            //var found = false
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
        
        
        //folderTypes = TypeList()
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
        if !self.nameASCSort{
            self.nameASCSort = true
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getName() > $1.getName() })
            
            //self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getName() < $1.getName() })
            
            //self.collectionView.reloadData()
            
        }
        
    }
    
    func sortByDateCreated(){
        if !self.dateCreatedASCSort{
            self.nameASCSort = false
            self.dateCreatedASCSort = true
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getDateCreated() > $1.getDateCreated() })
            
            //self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getDateCreated() < $1.getDateCreated() })
            
            //self.collectionView.reloadData()
            
        }
        
    }
    
    func sortByNumOfFolder(){
        if !self.numOfFolderASCSort{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = true
            self.folderTypes = self.folderTypes.sorted(by: { $0.getFolderCount() > $1.getFolderCount() })
            
            //self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getFolderCount() < $1.getFolderCount() })
            //self.collectionView.reloadData()
            
        }
        
    }
    
    func setDefaultSort(){
        self.nameASCSort = false
        self.dateCreatedASCSort = false
        self.numOfFolderASCSort = false
    }
    

    
    
}


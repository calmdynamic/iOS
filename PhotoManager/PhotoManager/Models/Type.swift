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
    private var folders = List<Folder>()
    
    private var folderArray: [Folder] = [Folder]()
    private var ascSort: Bool!
    
    override class func primaryKey() -> String?{
        return "typeID"
    }
    
    
    convenience init(name: String, folders: List<Folder>){
        self.init()
        self.name = name
        self.folders = folders
        self.dateCreated = Date()
        //self.folderCount = folderCount
        
       
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
    
    public func getImageCount() -> Int{
        var count = 0
        for i in self.getFolders(){
            count = count + i.getImageCount()
        }
        return count
        
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
    
    func getNumOfEmptyFolder()->Int{
        var count = 0
        
        for i in self.folders{
            if i.getImageCount() == 0{
                count = count + 1
            }
            
        }
        return count
    }
    
    func getNumOfRemainingFolder()->Int{
        var count = 0
        
        for i in self.folders{
            if i.getImageCount() != 0{
                count = count + 1
            }
            
        }
        if self.getFolderCount() == count{
            return 0
        }else{
            return count
        }
    }
    
    public func addToRealm(){
        RealmService.shared.create(self)

    }
    
    public func createDefaultFolder(){
         self.addFoldersToRealm(folderName: "Default")
    }
    
    public func createMountainFolders(){
        self.addFoldersToRealm(folderName: "Grouse")
        self.addFoldersToRealm(folderName: "Rocky")
    }
    
    public func createBuildingsFolders(){
        self.addFoldersToRealm(folderName: "Schools")
        self.addFoldersToRealm(folderName: "Chinese")
        self.addFoldersToRealm(folderName: "Japanese")
        self.addFoldersToRealm(folderName: "Castles")
    }
    
    
    
    public func createPlanetsFolders(){
        self.addFoldersToRealm(folderName: "Saturn")
        self.addFoldersToRealm(folderName: "Earth")
        self.addFoldersToRealm(folderName: "Jupiter")
        self.addFoldersToRealm(folderName: "Mercury")
        self.addFoldersToRealm(folderName: "Uranus")
        self.addFoldersToRealm(folderName: "Mars")
        self.addFoldersToRealm(folderName: "Venus")
        self.addFoldersToRealm(folderName: "Neptune")
    }
    
    public func createMovieFolders(){
        self.addFoldersToRealm(folderName: "Action")
        self.addFoldersToRealm(folderName: "Comedy")
        self.addFoldersToRealm(folderName: "Historical")
        self.addFoldersToRealm(folderName: "Adventure")
        self.addFoldersToRealm(folderName: "Crime")
        self.addFoldersToRealm(folderName: "Drama")
        self.addFoldersToRealm(folderName: "Fantasy")
        self.addFoldersToRealm(folderName: "Horror")
        self.addFoldersToRealm(folderName: "Mystery")
        self.addFoldersToRealm(folderName: "Romance")
    }
    
    public func createScienceFolders(){
        self.addFoldersToRealm(folderName: "Biology")
        self.addFoldersToRealm(folderName: "Chemistry")
        self.addFoldersToRealm(folderName: "Physics")
    }
    
    public func createAnimalsFolders(){
        self.addFoldersToRealm(folderName: "Dogs")
        self.addFoldersToRealm(folderName: "Cats")
        self.addFoldersToRealm(folderName: "Fish")
        self.addFoldersToRealm(folderName: "Birds")
        self.addFoldersToRealm(folderName: "Lions")
    }
    
    public func createFoodFolders(){
        self.addFoldersToRealm(folderName: "Fish")
        self.addFoldersToRealm(folderName: "Milk")
        self.addFoldersToRealm(folderName: "Yogurt")
        self.addFoldersToRealm(folderName: "Cheese")
        self.addFoldersToRealm(folderName: "Cereal")
        self.addFoldersToRealm(folderName: "Eggs")
        self.addFoldersToRealm(folderName: "Cakes")
        self.addFoldersToRealm(folderName: "Candy")
    }
    
    public func createFruitFolders(){
        self.addFoldersToRealm(folderName: "Cherries")
        self.addFoldersToRealm(folderName: "Hard")
        self.addFoldersToRealm(folderName: "Soft")
        self.addFoldersToRealm(folderName: "Apples")
        self.addFoldersToRealm(folderName: "Lemons")
        self.addFoldersToRealm(folderName: "Limes")
        self.addFoldersToRealm(folderName: "Mandarines")
        self.addFoldersToRealm(folderName: "Peaches")
    }
    
    public func createSportFolders(){
        self.addFoldersToRealm(folderName: "Olympics")
        //self.folders[0].createOlympicData()
    }
    
   
    public func addFolderToList(folder: Folder){
        self.folders.append(folder)
    }
    
    public func setFolderArray(folders: [Folder]){
        self.folderArray = folders
    }
    
    public func addElementToFolderArray(folder: Folder){
        self.folderArray.append(folder)
    }
    
    public func getFolderArray()->[Folder]{
        return self.folderArray

        //return Array(self.folders)//.sorted(by: { $0.getName() < $1.getName() })
    }
    
    func getASCSort()-> Bool{
        return self.ascSort
    }
    
    func decrementFolderCount(){
        try! self.realm?.write {
            self.folderCount = folderCount - 1
        }
    }
    
    func incrementFolderCount(){
        try! self.realm?.write {
            self.folderCount = folderCount + 1
        }
    }
    
    public func addFoldersToRealm(folderName: String){
        var folders: List<Folder>
        if self.folders.isEmpty{
            folders = List<Folder>()
        }else{
            folders = List<Folder>()
            for sectionFolder in self.folders{
                folders.append(sectionFolder)
            }
            
        }
        let newImages = List<Image>()
        let newFolder = Folder(name: folderName, createdDate: Date() ,images: newImages, categoryName: self.name)
        incrementFolderCount()
        folders.append(newFolder)
        
        RealmService.shared.update(self, with: ["name": name, "folderCount": folders.count, "folders": folders])
        
        self.folderArray.append(newFolder)
    }
    
    public func updateFolderFromRealm(indexpaths: [IndexPath], modifiedName: String){
        for indexPath in indexpaths{
        var imagesInFolders: List<Image>
        if (!self.folderArray[indexPath.item].getImages().isEmpty){
            imagesInFolders = List<Image>()
            for s in self.folderArray[indexPath.item].getImages(){
                imagesInFolders.append(s)
            }
        }else{
            imagesInFolders = List<Image>()
        }
        
        // 1. update the folder from our data source
        let folderType = self.folderArray[indexPath.item]
        RealmService.shared.update(folderType, with: ["name": modifiedName, "createdDate":self.folderArray[indexPath.item].getCreatedDate(),"images": imagesInFolders])
        }
    }
    
    
    
    
    func deleteFolderFromRealm(indexpaths: [IndexPath]){
        var deletedFolders:[Folder] = []
        for item  in indexpaths {
            //self.collectionView?.deselectItem(at: (item), animated: true)
            
            let folder = folderArray[item.row]
            
            decrementFolderCount()
            
            deletedFolders.append(folder)
        }
        
        
        for i in deletedFolders{
            i.deleteImageFromFileDirectory(deletedImages: i.getImages())
        }
        
        guard let database = try? Realm() else { return }
        do {
            try database.write {
                database.delete(deletedFolders, cascading: true)
            }
        } catch {
            // handle write error here
        }
        

        self.folderArray = Array(self.folders)
    }
    
    func repeatedFolderFound(_ folderText: String!) -> Bool{
        
        if let tempFolderName = folderText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in self.folders{
                if tempFolderName == i.getName(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func clearFolderArrayData(){
        self.folderArray = [Folder]()
    }
    
    func getFolderDataFromRealm(typeName: String){
        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", typeName)
        
        let tempFolders = tempFolderType[0].getFolders()
        
        //self.setFolderArray(folders: [Folder]())
        
        for i in tempFolders{
            self.addElementToFolderArray(folder: i)
        }
        
    }
    
    func filterFolder(sortBy: String){
        self.folderArray = self.folderArray.filter{ $0.getName().lowercased().contains(sortBy.lowercased() )}
    }
    
    
    func sortByName(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.folderArray = self.folderArray.sorted(by: { $0.getName() > $1.getName() })
        }else{
            self.folderArray = self.folderArray.sorted(by: { $0.getName() < $1.getName() })
        }
        
    }
    
    func sortByDateCreated(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.folderArray = self.folderArray.sorted(by: { $0.getCreatedDate() > $1.getCreatedDate() })
        }else{
            self.folderArray = self.folderArray.sorted(by: { $0.getCreatedDate() < $1.getCreatedDate() })
        }
        
    }
    
    func sortByNumOfImages(){
        self.ascSort = !self.ascSort
        if self.ascSort{
            self.folderArray = self.folderArray.sorted(by: { $0.getImageCount() > $1.getImageCount() })
        }else{
            self.folderArray = self.folderArray.sorted(by: { $0.getImageCount() < $1.getImageCount() })
            
        }
    }
    
    func setDefaultSort(){
        self.ascSort = false
    }
}

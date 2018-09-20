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
    @objc private dynamic var categoryName: String = ""
    @objc private dynamic var createdDate: Date = Date()
    @objc private dynamic var imageCount: Int = 0
    
    private var images = List<Image>()
    private var imageArray:[Image] = [Image]()
    private var numOfImageSelection: Int = 0
    private var didAddAlready: Bool = false
    private var newImage: UIImage = UIImage()
    
    override class func primaryKey() -> String?{
        return "folderID"
    }
    
    convenience init(name: String, createdDate: Date, images: List<Image>, categoryName: String){
        self.init()
        self.name = name
        self.createdDate = createdDate
        self.images = images
        self.categoryName = categoryName
    }
    
    func createRockeyMountainData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "rockyMountain1"), location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"), date: Date())
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "rockyMountain2"), location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"), date: Date())
    }
    
    func createGrouseMountainData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain1"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"), date: Date())
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain2"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"), date: Date())
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain3"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"), date: Date())
    }
    
    func createOlympicData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "olympicsVancouver1"), location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"), date: Date())
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "olympicsVancouver2"), location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"), date: Date())
    }
    
    func createDefaultData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "testing"), location: Location(), date: Date())
    }
    
    func decrementImageCount(){
        try! self.realm?.write {
            self.imageCount = imageCount - 1
        }
    }
    
    func incrementImageCount(){
        try! self.realm?.write {
            self.imageCount = imageCount + 1
        }
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
    
    public func setNumOfImageSelection(number: Int){
        self.numOfImageSelection = number
    }
    
    public func getNumOfImageSelection()->Int{
        return self.numOfImageSelection
    }
    
    public func setDidAddAlready(didAddAlready: Bool){
        self.didAddAlready = didAddAlready
    }
    
    public func getDidAddAlready()->Bool{
        return self.didAddAlready
    }
    
    public func setNewImage(newImage: UIImage){
        self.newImage = newImage
    }
    
    public func getNewImage() -> UIImage{
        return self.newImage
    }
    
    public func getImageArray()->[Image]{
        return self.imageArray
    }
    
    public func getCategoryName()-> String{
        return self.categoryName
    }
    
    public func setImageArray(imageArray: [Image]){
        self.imageArray = imageArray
    }
    
    public func addElementToImageArray(image: Image){
        self.imageArray.append(image)
    }
    
    public func clearImageArray(){
        self.imageArray = [Image]()
    }
    
    private func getDateString(date: Date) -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy MMM dd"
        let mydt = dateFormatter1.string(from: date)
        
        return mydt
    }
    
    func getDateAndImageDictionary()->[String: [Image]]{
        print("print...")
        var dict: [String: [Image]] = [:]
        
        var newImageCreatedDateString: Set<String> = Set<String>()
        for i in self.getImageArray(){
            newImageCreatedDateString.insert(self.getDateString(date: i.getDateCreated()))
        }
        
        
        for i in newImageCreatedDateString{
            var newImageArray = [Image]()
            for j in self.imageArray{
                
                if i == self.getDateString(date:  j.getDateCreated()){
                    newImageArray.append(j)
                }
            }
            dict[i] = newImageArray
        }
        
        print(dict)
        print("finished print...")
        
        return dict
        
    }
    
    func getImageArraySoryByDate()->[[Image]]{
        let dict: [String: [Image]] = self.getDateAndImageDictionary()
        var imageArray: [[Image]] = [[Image]]()
        
        for i in dict{
            imageArray.append(i.value)
        }
        
        print(imageArray)
        return imageArray
        
    }

    func addImageToRealm(newImage: UIImage, location: Location, date: Date){
        let filenamePath = self.writeImageToDirectoryAndGetFilePath(image: newImage)
        
        let hashTags = List<HashTag>()
        
        let hashTag1 = HashTag(hashTag: "#"+self.getName())
        let hashTag2 = HashTag(hashTag: "#"+self.categoryName)
        
        if self.categoryName == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        let newLocation = Location(latitude: location.getLatitude(), longtitude: location.getLongtitude(), street: location.getStreet(), city: location.getCity(), province: location.getProvince())
        
        let newRealmFormattedImageData = Image(categoryName: self.categoryName, subCategoryName: self.name, dateCreated: date, imagePath: filenamePath as NSString, hashTags: hashTags, location: newLocation)
        
        try! realm?.write {
            images.append(newRealmFormattedImageData)
        }
        
        incrementImageCount()
        
        self.addElementToImageArray(image: newRealmFormattedImageData)
    }
    
    func addOneOrMultipleHashtagToImages(indexpaths: [IndexPath], newHashtagName: String){
        for item  in indexpaths {

            let image = self.getImageArray()[item.row]
            //let image = self.getImageArraySoryByDate()[item.section][item.item]
            
            image.addOneHashtagToRealm(newHashtagName: newHashtagName)

        }

    }
    
    func deleteImageFromFileDirectory(deletedImages: List<Image>){
        
        let fileManager = FileManager.default
        for i in deletedImages{
            let imagePathString = i.getImagePath() as String
            do{
                try fileManager.removeItem(atPath: imagePathString)
                
            }catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
    }
    
    func deleteImageFromFileDirectory(deletedImages: [Image]){
        
        let fileManager = FileManager.default
        for i in deletedImages{
            let imagePathString = i.getImagePath() as String
            do{
                try fileManager.removeItem(atPath: imagePathString)
                
            }catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
    }
    
    
    func deletImages(indexpaths: [IndexPath]){
        var deletedImages:[Image] = []
        
        for item  in indexpaths {
            
            
            //let selectedImage = self.getImageArraySoryByDate()[item.section][item.item]
            
            let selectedImage = self.getImageArray()[item.row]
            deletedImages.append(selectedImage)
            decrementImageCount()
        }

        self.deleteImageFromFileDirectory(deletedImages: deletedImages)
        
        
        
        
        guard let database = try? Realm() else { return }
        do {
            try database.write {
                database.delete(deletedImages, cascading: true)
            }
        } catch {
            // handle write error here
        }
        

        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", self.categoryName )
        

        let tempFolders = tempFolderType[0].getFolders().filter("name = %@", self.getName() )
        
        self.clearImageArray()
        for i in tempFolders[0].getImages(){
            self.addElementToImageArray(image: i)
        }
//        self.getImageArraySoryByDate()
    }
    
    private func writeImageToDirectoryAndGetFilePath(image: UIImage)->String{
        let data = NSData(data: UIImageJPEGRepresentation(image, 0.9)!)
        let randomNum = Int(arc4random_uniform(99999) + 1)
        
        let timestampFilename = String(Int(Date().timeIntervalSince1970)) + "\(randomNum).png"
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filenamePath = (documentsDirectory as NSString).appendingPathComponent(timestampFilename)
        
        //write failed... even you created a file path...
        let fileManager = FileManager.default
        fileManager.createFile(atPath: filenamePath, contents: data as Data, attributes: nil)
        
        return filenamePath
    }
    
}

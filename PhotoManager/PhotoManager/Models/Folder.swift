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
    
//    private let folders = LinkingObjects(fromType: Type.self, property: "folders")
//    var folder: Type {
//        return self.folders.first!
//    }
    //private var locations = List<Location>()
    private var images = List<Image>()
    private var imageArray:[Image] = [Image]()
    private var numOfImageSelection: Int = 0
    private var didAddAlready: Bool = false
    private var newImage: UIImage = UIImage()
    
    
    

    override class func primaryKey() -> String?{
        return "folderID"
    }
    
    convenience init(name: String, createdDate: Date, images: List<Image>, imageCount: Int, categoryName: String){
        self.init()
        self.name = name
        self.createdDate = createdDate
        self.images = images
        self.imageCount = imageCount
        self.categoryName = categoryName
    }

    func createRockeyMountainData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "rockyMountain1"), location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "rockyMountain2"), location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"))
    }
    
    func createGrouseMountainData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain1"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain2"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "grouseMountain3"), location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"))
    }
    
    func createOlympicData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "olympicsVancouver1"), location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"))
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "olympicsVancouver2"), location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"))
    }
    
    func createDefaultData(){
        self.addImageToRealm(newImage: #imageLiteral(resourceName: "testing"), location: Location())
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
    
    func addImageForTestingToRealm(){
        let realmImages = self.getImages()
        
        var images: List<Image>
        if realmImages.isEmpty{
            images = List<Image>()
        }else{
            images = List<Image>()
            for image in realmImages{
                images.append(image)
            }
        }
        
        let data = NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "testing"), 0.9)!)
        
        
        
        
        
        let timestampFilename = String(Int(Date().timeIntervalSince1970)) + "someName.png"
        
        //let filenamePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(timestampFilename)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filenamePath = (documentsDirectory as NSString).appendingPathComponent(timestampFilename)
        
        //write failed... even you created a file path...
        let fileManager = FileManager.default
        fileManager.createFile(atPath: filenamePath, contents: data as Data, attributes: nil)
        //let imgData = try! data.write(to: filenamePath!, options: [])
        print("writing........")
        print(filenamePath)
        print(fileManager)
        
        
        
        
        
        let hashTags = List<HashTag>()
        
        let hashTag1 = HashTag(hashTag: "#"+self.getName())
        let hashTag2 = HashTag(hashTag: "#"+self.categoryName)
        
        if self.getName() == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        
        // in simulator it goes so quickly no enough time to get valiue so nil
        /// in real device you need time to take a photo so 8000millisecond
        //it neeeds at least 1 second to get value
        // i could delay it se not good
        let newLocation = Location(latitude: 47, longtitude: -122, street: "", city: "", province: "")
        //if location != nil{
//            newLocation = Location(latitude: self.images.location.getLatitude(), longtitude: self.location.getLongtitude(), street: self.location.getStreet(), city: self.location.getCity(), province: self.location.getProvince())
        //}
        let newRealmFormattedDate = Image(dateCreated: Date(), imagePath: filenamePath as NSString, hashTags: hashTags, location: newLocation)
        //print(self.location)
        
        images.append(newRealmFormattedDate)
        
        RealmService.shared.update(self, with: ["name": self.getName(), "createdDate": self.getCreatedDate(), "imageCount": images.count, "images": images])
        
        
        self.imageArray.append(newRealmFormattedDate)
        //return newRealmFormattedDate
    }
    
    func addImageToRealm(newImage: UIImage, location: Location){
        
//        let realmImages = self.getImages()
//
//        var images: List<Image>
//        if realmImages.isEmpty{
//            images = List<Image>()
//        }else{
//            images = List<Image>()
//            for image in realmImages{
//                images.append(image)
//            }
//        }
//
        let data = NSData(data: UIImageJPEGRepresentation(newImage, 0.9)!)
        
        
        
        
        
        
        
        
        let timestampFilename = String(Int(Date().timeIntervalSince1970)) + "someName.png"
        
        //let filenamePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(timestampFilename)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filenamePath = (documentsDirectory as NSString).appendingPathComponent(timestampFilename)
        
        //write failed... even you created a file path...
        let fileManager = FileManager.default
        fileManager.createFile(atPath: filenamePath, contents: data as Data, attributes: nil)
        //let imgData = try! data.write(to: filenamePath!, options: [])
        print("writing........")
        print(filenamePath)
        print(fileManager)
        
        
        
        
        
        
        let hashTags = List<HashTag>()
        
        let folderTypeName = "#\(self.categoryName)"
        let folderName = "#\(self.name)"
        
        let hashTag1 = HashTag(hashTag: folderTypeName)
        let hashTag2 = HashTag(hashTag: folderName)
        
        if self.categoryName == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        var newLocation = Location(latitude: 47, longtitude: -122, street: "", city: "", province: "")
        //if location != nil{
        newLocation = Location(latitude: location.getLatitude(), longtitude: location.getLongtitude(), street: location.getStreet(), city: location.getCity(), province: location.getProvince())
        //}
        
        let newRealmFormattedImageData = Image(dateCreated: Date(), imagePath: filenamePath as NSString, hashTags: hashTags, location: newLocation)
        
         try! realm?.write {
            images.append(newRealmFormattedImageData)
        
        
        }
       // RealmService.shared.update(self, with: ["name": self.getName(), "createdDate": self.getCreatedDate(), "imageCount": images.count, "images": images])
        
        self.addElementToImageArray(image: newRealmFormattedImageData)
        //}
    }
    
    func addOneOrMultipleHashtagToImages(indexpaths: [IndexPath], newHashtagName: String){
        
        //if let indexpaths = indexpaths {
            for item  in indexpaths {
                //self.collectionView?.deselectItem(at: (item), animated: true)
                
                let image = self.getImageArray()[item.row]
                
                image.addOneHashtagToRealm(newHashtagName: newHashtagName)
                
              
                
            }
            
        //}
    }
    
    func deletImages(indexpaths: [IndexPath]){
                    var deletedImages:[Image] = []
        //if let indexpaths = indexpaths {
            for item  in indexpaths {
                //self.collectionView?.deselectItem(at: (item), animated: true)
                
                
                let selectedImage = self.getImageArray()[item.row]
                
                deletedImages.append(selectedImage)
                
            }
            
            
            guard let database = try? Realm() else { return }
            do {
                try database.write {
                    database.delete(deletedImages, cascading: true)
                }
            } catch {
                // handle write error here
            }
            
            //
            let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", self.categoryName )
            
            
            let tempFolders = tempFolderType[0].getFolders().filter("name = %@", self.getName() )
            
            self.clearImageArray()
            //self.images = [Image]()
            for i in tempFolders[0].getImages(){
                self.addElementToImageArray(image: i)
                //self.images.append(i)
            }
    }
        

}

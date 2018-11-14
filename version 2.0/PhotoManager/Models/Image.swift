//
//  Image.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
class Image: Object{
    @objc private dynamic var imageID: String = UUID().uuidString
    @objc private dynamic var categoryName: String = String()
    @objc private dynamic var subCategoryName: String = String()
    @objc private dynamic var dateCreated: Date = Date()
    @objc private dynamic var imagePath: NSString?
    @objc private dynamic var location: Location?
    private var hashTags = List<HashTag>()
    
    private var uploadedTime: Date = Date()

    override class func primaryKey() -> String?{
        return "imageID"
    }
    
    convenience init(categoryName: String, subCategoryName: String, dateCreated: Date ,imagePath: NSString, hashTags: List<HashTag>, location: Location){
        self.init()
        self.categoryName = categoryName
        self.subCategoryName = subCategoryName
        self.dateCreated = dateCreated
        self.imagePath = imagePath
        self.hashTags = hashTags
        self.location = location

    }

    
    convenience init(imageID: String, categoryName: String, subCategoryName: String, dateCreated: Date ,imagePath: String, hashTags: List<HashTag>, location: Location){
        self.init()
        self.categoryName = categoryName
        self.subCategoryName = subCategoryName
        self.imageID = imageID
        self.dateCreated = dateCreated
        self.imagePath = imagePath as NSString
        self.hashTags = hashTags
        self.location = location
        
    }
    
    public func setLocation(_ location: Location){
        self.location = location
    }
    
    
    public func setHashTags(_ hashtags: List<HashTag>){
        self.hashTags = hashtags
    }
    
    public func setDateCreated(_ dateCreated: Date){
        self.dateCreated = dateCreated
    }
    
    public func setImagePath(_ imagePath: NSString){
        try! self.realm?.write {
            
           self.imagePath = imagePath
        }
        
    }
    
    public func setUploadedTime(_ uploadedTime: Date){
        self.uploadedTime = uploadedTime
    }
    
    public func setSubCategoryName(_ name: String){
        self.subCategoryName = name
    }
    
    public func setCategoryName(_ name: String){
        self.categoryName = name
    }
    
    public func getLocation() -> Location{
        return self.location!
    }
    
    public func getImageID() -> String{
        return self.imageID
    }
    
    public func getHashTags() -> List<HashTag>{
        return self.hashTags
    }
    
    
    public func getDateCreated() -> Date{
        return self.dateCreated
    }
    
    public func getCategoryName() -> String{
        return self.categoryName
    }
    
    public func getSubcategoryName() -> String{
        return self.subCategoryName
    }
    
    public func getImageCreatedDateString() -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy MMM dd"
        let mydt = dateFormatter1.string(from: self.getDateCreated())
        
        return mydt
    }
    
   
    
    
    public func getImageCreatedTimeString() -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "hh:mm:ss a"
        let mydt = dateFormatter1.string(from: self.getDateCreated())
        
        return mydt
    }
    
    public func getHashtagsString() -> String{
        var hashTagsString = ""
        for i in self.getHashTags(){
            hashTagsString += i.getHashTag() + " "
        }
        return hashTagsString
    }
    
    
    
    public func getImageURL() -> URL{
        return URL(string: (self.getImagePath() as String?)!)!
    }
 
    
    public func getImagePath() -> NSString{
        return self.imagePath!
    }
    
    public func getHashTagDictionary() -> NSDictionary{
        var dict = [String: String]()
        for hashtag in self.hashTags {
            dict[hashtag.getHashTagID()] = hashtag.getHashTag()
        }
        
        return dict as NSDictionary
    }
    

    public func repeatedHashTagFound(_ typeText: String!) -> Bool{
            
        if let tempTypeName = typeText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in self.hashTags{
                if tempTypeName == i.getHashTag(){
                    return true
                }
                
            }
            
        }
        return false
        
    }
    
    public func anyProblemForHashtag(tempHashTags: [String])->String{
        //var hashtags: List<HashTag>
        //hashtags = List<HashTag>()
        var anyProblem: Bool = false
        var title = ""
        var numberOfDuplicated = 0
        for i in tempHashTags{
            let hashtag: HashTag = HashTag(hashTag: i)
            
            if (hashtag.isHashtagContainHashSymbol()){
                title = "Missing hashtag or space"
                anyProblem = true
            }
            
            if (hashtag.isHashtagEmpty()){
                title = "No empty hashtag(s)"
                anyProblem = true
            }
            
            
            if ( self.repeatedHashTagFound(hashtag.getHashTag())){
                numberOfDuplicated += 1
                title = "Hashtag already exists"
                if(numberOfDuplicated >  self.getHashTags().count){
                    anyProblem = true
                }
            }
        }
        
        if(anyProblem){
            return title
        }else{
            return ""
        }
        
    }
    

    public func addOneOrMultipleHashtagToRealm(tempHashTags: [String]){
        var hashtags: List<HashTag>
        hashtags = List<HashTag>()
        for i in tempHashTags{
            hashtags.append(HashTag(hashTag: i))
        }
        
        
        for i in  self.getHashTags(){
            RealmService.shared.delete(i)
        }
        
        RealmService.shared.update( self, with: ["dateCreated":  self.getDateCreated(), "imagePath": self.getImagePath(),"hashTags": hashtags])
        
    }
    
    
    //public func addHashtagToRealm
    
    public func addOneHashtagToRealm(newHashtagName: String){
        
        var hashtags: List<HashTag>
        hashtags = List<HashTag>()
        
        for i in self.getHashTags(){
            
            hashtags.append(HashTag(hashTag: i.getHashTag()))
        }
        
        hashtags.append(HashTag(hashTag: newHashtagName))
        
        for i in self.getHashTags(){
            RealmService.shared.delete(i)
        }
        
        
        RealmService.shared.update(self, with: ["dateCreated": self.getDateCreated(), "imagePath": self.getImagePath(),"hashTags": hashtags])
        
    }

    
    func loadImageFromPath() -> UIImage? {
        
        let image = UIImage(contentsOfFile: self.imagePath! as String)
        
        print("image path details......")
        print(self.imagePath)
        
        if image == nil {
            return UIImage()
        } else{
            return image
        }
    }
    
    
    func getImageBinaryData() -> NSData{
        return UIImageJPEGRepresentation(self.loadImageFromPath()!, 0.9)! as NSData
    }
    
    func getImageIndexFromArray(imageArray: [Image])->Int{
        var count = 0
        for i in imageArray{
            if i.getImageID() == self.getImageID(){
                return count
            }
            count = count + 1
        }
        return count
    }
    
    static func compressImage (_ image: UIImage, maxWidth: CGFloat, quality: CGFloat) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = maxWidth
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = quality
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    static public func getImageSizeInMB(image: UIImage) -> String{
        let imageSize = (NSData(data: UIImageJPEGRepresentation(image, 1)!).length)
        let imageSizeInByte = imageSize/1024
        let imageSizeInKB = imageSizeInByte/1024
        let formattedImageSize = String(format: "%.2f%MB", imageSizeInKB)
        
        return formattedImageSize
    }
    
    static public func setImageDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)->Date{
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        //dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents)!
    }
    
    public func getUploadedDateString() -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy MMM dd"
        let mydt = dateFormatter1.string(from: self.uploadedTime)
        
        return mydt
    }
    
    
    
    
    
    public func getUploadedTimeString() -> String{
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "hh:mm:ss a"
        let mydt = dateFormatter1.string(from: self.uploadedTime)
        
        return mydt
    }
}


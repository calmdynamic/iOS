//
//  Image.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseAuth
import FirebaseDatabase

class Image: Object{
    @objc private dynamic var imageID: String = UUID().uuidString
    @objc private dynamic var dateCreated: Date = Date()
    @objc private dynamic var imagePath: NSString?
    @objc private dynamic var location: Location?
    private var hashTags = List<HashTag>()

    override class func primaryKey() -> String?{
        return "imageID"
    }
    
    convenience init(dateCreated: Date ,imagePath: NSString, hashTags: List<HashTag>, location: Location){
        self.init()
        self.dateCreated = dateCreated
        self.imagePath = imagePath
        self.hashTags = hashTags
        self.location = location

    }
    
    convenience init(dateCreated: Date ,image: UIImage, hashTags: List<HashTag>, location: Location){
        self.init()
        self.dateCreated = dateCreated
        self.setImagePath(image)
        self.hashTags = hashTags
        self.location = location
        
    }
    
    convenience init(imageID: String, dateCreated: Date ,image: UIImage, hashTags: List<HashTag>, location: Location){
        self.init()
        self.imageID = imageID
        self.dateCreated = dateCreated
        self.setImagePath(image)
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
        self.imagePath = imagePath
    }
    
    public func setImagePath(_ image: UIImage){
        
        let data: Data? = UIImagePNGRepresentation(image)
        self.imagePath =  data?.base64EncodedString(options: .endLineWithLineFeed) as! NSString
        //self.imageBinaryData = NSData(data: UIImageJPEGRepresentation(image, 0.9)!)
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
    
    public func getImagePath() -> NSString{
        return self.imagePath!
    }
    
//    public func getUIImage() -> UIImage{
//    let data = Data(base64Encoded: self.imagePath, options: .ignoreUnknownCharacters)
//            return UIImage(data: data)
//        //return  UIImage(data: (self.imageBinaryData)! as Data, scale:1.0)!
//    }
//    
//    public func getHashTags() -> LinkingObjects<HashTag>{
//        return self.hashTags
//    }
    public func getHashTagDictionary() -> NSDictionary{
        var dict = [String: String]()
        for hashtag in self.hashTags {
            dict[hashtag.getHashTagID()] = hashtag.getHashTag()
        }
        
        return dict as NSDictionary
    }
    
//    public func addArrayToHashtag(tempHashTags: [String]){
//        for i in tempHashTags{
//            self.hashTags.append(HashTag(hashTag: i))
//        }
//    }
    
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
                title = "One or more of your hashtag is missing # that is or are separated by a space"
                anyProblem = true
            }
            
            if (hashtag.isHashtagEmpty()){
                title = "No empty hashtags"
                anyProblem = true
            }
            
            
            if ( self.repeatedHashTagFound(hashtag.getHashTag())){
                numberOfDuplicated += 1
                title = "The hash tag is already in the image; please do not duplicate any hashtags"
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
    
    public func uploadImageToFirebase(url: String?){
        let ref = Database.database().reference()
        //ref.child("user").setValue(selectedImage.getImageID())
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self.getDateCreated())
        let month = calendar.component(.month, from: self.getDateCreated())
        let day = calendar.component(.day, from: self.getDateCreated())
        let hour = calendar.component(.hour, from: self.getDateCreated())
        let minute = calendar.component(.minute, from: self.getDateCreated())
        let second = calendar.component(.second, from: self.getDateCreated())
        
        print("email")
        
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        
        ref.child(userEmail).child(self.getImageID()).setValue(
            [
                "imageID"      : self.getImageID(),
                "dateCreated"    :
                    ["year": year,
                     "month": month,
                     "day": day,
                     "hour": hour,
                     "minute": minute,
                     "second": second] as Any,
                
                "location"     :
                    ["locationID":self.getLocation().getLocationID(),
                     "latitude":self.getLocation().getLatitude(),
                     "longtitude":self.getLocation().getLongtitude(),
                     "street":self.getLocation().getStreet(),
                     "city":self.getLocation().getCity(),
                     "province":self.getLocation().getProvince()
                        ] as Any,
                "Hashtag"       : self.getHashTagDictionary(),
                "imageURL" : url!
            ])
    }

    
    func loadImageFromPath() -> UIImage? {
        
        let image = UIImage(contentsOfFile: self.imagePath! as String)
        
        if image == nil {
            return UIImage()
        } else{
            return image
        }
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
    
//    func loadImageFromName(_ imgName: String) -> UIImage? {
//
//        guard  imgName.characters.count > 0 else {
//            print("ERROR: No image name")
//            return UIImage()
//        }
//
//        let imgPath = getDocumentsDirectory().appendingPathComponent(imgName)
//        let image = loadImageFromPath(imgPath as NSString)
//        return image
//    }
//    func getDocumentsDirectory() -> NSString {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        //print("Path: \(documentsDirectory)")
//        return documentsDirectory as NSString
//    }
   
    
}


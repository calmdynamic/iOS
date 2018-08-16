//
//  UtilityService.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-06.
//  Copyright © 2018 Jason Lai. All rights reserved.
//
import UIKit
import Foundation
import RealmSwift
import CoreLocation
class UtilityService{
    private init(){}
    static let shared = UtilityService()
    func showAlert(title: String, message: String, buttonTitle: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    func repeatedFolderFound(_ existedfolders: List<Folder>, _ folderText: String!) -> Bool{
        
        if let tempFolderName = folderText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in existedfolders{
                if tempFolderName == i.getName(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func repeatedFolderFound(_ existedfolders: [Folder], _ folderText: String!) -> Bool{
        
        if let tempFolderName = folderText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in existedfolders{
                if tempFolderName == i.getName(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func repeatedTypeFound(_ existedTypes: Results<Type>, _ typeText: String!) -> Bool{
        
        if let tempTypeName = typeText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in existedTypes{
                if tempTypeName == i.getName(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func repeatedTypeFound(_ existedTypes: [Type], _ typeText: String!) -> Bool{
        
        if let tempTypeName = typeText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in existedTypes{
                if tempTypeName == i.getName(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func repeatedHashTagFound(_ existedHashtag: List<HashTag>, _ typeText: String!) -> Bool{
        
        if let tempTypeName = typeText?.trimmingCharacters(in: .whitespaces){
            //var found = false
            for i in existedHashtag{
                if tempTypeName == i.getHashTag(){
                    return true
                }
                
            }
            
        }
        return false
    }
    
    func isTextEmpty(_ textString: String?) -> Bool{
        if let tempString = textString?.trimmingCharacters(in: .whitespaces) {
            if tempString.trimmingCharacters(in: .whitespaces).isEmpty{
                return true
            }
            
        }
        
        return false
    }
    
    
    func dummyData(){
        var hashTags: List<HashTag>
        hashTags = List<HashTag>()
        
        
        hashTags.append(HashTag(hashTag: "#GrouseMountains"))
        
        hashTags.append(HashTag(hashTag: "#Mountains"))
        
        

        let images1 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "grouseMountain1"), 0.9)!), hashTags: hashTags, location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"))
        let images2 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "grouseMountain2"), 0.9)!), hashTags: hashTags, location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"))
        let images3 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "grouseMountain3"), 0.9)!), hashTags: hashTags, location: Location(latitude: 49.3723, longtitude: -123.0995, street: "6400 Nancy Greene Way", city: "North Vancouver", province: "BC"))

        
        
        let imageCollection = List<Image>()
        imageCollection.append(images1)
        imageCollection.append(images2)
        imageCollection.append(images3)
        

        var folders: List<Folder>
        folders = List<Folder>()
        
        let fruiteFolder1 = Folder(name: "GrouseMountains", createdDate: Date(), images: imageCollection, imageCount: imageCollection.count)

        
        
        
        
        
        
        
        
        var rockyMountainhashTags: List<HashTag>
        rockyMountainhashTags = List<HashTag>()
        
        
        rockyMountainhashTags.append(HashTag(hashTag: "#RockyMountains"))
        
        rockyMountainhashTags.append(HashTag(hashTag: "#Mountains"))
        
        
    
        
        let rockyMountainImages1 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "rockyMountain1"), 0.9)!), hashTags: rockyMountainhashTags, location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"))
        let rockyMountainImages2 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "rockyMountain2"), 0.9)!), hashTags: rockyMountainhashTags, location: Location(latitude: 44.2643, longtitude: -109.7870, street: "491 Arrow Rd", city: "Invermere", province: "BC"))

        
        
        
        let rockyImageCollection = List<Image>()
        rockyImageCollection.append(rockyMountainImages1)
        rockyImageCollection.append(rockyMountainImages2)


        let rockyFolder1 = Folder(name: "RockyMountains", createdDate: Date(), images: rockyImageCollection, imageCount: rockyImageCollection.count)
        
        
        
        
        
        
        var mountainFolders: List<Folder>
        mountainFolders = List<Folder>()
        
        mountainFolders.append(fruiteFolder1)
        mountainFolders.append(rockyFolder1)
     
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var olympichashTags: List<HashTag>
        olympichashTags = List<HashTag>()
        
        
        olympichashTags.append(HashTag(hashTag: "#Olympics"))
        
        olympichashTags.append(HashTag(hashTag: "#Sports"))
        
        
        
        
        let olympicImages1 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "olympicsVancouver1"), 0.9)!), hashTags: olympichashTags, location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"))
        let olympicImages2 = Image(dateCreated: Date(), imageBinaryData: NSData(data: UIImageJPEGRepresentation(#imageLiteral(resourceName: "olympicsVancouver2"), 0.9)!), hashTags: olympichashTags, location: Location(latitude: 49.2768, longtitude: -123.1120, street: "777 Pacific Blvd", city: "Vancouver", province: "BC"))
        
        
        
        
        let olympicImageCollection = List<Image>()
        olympicImageCollection.append(olympicImages1)
        olympicImageCollection.append(olympicImages2)
        
        
        let olympicFolder1 = Folder(name: "Olympics", createdDate: Date(), images: olympicImageCollection, imageCount: olympicImageCollection.count)
        
        
        
        
        
        
        var sportFolders: List<Folder>
        sportFolders = List<Folder>()
        
        sportFolders.append(olympicFolder1)
        

        
        let animalType =  Type(name: "Mountains", folders: mountainFolders, folderCount: mountainFolders.count)
        let sportType = Type(name: "Sports", folders: sportFolders, folderCount: sportFolders.count)
        let homeType = Type(name: "Home", folders: folders, folderCount: 0)
        let schoolType = Type(name: "School", folders: folders, folderCount: 0)
        let movieType = Type(name: "Movie", folders: folders, folderCount: 0)
        let mathType = Type(name: "Math", folders: folders, folderCount: 0)
        let biologyType = Type(name: "Biologys", folders: folders, folderCount: 0)
        
        let chemistryType = Type(name: "Chemistry", folders: folders, folderCount: 0)
        let physicsType = Type(name: "Physics", folders: folders, folderCount: 0)
        let fruitType = Type(name: "Fruit", folders: folders, folderCount: 0)
        let plantType = Type(name: "Plant", folders: folders, folderCount: 0)
        let planetType = Type(name: "Planet", folders: folders, folderCount: 0)
        let gameType = Type(name: "Game", folders: folders, folderCount: 0)
        let languageType = Type(name: "Languages", folders: folders, folderCount: 0)
        let algorithmType = Type(name: "Algorithm", folders: folders, folderCount: 0)
        let foodType = Type(name: "Food", folders: folders, folderCount: 0)
        let philosophyType = Type(name: "Philosophy", folders: folders, folderCount: 0)
        let historyType = Type(name: "History", folders: folders, folderCount: 0)
        let travelType = Type(name: "Travel", folders: folders, folderCount: 0)
        
        RealmService.shared.create(animalType)
        RealmService.shared.create(sportType)
        RealmService.shared.create(homeType)
        RealmService.shared.create(schoolType)
        RealmService.shared.create(movieType)
        RealmService.shared.create(biologyType)
        
        RealmService.shared.create(mathType)
        RealmService.shared.create(chemistryType)
        RealmService.shared.create(physicsType)
        RealmService.shared.create(fruitType)
        RealmService.shared.create(plantType)
        RealmService.shared.create(planetType)
        
        RealmService.shared.create(gameType)
        RealmService.shared.create(languageType)
        RealmService.shared.create(algorithmType)
        RealmService.shared.create(foodType)
        RealmService.shared.create(philosophyType)
        RealmService.shared.create(historyType)
        
        
        RealmService.shared.create(travelType)

        
    }
    
    func defaultData(){
        let imageCollection = List<Image>()
        let defaultFolder = Folder(name: "Default", createdDate: Date(), images: imageCollection, imageCount: imageCollection.count)
        var defaultFolders: List<Folder>
        defaultFolders = List<Folder>()
        defaultFolders.append(defaultFolder)
        let defaultType =  Type(name: "Default", folders: defaultFolders, folderCount: defaultFolders.count)
        RealmService.shared.create(defaultType)
        
    }
    
    func locationChecker(locationMgr: CLLocationManager, viewController: UIViewController){
        let status = CLLocationManager.authorizationStatus()
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if Reachability.isConnectedToNetwork(){
            if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
                locationMgr.requestWhenInUseAuthorization()
            } else {
                locationMgr.startUpdatingLocation()
            }
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            viewController.present(alert, animated: true, completion: nil)
            //return
        }
    }
    
    func cameraChecker(pickerController: UIImagePickerController, viewController: UIViewController) -> Bool{
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
        else{
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            viewController.present(pickerController, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func addImageForTestingToRealm(selectedFolder: Folder, selectedFolderTypeName: String, location: Location)->Image{
        let realmImages = selectedFolder.getImages()
        
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
        
        let hashTags = List<HashTag>()
        
        let hashTag1 = HashTag(hashTag: "#"+selectedFolder.getName())
        let hashTag2 = HashTag(hashTag: "#"+selectedFolderTypeName)
        
        if selectedFolder.getName() == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        
        // in simulator it goes so quickly no enough time to get valiue so nil
        /// in real device you need time to take a photo so 8000millisecond
        //it neeeds at least 1 second to get value
        // i could delay it se not good
        var newLocation = Location(latitude: 47, longtitude: -122, street: "", city: "", province: "")
        if location != nil{
            newLocation = Location(latitude: location.getLatitude(), longtitude: location.getLongtitude(), street: location.getStreet(), city: location.getCity(), province: location.getProvince())
        }
        let newRealmFormattedDate = Image(dateCreated: Date(), imageBinaryData: data, hashTags: hashTags, location: newLocation)
        //print(self.location)
        
        images.append(newRealmFormattedDate)
        
        RealmService.shared.update(selectedFolder, with: ["name": selectedFolder.getName(), "createdDate": selectedFolder.getCreatedDate(), "imageCount": images.count, "images": images])
        
        return newRealmFormattedDate
    }
    
    func addImageToDatabase(selectedFolder: Folder, selectedFolderType: String, newImage: UIImage, location: Location)->Image{
        
        
        let realmImages = selectedFolder.getImages()
        
        var images: List<Image>
        if realmImages.isEmpty{
            images = List<Image>()
        }else{
            images = List<Image>()
            for image in realmImages{
                images.append(image)
            }
        }
        
        let data = NSData(data: UIImageJPEGRepresentation(newImage, 0.9)!)
        
        let hashTags = List<HashTag>()
        
        let folderTypeName = "#\(selectedFolderType)"
        let folderName = "#\(selectedFolder.getName())"
        
        let hashTag1 = HashTag(hashTag: folderTypeName)
        let hashTag2 = HashTag(hashTag: folderName)
        
        if selectedFolderType == "Default"{
            hashTags.append(hashTag1)
        }else{
            hashTags.append(hashTag1)
            hashTags.append(hashTag2)
        }
        var newLocation = Location(latitude: 47, longtitude: -122, street: "", city: "", province: "")
        if location != nil{
            newLocation = Location(latitude: location.getLatitude(), longtitude: location.getLongtitude(), street: location.getStreet(), city: location.getCity(), province: location.getProvince())
        }
        
        let newRealmFormattedDate = Image(dateCreated: Date(), imageBinaryData: data, hashTags: hashTags, location: newLocation)
        
        images.append(newRealmFormattedDate)
        
        RealmService.shared.update(selectedFolder, with: ["name": selectedFolder.getName(), "createdDate": selectedFolder.getCreatedDate(), "imageCount": images.count, "images": images])
        
        return newRealmFormattedDate
        
    }

    
    func getAddressFromLatLon(location: Location, pdblLatitude: Double, withLongitude pdblLongitude: Double){

        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:pdblLatitude, longitude: pdblLongitude)
 

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if placemarks != nil{
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    location.setLatitude(loc.coordinate.latitude)
                    location.setLongtitude(loc.coordinate.longitude)
                    
                    let street = pm.thoroughfare ?? "Seymour St"
                    let city = pm.locality ?? "Vancouver"
                    let province = pm.administrativeArea ?? "BC"
                    location.setCity(city)
                    location.setStreet(street)
                    location.setProvince(province)
                    
                    
                }
                }
        })
        
        
    }
    
    func getLocationDetailedInfo(locationMgr: CLLocationManager, location: Location){
        var currentLocation: CLLocation!
        //locationMgr.startUpdatingLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationMgr.location
            
        }
        
        print(currentLocation)
        
        print(currentLocation.coordinate.latitude)
        print(currentLocation.coordinate.longitude)
        
        location.setLatitude(currentLocation.coordinate.latitude)
        location.setLongtitude(currentLocation.coordinate.longitude)

        
        if Reachability.isConnectedToNetwork(){
            UtilityService.shared.getAddressFromLatLon(location: location, pdblLatitude: currentLocation.coordinate.latitude, withLongitude: currentLocation.coordinate.longitude)
        }
    }
    
  
    
}

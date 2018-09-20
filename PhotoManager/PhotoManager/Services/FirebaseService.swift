//
//  FirebaseService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-17.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import FirebaseAuth

class FirebaseService{
    public static func getLocationDataFromFirebase(_ userLocation : NSDictionary) -> Location{
        let locationlongtitude = userLocation["longtitude"] as? Double
        let locationlatitude = userLocation["latitude"] as? Double
        let locationStreet = userLocation["street"] as? String
        let locationCity = userLocation["city"] as? String
        let locationProvince = userLocation["province"] as? String
        
        return Location(latitude: locationlatitude!, longtitude: locationlongtitude!, street: locationStreet!, city: locationCity!, province: locationProvince!)
    }
    
    public static func getDateFromFirebase(_ userDate : NSDictionary) -> Date{
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = userDate["year"] as? Int
        dateComponents.month = userDate["month"] as? Int
        dateComponents.day = userDate["day"] as? Int
        dateComponents.hour = userDate["hour"] as? Int
        dateComponents.minute = userDate["minute"] as? Int
        dateComponents.second = userDate["second"] as? Int
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents)!
    }
    
    public static func getHashTagDataFromFirebase(_ userHashtag : [String: String]) -> List<HashTag> {
        var hashtags: List<HashTag>
        hashtags = List<HashTag>()
        
        for k in userHashtag{
            hashtags.append(HashTag(hashTag: k.value))
        }
        
        return hashtags
    }
    
    
    public static func deleteFirebaseImage(controller: UIViewController, tableView: UITableView,indexPath: IndexPath, imageArray: ImageArray, noDataAvailableLabel: UILabel){
        
        let image = (imageArray.getImageFromArray(index: indexPath.item))
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child(userEmail).child(image.getImageID()).setValue(nil){
            error,_  in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        Storage.storage().reference().child(image.getImageID()+".png").delete { error in
            if error != nil{
                AlertDialog.showAlertMessage(controller: controller, title: "Message", message: "Deleted Unsuccessfully", btnTitle: "Ok")
                
            }else{
                AlertDialog.showAlertMessage(controller: controller, title: "Message", message: "Deleted Successfully", btnTitle: "Ok")
            }
        }
        imageArray.removeOneElementFromImageArray(index: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        print("counting...")
        print(indexPath.count)
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            noDataAvailableLabel.isHidden = false
        }
    }
}

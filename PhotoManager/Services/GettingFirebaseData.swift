//
//  GettingFirebaseData.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-21.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift

class GettingFirebaseData{
    public static func getLocationDataFromFirebase(_ userLocation : NSDictionary) -> Location{
        let locationlongtitude = userLocation["longtitude"] as? Double
        let locationlatitude = userLocation["latitude"] as? Double
        let locationStreet = userLocation["street"] as? String
        let locationCity = userLocation["city"] as? String
        let locationProvince = userLocation["province"] as? String
        
        return Location(latitude: locationlatitude!, longtitude: locationlongtitude!, street: locationStreet!, city: locationCity!, province: locationProvince!)
    }
    
    public static func getImageCreatedDateFromFirebase(_ userDate : NSDictionary) -> Date{
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
    
}

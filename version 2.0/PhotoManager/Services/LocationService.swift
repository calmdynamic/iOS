//
//  LocationService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-08.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationService{
    public static func getLocationDate(locationMgr: CLLocationManager, locations: [CLLocation], selectedFolder: Folder, uiImage: UIImage,completion: @escaping (Location) -> Void){
        locationMgr.stopUpdatingLocation()
        
        var location : Location = Location()

        if let locations = locations.last{
            print("geting location")
            let loc: CLLocation = CLLocation(latitude:locations.coordinate.latitude, longitude: locations.coordinate.longitude)
            
            
            location = Location(latitude: loc.coordinate.latitude, longtitude: loc.coordinate.longitude, street: "", city: "", province: "")
            
            completion(location)
            
        }
    
    }

    
    public static func initLocationMgr(controller: UIViewController,locationMgr: CLLocationManager){
        locationMgr.delegate = controller as? CLLocationManagerDelegate
        // Ask for Authorisation from the User.
        locationMgr.requestAlwaysAuthorization()
        // For use in foreground
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    
}

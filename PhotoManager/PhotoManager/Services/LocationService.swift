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
    public static func getLocationDate(locationMgr: CLLocationManager, locations: [CLLocation], selectedFolder: Folder,completion: @escaping (Location) -> Void){
        locationMgr.stopUpdatingLocation()
        //self.location = Location()
        var location : Location = Location()
        if let locations = locations.last{
            print("geting location")
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude:locations.coordinate.latitude, longitude: locations.coordinate.longitude)
            
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
                            location = Location(latitude: loc.coordinate.latitude, longtitude: loc.coordinate.longitude, street: pm.thoroughfare!, city: pm.locality!, province: pm.administrativeArea!)
                            
                            completion(location)
                            
//                            if !selectedFolder.getDidAddAlready(){
//                                selectedFolder.addImageToRealm(newImage: selectedFolder.getNewImage(), location: location)
//                                collectionView.reloadData()
//                                selectedFolder.setDidAddAlready(didAddAlready: true)
//                            }
                            
                        }
                    }
            })
            
            
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

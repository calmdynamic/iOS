//
//  Location.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
class Location: Object{
    @objc private dynamic var locationID: String = UUID().uuidString
    @objc private dynamic var latitude: Double = 0
    @objc private dynamic var longtitude: Double = 0
    @objc private dynamic var street: String = ""
    @objc private dynamic var city: String = ""
    @objc private dynamic var province: String = ""

    
    
    override class func primaryKey() -> String?{
        return "locationID"
    }
    
    convenience init(latitude: Double, longtitude: Double, street: String, city: String, province: String){
        self.init()
        self.latitude = latitude
        self.longtitude = longtitude
        self.street = street
        self.city = city
        self.province = province

        
    }
    
    
    public func setLongtitude(_ longtitude: Double){
        self.longtitude = longtitude
    }
    
    public func setLatitude(_ latitude: Double){
        self.latitude = latitude
    }
    
    public func setStreet(_ street: String){
        self.street = street
    }
    
    public func setCity(_ city: String){
        self.city = city
    }
    
    public func setProvince(_ province: String){
        self.province = province
    }
    
    
    public func getLocationID() -> String{
        return self.locationID
    }
    
    
    public func getLatitude() -> Double{
        return self.latitude
    }
    
    public func getLongtitude() -> Double{
        return self.longtitude
    }
    
    
    public func getStreet() -> String{
        return self.street
    }
    
    public func getCity() -> String{
        return self.city
    }
    
    public func getProvince() -> String{
        return self.province
    }
    
    public func getAddressString() -> String{
        return self.getStreet() != "" ? self.getStreet() + " " + self.getCity() + " " + self.getProvince() : "Address is unavailable"
    }
    
}

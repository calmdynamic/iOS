//
//  MapViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-19.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    //var images: Results<Image>!
    
    var locationManager = CLLocationManager()
    var locations: Results<Location>!
    override func viewWillAppear(_ animated: Bool) {
        
        for i in mapView.annotations{
            mapView.removeAnnotation(i)
        }
        
        let BClocation = CLLocation(latitude: Double(49.246292), longitude: Double(-123.116226))
                                    
        centerMapOnLocation(location: BClocation)
        updateMapKit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.showsUserLocation = true
        
       
    }
    
    
    //MARK:- CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access your current location")
    }
    

    @IBAction func tapCurrentLocation(_ sender: UIBarButtonItem) {
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        } else {
            print("PLease turn on location services or GPS")
        }
    }
    
    
    let regionRadius: CLLocationDistance = 40000
    
    
    func updateMapKit(){
        locations = RealmService.shared.realm.objects(Location.self)

        var locationSet: Set = Set<String>()
        for i in locations{

            locationSet.insert(String(i.getLatitude()) + " " + String(i.getLongtitude()))
        }
        

        for i in locationSet{
            let array = i.split(separator: " ")
            
            let location = CLLocation(latitude: Double(round(Double(array[0])!*1000)/1000), longitude: Double(round(Double(array[1])!*1000)/1000))
            
          
        
        let count = locationCount(location: location)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location.coordinate
        
        
        annotation.title = "\(count) photos taken"
        mapView.addAnnotation(annotation)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func locationCount(location: CLLocation)->Int{
        locations = RealmService.shared.realm.objects(Location.self)
        var count = 0
        for i in locations {
            if String(format: "%.3f", location.coordinate.latitude) == String(format: "%.3f", i.getLatitude()) && String(format: "%.3f", location.coordinate.longitude) == String(format: "%.3f", i.getLongtitude()){
                count+=1
            }
        }
        
        
        return count
    }
    
}

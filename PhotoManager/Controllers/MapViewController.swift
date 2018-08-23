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
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var images: Results<Image>!
    var locations: Results<Location>!
    override func viewWillAppear(_ animated: Bool) {
        
        for i in mapView.annotations{
            mapView.removeAnnotation(i)
        }
        
        updateMapKit()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    let regionRadius: CLLocationDistance = 100000
    
    
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

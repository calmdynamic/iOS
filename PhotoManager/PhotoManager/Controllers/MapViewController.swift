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
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var routeDistance: UILabel!
    @IBOutlet weak var distanceBtn: UIBarButtonItem!
    
    @IBOutlet weak var waitingView: UIView!
    
    @IBOutlet weak var showRefreshBtn: UIBarButtonItem!
    var selectedAnnotation: MKPointAnnotation?
//    var lastRegion: MKCoordinateRegion = MKCoordinateRegion()
    var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
    var locationSet: Set = Set<String>()
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!

    var locationManager = CLLocationManager()
    var locations: Results<Location>!
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.deselectAnnotation(selectedAnnotation, animated: true)
        
        self.searchBtn.isEnabled = false

        self.tabBarController?.tabBar.isHidden = false
        self.distanceBtn.isEnabled = false

    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.showsUserLocation = true
        mapView.userLocation.title = "My Location"
        self.mapView.delegate = self
        
        let BClocation = CLLocation(latitude: Double(49.246292), longitude: Double(-123.116226))
        
        centerMapOnLocation(location: BClocation)
        
        self.showOrRefreshBtn(self.showRefreshBtn)
//        updateMapKit()
    }
    
    
    
    @IBAction func showOrRefreshBtn(_ sender: UIBarButtonItem) {
  

        let group = DispatchGroup()
        group.enter()
        self.mapView.isUserInteractionEnabled = false
        self.waitingView.isHidden = false
        
        self.waitingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        
        self.showRefreshBtn.isEnabled = false
        
        DispatchQueue.main.async {
           
            group.leave()
        }
        
        
        group.notify(queue: .main) {
            group.enter()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.updateMapKit()

            
            
            
            
           
            group.leave()
            
            
            group.notify(queue: .main){
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
                    // Your code with delay
                    self.showRefreshBtn.isEnabled = true
                    self.waitingView.isHidden = true
                    self.mapView.isUserInteractionEnabled = true
                     self.waitingView.backgroundColor = UIColor.black.withAlphaComponent(1)
                }
               
                
            }
        }
        
        
        
        
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
        
        


        let cordLocation = RealmService.shared.realm.objects(Location.self)


                for i in cordLocation{
                    self.locationSet.insert(String(i.getLatitude()) + " " + String(i.getLongtitude()))
                }


        for i in locationSet{
            let array = i.split(separator: " ")
            
            let location = CLLocation(latitude: Double(round(Double(array[0])!*1000)/1000), longitude: Double(round(Double(array[1])!*1000)/1000))
            
          
        
        let count = locationCount(location: location)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location.coordinate
        
        
        annotation.title = "\(count) photos taken"
            if count != 0{
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func locationCount(location: CLLocation)->Int{
//
//        var count = 0
//        let loc = RealmService.shared.realm.objects(Location.self)
//        let locRef = ThreadSafeReference(to: loc)
//        print("222")
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let realm = try! Realm()
//                guard let location2 = realm.resolve(locRef) else {
//                    return // person was deleted
//                }
//
//                count = 0
//                for i in location2 {
//                    if String(format: "%.3f", location.coordinate.latitude) == String(format: "%.3f", i.getLatitude()) && String(format: "%.3f", location.coordinate.longitude) == String(format: "%.3f", i.getLongtitude()){
//                        count+=1
//                    }
//                }
//            }
//        }
        


        locations = RealmService.shared.realm.objects(Location.self)
        var count = 0
        for i in locations {
            if String(format: "%.3f", location.coordinate.latitude) == String(format: "%.3f", i.getLatitude()) && String(format: "%.3f", location.coordinate.longitude) == String(format: "%.3f", i.getLongtitude()){
                count+=1
            }
        }

        
        return count
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
        self.searchBtn.isEnabled = true
        self.distanceBtn.isEnabled = true
        if view.annotation?.title == "My Location" || view.annotation?.title == "0 photos taken"{
            self.searchBtn.isEnabled = false
            self.distanceBtn.isEnabled = false
        }
       
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 4.0
        
        return renderer
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.searchBtn.isEnabled = false
        self.distanceBtn.isEnabled = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == "mapImageSearch"{
            let imageSearchVC = segue.destination as! ImageSearchViewController

            imageSearchVC.selectedMapCordination = selectedAnnotation!
            imageSearchVC.zeroDataMessage = "No Data Found; You may deleted images so please to click refresh button to show the newest status in previous page."
            
        }
        
    }

    @IBAction func showDistance(_ sender: UIBarButtonItem) {
        self.mapView.removeOverlays(mapView.overlays)
       
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: self.mapView.userLocation.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: (selectedAnnotation?.coordinate)!, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .any
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {

                    AlertDialog.showAlertMessage(controller: self, title: "", message: error.localizedDescription, btnTitle: "Ok")
                    
                }
                
                return
            }
            
            
            
            let route = response.routes[0]
            
            
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
            
            
            self.routeDistance.text = String(format: "%.1fkm", route.distance.magnitude/1000)
            
        }
    }
}

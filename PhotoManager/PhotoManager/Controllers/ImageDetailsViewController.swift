//
//  ImageDetailsViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-09.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import MapKit

class ImageDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var image: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        navigationItem.title = self.image.getImageID()
       
        let image = UIImage(data: (self.image.getImageBinaryData()) as Data, scale:1.0)
        
        selectedImage.image = image

    }
    @IBAction func propertyView(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 360)
        let customView = UIView(frame: rect)
        
        
         let rectForTitle = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 20)
        
        let titleLabel = UILabel(frame: rectForTitle)
        
        
        titleLabel.text = "Information Property"
        titleLabel.textAlignment = .center
        
        customView.addSubview(titleLabel)
        
        let rectForMapKit = CGRect(x: margin, y: margin + 30, width: alertController.view.bounds.size.width - margin * 6.0, height: 220)
        
        let mapView = MKMapView(frame: rectForMapKit)
        let regionRadius: CLLocationDistance = 1000

        let initialLocation = CLLocation(latitude: image.getLocation().getLatitude(), longitude: image.getLocation().getLongtitude())
        
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
        let annotation = MKPointAnnotation()  // <-- new instance here
        annotation.coordinate = initialLocation.coordinate
        annotation.title = "Spot"
        mapView.addAnnotation(annotation)
        
        
        let customMapView = mapView

        customView.addSubview(customMapView)
       
         let rectAddressLabel = CGRect(x: margin, y: 265, width: alertController.view.bounds.size.width - margin * 6.0, height: 15)
        let addressLabel = UILabel(frame: rectAddressLabel)
        
        
        
        
        addressLabel.text = self.image.getLocation().getStreet() != "" ? self.image.getLocation().getStreet() + " " + self.image.getLocation().getCity() + " " + self.image.getLocation().getProvince() : "Address is unavailable"
        
        
        addressLabel.textAlignment = NSTextAlignment.center
        customView.addSubview(addressLabel)
        
        let rectLabel = CGRect(x: margin, y: 285, width: alertController.view.bounds.size.width - margin * 6.0, height: 15)
        let createdDateLabel = UILabel(frame: rectLabel)
        
        createdDateLabel.textAlignment = NSTextAlignment.center
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy MMM dd";
        let mydt = dateFormatter1.string(from: self.image.getDateCreated())
        
        
        createdDateLabel.text = "Date Created: " + mydt
        customView.addSubview(createdDateLabel)
        
         let rectTagLabel = CGRect(x: margin, y: 300, width: alertController.view.bounds.size.width - margin * 6.0, height: 50)
        
        
    
        let tagsLabel = UITextView(frame: rectTagLabel)
        var hashTagsString = ""
        
        for i in self.image.getHashTags(){
            hashTagsString += i.getHashTag() + " "
        }
        
        
        tagsLabel.text = "Hashtags: " + hashTagsString
        
        tagsLabel.isEditable = false
        tagsLabel.isScrollEnabled = true
       
        
        
         customView.addSubview(tagsLabel)
        alertController.view.addSubview(customView)
        
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
    
}

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.selectedImage
    }

}

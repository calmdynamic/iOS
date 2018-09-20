//
//  InformationPropertyView.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-11.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import MapKit
class InformationPropertyView: UIViewController{
    static let IDENTIFIER = "InfoPropertyViewID"
    
    var controller: UIViewController = UIViewController()
    
    
    @IBOutlet weak var typeName: UILabel!
    
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var imageTitle: UILabel!
    
    @IBOutlet weak var imageTimeCreated: UILabel!
    
    
    @IBOutlet weak var mapDataUnavailable: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var imageDateCreated: UILabel!
    @IBOutlet weak var hashTextView: UITextView!
    @IBOutlet weak var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        animateView()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        
    }
    
    func setupView() {
        let myColor = UIColor.gray
        self.imageDateCreated.layer.borderColor = myColor.cgColor
        self.address.layer.borderColor = myColor.cgColor
        
        self.imageDateCreated.layer.borderWidth = 1.0
        self.imageTimeCreated.layer.borderWidth = 1.0
        self.typeName.layer.borderWidth = 1.0
        self.folderName.layer.borderWidth = 1.0
        self.address.layer.borderWidth = 1.0
        
        self.imageDateCreated.layer.cornerRadius = 10
        self.imageTimeCreated.layer.cornerRadius = 10
        self.typeName.layer.cornerRadius = 10
        self.folderName.layer.cornerRadius = 10
        self.address.layer.cornerRadius = 10
        self.hashTextView.layer.cornerRadius = 10
        mainView.layer.cornerRadius = 15
        subView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        mainView.alpha = 0;
        self.mainView.frame.origin.y = self.mainView.frame.origin.y + 50
        
        subView.alpha = 0;
        //self.subView.frame.origin.y = self.mainView.frame.origin.y + 0
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.mainView.alpha = 1.0;
            self.mainView.frame.origin.y = self.mainView.frame.origin.y - 50
            self.subView.alpha = 1.0;
            //self.subView.frame.origin.y = self.mainView.frame.origin.y - 100
        })
    }
    
    func initalizeImageInfoData(image: Image, imageTitle: String){
        self.initailizeAddress(image: image)
        self.initializeHashtag(image: image)
        self.initializeDateCreated(image: image)
        self.initializeTimeCreated(image: image)
        self.initailizeMapView(image: image)
        self.initailizeImageTitle(imageTitle: imageTitle)
        self.initailizeImageTypeName(image: image)
        self.initailizeImageFolderName(image: image)
    }
    
    private func initailizeImageFolderName(image: Image){
        self.folderName.text = "Folder Name: " + image.getSubcategoryName()
    }
    
    private func initailizeImageTypeName(image: Image){
        self.typeName.text = "Type Name: " + image.getCategoryName()
    }
    
    private func initailizeImageTitle(imageTitle: String){
        self.imageTitle.text = imageTitle
    }
    
    private func initializeHashtag(image: Image){
        self.hashTextView.text = "Hashtags: " + image.getHashtagsString()
        self.hashTextView.isEditable = false
        self.hashTextView.isScrollEnabled = true
    }
    
    private func initializeDateCreated(image: Image){
        self.imageDateCreated.textAlignment = NSTextAlignment.center
        self.imageDateCreated.text = "Date Created: " + image.getImageCreatedDateString()
    }
    
    private func initializeTimeCreated(image: Image){
        self.imageTimeCreated.textAlignment = NSTextAlignment.center
        self.imageTimeCreated.text = "Time Created: " + image.getImageCreatedTimeString()
    }
    
    
    private func initailizeAddress(image: Image){
        
        address.text = image.getLocation().getAddressString()
        address.textAlignment = NSTextAlignment.center
    }
    
    private func initailizeMapView(image: Image){
        
        
        if address.text != "Address is unavailable"{
            let regionRadius: CLLocationDistance = 30000
            
            let initialLocation = CLLocation(latitude: image.getLocation().getLatitude(), longitude: image.getLocation().getLongtitude())
            
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            
            let annotation = MKPointAnnotation()  // <-- new instance here
            annotation.coordinate = initialLocation.coordinate
            annotation.title = "Spot"
            mapView.addAnnotation(annotation)
            
        }else{
            self.mapView.removeFromSuperview()
            self.mapDataUnavailable.isHidden = false
        }
    }
    func initailizedView(controller: UIViewController){
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //self.customAlert.delegate = self
        controller.tabBarController?.tabBar.isHidden = true
        self.controller = controller
        controller.present(self, animated: true, completion: nil)
    }
    
    @IBAction func okBtn(_ sender: Any) {
        self.controller.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true) 
    }
    
}

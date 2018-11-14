//
//  ImageDetailsViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-09.
//  Updated by Jason Chih-Yuan on 2018-09-15.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import MapKit

class ImageDetailsViewController: UIViewController {
    

    @IBOutlet weak var mainView: UIView!
    fileprivate var pageViewController:UIPageViewController!
    var dataSource = ImagePageView()
    var currentIndex = 0
    var uploadingAlertView = UploadingOneImageView()
    
    var selectedFolder: Folder!
    var currentImage: Image!
    var infoPropertyView = InformationPropertyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = self.currentImage.getImageIndexFromArray(imageArray: selectedFolder.getImageArray())
        navigationItem.title = "Image #\(currentIndex+1)"
        self.setupDataSource(imageArray: selectedFolder.getImageArray())
        createPageViewController()

    }
    @IBAction func propertyView(_ sender: UIBarButtonItem) {

        self.infoPropertyView = self.storyboard?.instantiateViewController(withIdentifier: InformationPropertyView.IDENTIFIER) as! InformationPropertyView
        self.infoPropertyView.initailizedView(controller: self)
        
        self.infoPropertyView.initalizeImageInfoData(image: selectedFolder.getImageArray()[currentIndex], imageTitle: "Image #\(currentIndex+1)")
    }
    
    
    @IBAction func shareImageButton(_ sender: Any) {
        AlertDialog.showSharingAlertMessage(title: "Share this image", btnTitle1: "Share this iamge", handler1: { (_) in
            
            SharingService.shareImageWithFriends(controller: self, currentIndex: self.currentIndex, selectedFolder: self.selectedFolder)
          
            
        }, btnTitle2: "Upload this image", handler2: { (_) in
            
            self.uploadingAlertView = self.storyboard?.instantiateViewController(withIdentifier: UploadingOneImageView.IDENTIFIER) as! UploadingOneImageView
            
            UploadingService.uploadImageToFirebase(controller: self, currentIndex: self.currentIndex, uploadingAlertView: self.uploadingAlertView, selectedFolder: self.selectedFolder)
            
            
        }, cancelBtnTitle: "Cancel", controller: self)
    }
    
    fileprivate func setupDataSource(imageArray: [Image]) {
        dataSource.setupImageArray(imageArray: imageArray)
    }
    
    func createPageViewController(){
        if selectedFolder.getImageArray().count > 0{

        
        if let startingViewController = dataSource.getItemController(currentIndex) {
            
            pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: [UIPageViewControllerOptionInterPageSpacingKey : 20])
            
            if let pageViewController = pageViewController {
                pageViewController.dataSource = dataSource
                pageViewController.delegate = self
                pageViewController.setViewControllers([startingViewController],
                                                      direction: .forward,
                                                      animated: false,
                                                      completion: {done in})
                pageViewController.view.frame = self.view.frame
                addChildViewController(pageViewController)
                self.view.addSubview(pageViewController.view)
            }
        }
        }
        
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return selectedFolder.getImageArray().count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
    
}
//MARK:-UIPageViewControllerDelegate
extension ImageDetailsViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if let vc = pageViewController.viewControllers?.first as? ImageSliderView {
            print(vc.itemIndex)
            self.navigationItem.title = "Image #\(vc.itemIndex+1)"
            self.currentIndex = vc.itemIndex
        }
        
    }
}

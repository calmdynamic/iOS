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
import SDWebImage

class ImageDetailsViewController: UIViewController {
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var mainView: UIView!
    fileprivate var pageViewController:UIPageViewController!
    var dataSource = ImagePageView()
    var currentIndex = 0

    var selectedFolder: Folder!
    var currentImage: Image!
    var infoPropertyView = InformationPropertyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.saveBtn.isEnabled != true{ self.navigationItem.setRightBarButton(nil, animated: false)
        }
        print("detailsss....")
        
        self.tabBarController?.tabBar.isHidden = true
        currentIndex = self.currentImage.getImageIndexFromArray(imageArray: selectedFolder.getImageArray())
        navigationItem.title = "Image #\(currentIndex+1)"
        self.setupDataSource(imageArray: selectedFolder.getImageArray())
        createPageViewController()

    }
    @IBAction func propertyView(_ sender: UIBarButtonItem) {

        
        
        self.infoPropertyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: InformationPropertyView.IDENTIFIER) as! InformationPropertyView
       
        self.infoPropertyView.controller = self
        self.infoPropertyView.image = self.selectedFolder.getImageArray()[self.currentIndex]
        
        self.infoPropertyView.initailizedView()
        

        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
    @IBAction func shareImageButton(_ sender: Any) {
        

        SharingService.shareImageWithFriends(controller: self, currentIndex: self.currentIndex, selectedFolder: self.selectedFolder)
        
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        var newSelectedFolder:Folder = Folder()
        
        let selectedFolderName = UserDefaultService.getUserDefaultFolderName2()
        let selectedFolderTypeName = UserDefaultService.getUserDefaultFolderTypeName2()
        
        let selectedFolderType: Type = Type()
        selectedFolderType.getFolderDataFromRealm(typeName: selectedFolderTypeName)
        
        for i in selectedFolderType.getFolderArray(){
            if i.getName() == selectedFolderName{
                newSelectedFolder = i
            }
        }
        
        let imageViewUI: UIImageView = UIImageView()
        
        
        
        imageViewUI.sd_setImage(with: URL(string: self.selectedFolder.getImageArray()[self.currentIndex].getImagePath() as! String), placeholderImage: #imageLiteral(resourceName: "Placeholder")) { (image, error, cacheType, url) in
            
            
            
            let uiImage = imageViewUI.image!
            
            newSelectedFolder.addImageToRealm(newImage: uiImage, location: self.selectedFolder.getImageArray()[self.currentIndex].getLocation(), date: self.selectedFolder.getImageArray()[self.currentIndex].getDateCreated())
            
            AlertDialog.showAlertMessage(controller: self, title: "", message: "Saved Successfully", btnTitle: "Ok")
            
        }
        
        
       
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

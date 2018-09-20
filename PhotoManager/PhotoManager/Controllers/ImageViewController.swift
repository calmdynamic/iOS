//
//  ImageViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-13.
//  Updated by Jason Chih-Yuan on 2018-09-09.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import CoreLocation
import PinterestLayout
import SDWebImage

class ImageViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    static let NUM_OF_LIMIT_WORD_CHARACTER = 15
    var i:Int = 0
    var uploadingAlertView = UploadingOneImageView()
    let locationMgr = CLLocationManager()
    let pickerController = UIImagePickerController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var hashTagBtn: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    //@IBOutlet weak var uploadBtn: UIBarButtonItem!
    @IBOutlet weak var downloadBtn: UIButton!

    var selectedFolder: Folder!
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    //MARK: private
    
    private func setupCollectionViewInsets() {
        collectionView!.backgroundColor = .clear
        collectionView!.contentInset = UIEdgeInsets(
            top: 15,
            left: 5,
            bottom: 49,
            right: 5
        )
    }
    
    private func setupLayout() {
        let layout: PinterestLayout = {
            if let layout = collectionView.collectionViewLayout as? PinterestLayout {
                return layout
            }
            let layout = PinterestLayout()
            
            collectionView?.collectionViewLayout = layout
            
            return layout
        }()
        layout.delegate = self as PinterestLayoutDelegate
        layout.cellPadding = 5
        layout.numberOfColumns = 4
    }
    
    
    
    
    //a function will be performed after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        
        isEditing = false
        self.selectedFolder.setImageArray(imageArray: Array(self.selectedFolder.getImages()))
        //self.selectedFolder.getImageArraySoryByDate()
        CollectionViewService.initCollectionViewWhenWillAppear(tabBar: (self.tabBarController?.tabBar)!, toolbar: toolbar, collectionView: collectionView)
    }

    //a function will be performed when it is first launched
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewInsets()
        setupLayout()
        
        
        NavigationService.initNavigationItem(title: selectedFolder.getName(), navigationItem: navigationItem, editButtonItem: editButtonItem)
        CameraService.initCameraPicker(controller: self, pickerController: pickerController)
        LocationService.initLocationMgr(controller: self, locationMgr: locationMgr)
        CollectionViewService.initCollectionView(collectionView: self.collectionView, collectionDataSource: self, collectionDelegate: self)
    }
    
    //a function to be performed when a user click an image or download button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        TransitionToOtherViewService.imageViewTransition(selectedFolder: self.selectedFolder, segue: segue, collectionView: self.collectionView)
    }
    
    //a function to check if it can go to the next folder and to be performed before prepare()
    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
    //a function to be performed when a user clicks edit button
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        TabBarService.tabBarChangeWhenSetEditing(tabBarController: self.tabBarController!, editing: editing)
        ToolBarService.toolbarItemChangeWhenSetEditing(toolbar: toolbar, hashTagBtn: hashTagBtn, deleteButton: deleteButton, downloadBtn: downloadBtn, cameraBtn: cameraBtn, navigationItem: navigationItem, editing: editing)
        CollectionViewService.collectionViewChnageWhenSetEditing(collectionView: self.collectionView, editing: editing)
    }
    
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            //After it is complete
        }
    }
    
    
    //a function to be called when the user clicks the camera button
    @IBAction func addPhoto(_ sender: UIButton) {
        CameraService.addPhotoWhenClickingCameraBtn(selectedFolder: selectedFolder, controller: self, collectionView: self.collectionView, pickerController: pickerController)
    }
    
    //a function to be called when it recieved locationMgr.startUpdating()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CameraService.addImageToRealmWhenOnDeviceWithNetworking(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder, collectionView: collectionView)
    }
    
    //a function to be called when the user clicks the done button on camera screen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        CameraService.takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: self.selectedFolder, locationMgr: self.locationMgr, picker: picker, didFinishPickingMediaWithInfo: info, collectionView: self.collectionView)
        
    }

    
    //a function to be performed when a user clicks the cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("The camera has been closed")
    }
    
    
    //a function to be performed when a user clicks the deletion button to delete images
    @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
       CollectionViewService.deleteImageFromRealm(selectedFolder: self.selectedFolder, controller: self, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, textFieldDelegate: self)
        
      
    }
    
    //a function to be performed when a user clicks the hash button and will do the related operations.
    @IBAction func addHashtag(_ sender: UIBarButtonItem) {
       CollectionViewService.addHashtagOperation(controller: self, collectionView: self.collectionView, selectedFolder: self.selectedFolder, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, textFieldDelegate: self)
        
    }
    
//    //a function to be performed when a user clicks the uploading button
//    @IBAction func uploadImage(_ sender: UIBarButtonItem) {
//
//        self.uploadingAlertView = self.storyboard?.instantiateViewController(withIdentifier: UploadingOneImageView.IDENTIFIER) as! UploadingOneImageView
//        UploadingService.uploadingImagesToRealm(controller: self, collectionView: self.collectionView, uploadingAlertView: self.uploadingAlertView, selectedFolder: self.selectedFolder, deleteButton: self.deleteButton, hashTagBtn: self.hashTagBtn, uploadBtn: self.uploadBtn)
//
//    }
    
    //a function to limit number of character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard let text = textField.text else {return true}
        let newLength = text.count + string.count - range.length
        return newLength <= ImageViewController.NUM_OF_LIMIT_WORD_CHARACTER
    }
    
  
    
    
}

extension ImageViewController: UICollectionViewDataSource{
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.selectedFolder.getImageArraySoryByDate().count
//    }
    
    //a function to set number of cell to be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return self.selectedFolder.getImageArraySoryByDate()[section].count
        return self.selectedFolder.getImageArray().count
    }
    
    //a function to set cell property when user see the view and scroll the view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.IDENTIFIER, for: indexPath) as! ImageCollectionViewCell
        
        
        
        //let filenameString: NSString = self.selectedFolder.getImageArray() [indexPath.item].getImagePath()
        
        //let _: NSString = self.selectedFolder.getImageArraySoryByDate()[indexPath.section] [indexPath.item].getImagePath()
        
        
        let image = self.selectedFolder.getImageArray()[indexPath.item].loadImageFromPath()
        //let image = self.selectedFolder.getImageArraySoryByDate()[indexPath.section][indexPath.item].loadImageFromPath()
        
        
        cell.photoImage.image = Image.compressImage(image!)

        cell.cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: isEditing)
        
        
        
        
        
        return cell
    }
    
    
    
}

extension ImageViewController: UICollectionViewDelegate{
    
    //a function to be performed when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder:self.selectedFolder, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, cameraBtn: self.cameraBtn, downloadBtn: self.downloadBtn)
    }
    
    //a function to be performed when a cell is deselected
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder:self.selectedFolder, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, cameraBtn: self.cameraBtn, downloadBtn: self.downloadBtn)
        
    }
    
}

//MARK: PinterestLayoutDelegate

extension ImageViewController: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        //let filenameString: NSString = self.selectedFolder.getImageArray() [indexPath.item].getImagePath()
        //let image = self.loadImageFromName(filenameString as String)
        
        //let cell = self.indexPathsForVisibleItems
        
        //let image = self.selectedFolder.getImageArraySoryByDate()[indexPath.section][indexPath.item].loadImageFromPath()
        let image = self.selectedFolder.getImageArray()[indexPath.item].loadImageFromPath()
        
        //let image = self.loadImageFromPath(filenameString)
        
        //let image = self.selectedFolder.getImageArray()[indexPath.item].getUIImage()
        
        return image!.height(forWidth: withWidth)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 0
    }
}

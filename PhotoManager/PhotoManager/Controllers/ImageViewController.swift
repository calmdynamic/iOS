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
    var uploadingAlertView = UploadingAlertView()
    let locationMgr = CLLocationManager()
    let pickerController = UIImagePickerController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var hashTagBtn: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var uploadBtn: UIBarButtonItem!
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
        layout.numberOfColumns = 3
    }
    
    
    
    
    //a function will be performed after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        isEditing = false
        self.selectedFolder.setImageArray(imageArray: Array(self.selectedFolder.getImages()))
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
        ToolBarService.toolbarItemChangeWhenSetEditing(toolbar: toolbar, uploadBtn: uploadBtn, hashTagBtn: hashTagBtn, deleteButton: deleteButton, downloadBtn: downloadBtn, cameraBtn: cameraBtn, navigationItem: navigationItem, editing: editing)
        CollectionViewService.collectionViewChnageWhenSetEditing(collectionView: self.collectionView, editing: editing)
    }
    
    //a function to be called when the user clicks the camera button
    @IBAction func addPhoto(_ sender: UIButton) {
        CollectionViewService.addPhotoWhenClickingCameraBtn(selectedFolder: selectedFolder, controller: self, collectionView: self.collectionView, pickerController: pickerController)
    }
    
    //a function to be called when it recieved locationMgr.startUpdating()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CollectionViewService.addImageToRealmWhenOnDeviceWithNetworking(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder, collectionView: collectionView)
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
       CollectionViewService.deleteImageFromRealm(selectedFolder: self.selectedFolder, controller: self, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, uploadBtn: self.uploadBtn, deleteButton: self.deleteButton, textFieldDelegate: self)
        
      
    }
    
    //a function to be performed when a user clicks the hash button and will do the related operations.
    @IBAction func addHashtag(_ sender: UIBarButtonItem) {
       CollectionViewService.addHashtagOperation(controller: self, collectionView: self.collectionView, selectedFolder: self.selectedFolder, hashTagBtn: self.hashTagBtn, uploadBtn: self.uploadBtn, deleteButton: self.deleteButton, textFieldDelegate: self)
        
    }
    
    //a function to be performed when a user clicks the uploading button
    @IBAction func uploadImage(_ sender: UIBarButtonItem) {
        
        self.uploadingAlertView = self.storyboard?.instantiateViewController(withIdentifier: UploadingAlertView.IDENTIFIER) as! UploadingAlertView
        CollectionViewService.uploadingImagesToRealm(controller: self, collectionView: self.collectionView, uploadingAlertView: self.uploadingAlertView, selectedFolder: self.selectedFolder, deleteButton: self.deleteButton, hashTagBtn: self.hashTagBtn, uploadBtn: self.uploadBtn)

    }
    
    //a function to limit number of character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard let text = textField.text else {return true}
        let newLength = text.count + string.count - range.length
        return newLength <= ImageViewController.NUM_OF_LIMIT_WORD_CHARACTER
    }
    
  
    
    func compressImage (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 120
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
}

extension ImageViewController: UICollectionViewDataSource{
    
    //a function to set number of cell to be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.selectedFolder.getImageArray().count
    }
    
    //a function to set cell property when user see the view and scroll the view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.IDENTIFIER, for: indexPath) as! ImageCollectionViewCell
        
        let filenameString: NSString = self.selectedFolder.getImageArray() [indexPath.item].getImagePath()
//        //let image = self.loadImageFromName(filenameString as String)
        let image = self.selectedFolder.getImageArray()[indexPath.item].loadImageFromPath()
        
//        let image = UIImage(data: (self.selectedFolder.getImageArray() [indexPath.item].getImagePath()) as String, scale:1.0)
//
//        let image = UIImage(data: (self.selectedFolder.getImageArray() [indexPath.item].getImageBinaryData()) as Data, scale:1.0)

        
        
       
//
        //cell.photoImage.sd_setShowActivityIndicatorView(true)

        //cell.photoImage.sd_setIndicatorStyle(.gray)

//        i = i + 1
        // Create a URL in the /tmp directory
        let imageURL = NSURL(fileURLWithPath: filenameString as String)
//
//        // save image to URL
//        do {
//            try UIImagePNGRepresentation(image!)?.write(to: imageURL)
//        } catch { }

        //cell.photoImage.sizeThatFits(1)

        //cell.photoImage.sd_setImage(with: imageURL as URL, placeholderImage: #imageLiteral(resourceName: "lion") , options: [.progressiveDownload])
        
         //cell.photoImage.image = self.compressImage(image!)
        
//        cell.photoImage.sd_setImage(with: imageURL as URL, placeholderImage: #imageLiteral(resourceName: "lion"), options: [.queryDiskSync], progress: nil
//            , completed: { (image, error, cacheType, url) in
//
                cell.photoImage.image = self.compressImage(image!)
                
//            })
        
//
//        cell.photoImage.sd_setImageWithURL(
//            imageURL as URL,
//            placeholderImage: UIImage.init(named: "default-profile-icon"),
//            options: [.progressiveDownload],
//            progress: nil,
//            completed: { (image: UIImage?, error: NSError?, cacheType: SDImageCacheType!, imageURL: NSURL?) in
//
//                guard let image = image else { return }
//                print("Image arrived!")
//                cell.profileImageView.image = resizeImage(image, newWidth: 200)
//        }
//        )
        
        cell.cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: isEditing)
        
        return cell
    }
    
    
    
}

extension ImageViewController: UICollectionViewDelegate{
    
    //a function to be performed when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder:self.selectedFolder, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, uploadBtn: self.uploadBtn, deleteButton: self.deleteButton, cameraBtn: self.cameraBtn, downloadBtn: self.downloadBtn)
    }
    
    //a function to be performed when a cell is deselected
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder:self.selectedFolder, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, uploadBtn: self.uploadBtn, deleteButton: self.deleteButton, cameraBtn: self.cameraBtn, downloadBtn: self.downloadBtn)
        
    }
    
}

//MARK: PinterestLayoutDelegate

extension ImageViewController: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        //let filenameString: NSString = self.selectedFolder.getImageArray() [indexPath.item].getImagePath()
        //let image = self.loadImageFromName(filenameString as String)
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

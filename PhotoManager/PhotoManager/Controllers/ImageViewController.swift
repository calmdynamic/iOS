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
//import SDWebImage

class ImageViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    static let NUM_OF_LIMIT_WORD_CHARACTER = 15
    //var i:Int = 0
//    var uploadingAlertView = UploadingOneImageView()
    let locationMgr = CLLocationManager()
    let pickerController = UIImagePickerController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var importBtn: UIBarButtonItem!
    @IBOutlet weak var moveBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var hashTagBtn: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
//    @IBOutlet weak var downloadBtn: UIButton!

    var isSameLocation: Bool = false
    var selectedFolder: Folder!
    var imageArray: [Image]! = [Image]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //a function will be performed after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        if isSameLocation{
         AlertDialog.showAlertMessage(controller: self, title: "Error", message: "You can't move a folder to the same folder", btnTitle: "Ok")
            isSameLocation = false
        }
        isEditing = false
        
        self.selectedFolder.setImageArray(imageArray: Array(self.selectedFolder.getImages()))
        //self.selectedFolder.getImageArraySoryByDate()
        CollectionViewService.initCollectionViewWhenWillAppear(tabBar: (self.tabBarController?.tabBar)!, toolbar: toolbar, collectionView: collectionView)
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //a function will be performed when it is first launched
    override func viewDidLoad() {
        super.viewDidLoad()

        CollectionViewService.setupCollectionViewInsets(collectionView: self.collectionView)
        CollectionViewService.setupLayout(collectionView: self.collectionView, controller: self, cellPadding: 5, numberOfColumns: 3)

        
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
        ToolBarService.toolbarItemChangeWhenSetEditing(toolbar: toolbar, hashTagBtn: hashTagBtn, deleteButton: deleteButton, cameraBtn: cameraBtn, importBtn: importBtn, moveBtn: moveBtn, navigationItem: navigationItem, editing: editing)
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
    
    @IBAction func moveImageToOtherFolder(_ sender: UIBarButtonItem) {
        
        AlertDialog.showAlertMessage(controller: self, title: "Move the image(s)", message: "Are you sure you want to move the image(s) to another folder?", leftBtnTitle: "Cancel",rightBtnTitle: "Move", textFieldDelegate: self, completion: { (_) in

            
            //found all selection
            let indexpaths = self.collectionView.indexPathsForSelectedItems
            self.selectedFolder.clearMovedImageArray()
            if let indexpaths = indexpaths {
                for item  in indexpaths {
                    let selectedImage = self.selectedFolder.getImageArray()[item.row]
                    self.selectedFolder.addElementToMovedImageArray(image: selectedImage)
                    self.collectionView.deselectItem(at: (item), animated: true)
                    
                }
                
            }
            
              //show the folder type list and folder list
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationController = storyBoard.instantiateViewController(withIdentifier: "folderTypeListNav") as! UINavigationController
            
                    let folderTypeListView = storyBoard.instantiateViewController(withIdentifier: "folderTypeList") as! FolderTypeListViewController
            
            folderTypeListView.previousControllerName = "imageViewController"
                    navigationController.pushViewController(folderTypeListView, animated: true)
                    self.present(navigationController, animated: true, completion: nil)
            

        }, textFieldPlaceHolderTitle: "")

        
        //updated to the new folder
        
        //delete the current folder images
    }
    
    //a function to be called when the user clicks the camera button
    @IBAction func addPhoto(_ sender: UIButton) {
        CameraService.addPhotoWhenClickingCameraBtn(selectedFolder: selectedFolder, controller: self, collectionView: self.collectionView, pickerController: pickerController)
    }
    
    //a function to be called when it recieved locationMgr.startUpdating()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("current location\(locations)")
        
//           locationMgr.stopUpdatingLocation()
        CameraService.addImageToRealmWhenOnDeviceWithNetworking(locationMgr: self.locationMgr, locations: locations, selectedFolder: self.selectedFolder, collectionView: self.collectionView)
            

        
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
        CollectionViewService.deleteImageFromRealm(selectedFolder: self.selectedFolder, controller: self, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, importBtn: importBtn, moveBtn: moveBtn, textFieldDelegate: self)
        
      
    }
    
    //a function to be performed when a user clicks the hash button and will do the related operations.
    @IBAction func addHashtag(_ sender: UIBarButtonItem) {
        CollectionViewService.addHashtagOperation(controller: self, collectionView: self.collectionView, selectedFolder: self.selectedFolder, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, importBtn: importBtn, moveBtn: moveBtn, textFieldDelegate: self)
        
    }
    

    //a function to limit number of character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard let text = textField.text else {return true}
        let newLength = text.count + string.count - range.length
        return newLength <= ImageViewController.NUM_OF_LIMIT_WORD_CHARACTER
    }
    
    //avoid setting controller's set location's folder list done button call unwinding folder
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let folderList = fromViewController as? FolderListViewController
        if folderList?.previousControllerName == "imageViewController"{
            return true
        }
        return false
    }
    
    @IBAction func didUnwindFromFolderList(segue: UIStoryboardSegue){
        let folderList = segue.source as! FolderListViewController
        print("1")
        if folderList.previousControllerName == "imageViewController"{
            print("imageView")
        let selectedFolderType = folderList.selectedFolderType.getName()
        let selectedFolder = folderList.selectedFolder.getName()
        
        
        if self.selectedFolder.getName() != selectedFolder{
            
        isSameLocation = false

        // add to the selected folder
        let folderType = Type()
        folderType.getFolderDataFromRealm(typeName: selectedFolderType)
        let folders = folderType.getFolderArray()
        var folderSaveLocation = Folder()
        for i in folders{
            if i.getName() == selectedFolder{
                folderSaveLocation = i
            }
        }
        
        for i in self.selectedFolder.getMovedImageArray(){
            folderSaveLocation.addImageToRealm(newImage: i)
        }
        
        //delete to current folder
        self.selectedFolder.deletImagesWithoutDeletingDirectoryImages(deletedImages: self.selectedFolder.getMovedImageArray())
            
        }else{
            isSameLocation = true
        }
        }
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

        let image = self.selectedFolder.getImageArray()[indexPath.item].loadImageFromPath()
        

        cell.photoImage.image = Image.compressImage(image!, maxWidth: 120, quality: 0.5)

        cell.cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: isEditing)

        return cell
    }
    
    
    
}

extension ImageViewController: UICollectionViewDelegate{
    
    //a function to be performed when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder:self.selectedFolder, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, cameraBtn: self.cameraBtn, importBtn: importBtn, moveBtn: moveBtn)
    }

    //a function to be performed when a cell is deselected
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(selectedFolder:self.selectedFolder, collectionView: self.collectionView, hashTagBtn: self.hashTagBtn, deleteButton: self.deleteButton, cameraBtn: self.cameraBtn, importBtn: importBtn, moveBtn: moveBtn)

    }

}

//MARK: PinterestLayoutDelegate

extension ImageViewController: PinterestLayoutDelegate {

    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let image = self.selectedFolder.getImageArray()[indexPath.item].loadImageFromPath()
        return image!.height(forWidth: withWidth)
    }

    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 0
    }
}



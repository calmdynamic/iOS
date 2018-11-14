//
//  DownloadTableViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-17.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import FirebaseAuth
import SDWebImage

class DownloadListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    
    @IBOutlet weak var segmentedBtn: UISegmentedControl!
    
    var folderTypeListView = FolderTypeListViewController()
    var selectedFolderTypeName: String!
    var selectedFolder: Folder!
    var imagesArray: ImageArray!
    
    var newFolderType: String! = ""
    var newFolder:  String! = ""
    
    
    
    let ref = Database.database().reference()
    
    override func viewWillAppear(_ animated: Bool) {
        imagesArray = ImageArray()
        
        DownloadService.fetechSpecificData(imagesArray: self.imagesArray, activityIndicator: self.activityIndicator, tableView: self.tableView, noDataAvailableLabel: self.noDataAvailableLabel, newFolderType: self.newFolderType, newFolder: self.newFolder, controller: self)
        self.tabBarController?.tabBar.isHidden = true
        self.segmentedBtn.selectedSegmentIndex = 1
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if self.selectedFolder == nil{
            let selectedFolderType = Type()
            selectedFolderType.getFolderDataFromRealm(typeName: UserDefaultService.getUserDefaultFolderTypeName2())
            self.selectedFolder = Folder()
            let selectedFolderName = UserDefaultService.getUserDefaultFolderName2()
            for i in selectedFolderType.getFolderArray(){
                if i.getName() == selectedFolderName{
                    self.selectedFolder = i
                    break
                }
            }
        }
        self.newFolderType = self.selectedFolder.getCategoryName()
        self.newFolder = self.selectedFolder.getName()
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "downloadToFolderTypeList"{
            let destViewController = segue.destination as? UINavigationController
            let secondViewcontroller = destViewController?.viewControllers.first as! FolderTypeListViewController
            secondViewcontroller.previousControllerName = "downloadController"
        }
    }
    
    @IBAction func didUnwindFromFolderList(segue: UIStoryboardSegue){
        let folderList = segue.source as! FolderListViewController
        if folderList.previousControllerName == "downloadController"{
            print("download")
        newFolderType = folderList.selectedFolderType.getName()
        newFolder = folderList.selectedFolder.getName()
        }
        
    }
    
    
    @IBAction func segmentedControlBtn(_ sender: Any) {
        
        switch self.segmentedBtn.selectedSegmentIndex
        {
        case 0:
            print("0")
            self.imagesArray.setCurrentID(currentID: "")
            self.imagesArray.setCurrentKey(currentKey: "")
            self.imagesArray.emptyArray()
            DownloadService.fetechAllData(imagesArray: self.imagesArray, activityIndicator: self.activityIndicator, tableView: self.tableView, noDataAvailableLabel: self.noDataAvailableLabel, controller: self)
            self.filterBtn.isEnabled = false
            
        case 1:
            print("1")
            self.imagesArray.setCurrentID(currentID: "")
            self.imagesArray.setCurrentKey(currentKey: "")
            self.imagesArray.emptyArray()
            DownloadService.fetechSpecificData(imagesArray: self.imagesArray, activityIndicator: self.activityIndicator, tableView: self.tableView, noDataAvailableLabel: self.noDataAvailableLabel, newFolderType: self.newFolderType, newFolder: self.newFolder, controller: self)
            self.filterBtn.isEnabled = true
            
        default:
            break
        }
        
    }
    
    
}


extension DownloadListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.imagesArray.getTotalSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableViewCell.IDENTIFIER, for: indexPath) as! DownloadTableViewCell
        
        let image = self.imagesArray.getImageFromArray(index: indexPath.item)
        
        cell.imagePicture.sd_setImage(with: image.getImageURL(), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        
        cell.imagePicture.image = Image.compressImage(cell.imagePicture.image!, maxWidth: 120, quality: 0.5)
        
        cell.imageTitle.text = "{\(image.getCategoryName())} | [\(image.getSubcategoryName())]"
        
        cell.dateAndTime.text =
        "Created Time: \(image.getImageCreatedDateString()) \(image.getImageCreatedTimeString())"
        
        cell.locationText.text = image.getLocation().getAddressString()
        
        cell.uploadedTime.text =  "Uploaded Time: \(image.getUploadedDateString()) \(image.getUploadedTimeString())"
        
        
        return cell
    }
    
    
    
}
extension DownloadListViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("more button tapped")
            FirebaseService.deleteFirebaseImage(controller: self, tableView: self.tableView, indexPath: index, imageArray: self.imagesArray, noDataAvailableLabel: self.noDataAvailableLabel)
        }
        delete.backgroundColor = .red
        
        let save = UITableViewRowAction(style: .normal, title: "Save") { action, index in
            print("favorite button tapped")
            DownloadService.saveDownloadedImage(selectedFolder: self.selectedFolder, imageArray: self.imagesArray, tableView: self.tableView, controller: self, indexPath: index)
        }
        save.backgroundColor = .orange
        
        return [delete, save]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
        
        
        switch self.segmentedBtn.selectedSegmentIndex
        {
        case 0:
            DownloadService.fetechAllData(imagesArray: self.imagesArray, activityIndicator: self.activityIndicator, tableView: self.tableView, noDataAvailableLabel: self.noDataAvailableLabel, controller: self)
        case 1:
            DownloadService.fetechSpecificData(imagesArray: self.imagesArray, activityIndicator: self.activityIndicator, tableView: self.tableView, noDataAvailableLabel: self.noDataAvailableLabel, newFolderType: self.newFolderType, newFolder: self.newFolder, controller: self)
        default:
            break
        }
    }
    
    
    
}

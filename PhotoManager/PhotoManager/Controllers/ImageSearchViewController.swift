//
//  ImageSearchViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-15.
//  Updated by Jason Chih-Yuan on 2018-09-21.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import PinterestLayout
import MapKit

class ImageSearchViewController: UIViewController{

    
    @IBOutlet weak var selectionTextView: UITextView!
    
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    var zeroDataMessage = "Please select one or multiple search types"
    var newFolder: Folder = Folder()
    
    var selectedMapCordination: MKPointAnnotation = MKPointAnnotation()
    
    var selectedTexts: [String] = [String]()

    let segueIdentfier = "imageDetailSegue"
    @IBOutlet weak var collectionView: UICollectionView!
    let identifier = "imageCell"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isHidden = true
        self.searchBtn.isEnabled = true
        selectionTextView.layer.cornerRadius = 5
        selectionTextView.layer.borderColor = UIColor.black.cgColor
        selectionTextView.layer.borderWidth = 1
        
        let x = self.selectedMapCordination.coordinate.latitude
        let y = self.selectedMapCordination.coordinate.longitude
        if x.magnitude != 0.0 && y.magnitude != 0.0{

            
            self.searchBtn.isEnabled = false
            let newX = String(format: "%.3f", x)
            let newY = String(format: "%.3f", y)

            let cordinationString = "@latitude: \(newX), longitude: \(newY)"

            self.selectionTextView.text = cordinationString
            
            self.newFolder.clearImageArray()
            self.newFolder.getFolderDataFromRealm()
            self.newFolder.filterImage2(sortByCordination: cordinationString)
            self.collectionView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionViewService.setupCollectionViewInsets(collectionView: self.collectionView)
        CollectionViewService.setupLayout(collectionView: self.collectionView, controller: self, cellPadding: 5, numberOfColumns: 2)
        
        navigationItem.title = "Image Search"
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == segueIdentfier{
            let imageDetailVC = segue.destination as! ImageDetailsViewController
            let indexpaths = self.collectionView?.indexPathsForSelectedItems

            
            
            let selectedImage = self.newFolder.getImageArray()[indexpaths![0].item]

            imageDetailVC.currentImage = selectedImage
            imageDetailVC.selectedFolder = self.newFolder

        }
        
    }

    
    @IBAction func searchButton(_ sender: Any) {
        
        AlertDialog.showSortAlertMessage(title: "Search by:", btnTitle1: "Search by Hashtags", handler1: { (_) in
            
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "hashtagListNav") as! UINavigationController
            
            let hashtagListController = storyBoard.instantiateViewController(withIdentifier: "hashtagList") as! HashtagListViewController
            
            navigationController.pushViewController(hashtagListController, animated: true)
            self.present(navigationController, animated: true, completion: nil)
            
            
        }, btnTitle2: "Search by Date Taken", handler2: { (_) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "dateCreatedListNav") as! UINavigationController
            
            let dateCreatedListView = storyBoard.instantiateViewController(withIdentifier: "DateCreatedList") as! DateCreatedListViewController
            
            navigationController.pushViewController(dateCreatedListView, animated: true)
            self.present(navigationController, animated: true, completion: nil)
            
            
        }, btnTitle3: "", handler3: { (_) in
            
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let navigationController = storyBoard.instantiateViewController(withIdentifier: "locationListNav") as! UINavigationController
//
//            let locationListController = storyBoard.instantiateViewController(withIdentifier: "locationList") as! LocationListViewController
//
//            navigationController.pushViewController(locationListController, animated: true)
//            self.present(navigationController, animated: true, completion: nil)
            
        }, cancelBtnTitle: "Cancel", controller: self)
    }
    
    @IBAction func didUnwindFromHashTagList(segue: UIStoryboardSegue){
        let hashtagList = segue.source as! HashtagListViewController
        self.selectionTextView.text = "You selected: "
        self.newFolder.clearImageArray()
        self.newFolder.getFolderDataFromRealm()
        
        self.selectedTexts = hashtagList.selectedHashTag
        
        var hashtagString = ""
        for i in selectedTexts{
            hashtagString = hashtagString + "\(i) "
        }
        
        
        self.newFolder.filterImage(sortByHashtag: hashtagString)
        
        self.selectionTextView.text = self.selectionTextView.text + hashtagString
        
        
        self.collectionView?.reloadData()
        
    }
    
    
    @IBAction func didUnwindFromLocationList(segue: UIStoryboardSegue){
        let locationList = segue.source as! LocationListViewController
        self.selectionTextView.text = "You selected: "
        self.newFolder.clearImageArray()
        self.newFolder.getFolderDataFromRealm()
        
        self.selectedTexts = locationList.selectedLocation
        
        var locationString = ""
        for i in selectedTexts{
            locationString = locationString + "\(i) "
        }
        
        
        self.newFolder.filterImage(sortByLocation: locationString)

        self.selectionTextView.text = self.selectionTextView.text + locationString


        self.collectionView?.reloadData()

    }
    
    @IBAction func didUnwindFromDateCreatedList(segue: UIStoryboardSegue){
        let dateCreatedList = segue.source as! DateCreatedListViewController
        self.selectionTextView.text = "You selected: "
        self.newFolder.clearImageArray()
        self.newFolder.getFolderDataFromRealm()
        
        self.selectedTexts = dateCreatedList.selectedCreatedDate
        
        var dateCreatedString = ""
        for i in selectedTexts{
            dateCreatedString = dateCreatedString + "\(i) "
        }


        self.newFolder.filterImage(sortByDate: dateCreatedString)

        self.selectionTextView.text = self.selectionTextView.text + dateCreatedString


        self.collectionView?.reloadData()
        
    }
}

extension ImageSearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var hashtagString = ""
        for i in selectedTexts{
            hashtagString = hashtagString + "\(i) "
        }
        
        if (self.newFolder.getImageArray().count == 0) {
            
            if hashtagString != "" {
            self.collectionView.setEmptyMessage("No data found")
            }else{
                self.collectionView.setEmptyMessage(zeroDataMessage)
            }
        } else {
            self.collectionView.restore()
        }

        return self.newFolder.getImageArray().count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! ImageSearchCell
       
         let image = self.newFolder.getImageArray()[indexPath.item].loadImageFromPath()
        cell.photoImage.image = Image.compressImage(image!, maxWidth: 240, quality: 0.75)
        
        return cell
    }
}
extension ImageSearchViewController: UICollectionViewDelegate{
  
}

extension ImageSearchViewController: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let image = self.newFolder.getImageArray()[indexPath.item].loadImageFromPath()
        return image!.height(forWidth: withWidth)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 0
    }
}

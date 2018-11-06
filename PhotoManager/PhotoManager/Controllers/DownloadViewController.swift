//
//  FolderTypeViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-03-12
//  Updated by Jason Chih-Yuan on 2018-08-31
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import PinterestLayout
import RealmSwift
import SDWebImage

class DownloadViewController: UIViewController, UISearchBarDelegate {
    var loadingAlert: UIAlertController = UIAlertController()
    let segueIdentfier = "imageDetailSegue"
    var searchBar : UISearchBar = UISearchBar()

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var newFolder: Folder = Folder()
    var downloadedImageArray: DownloadedImageArray = DownloadedImageArray()
    var selectedFolderName: String!
    var selectedFolderTypeName: String!

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear function performed")

        selectedFolderName = UserDefaultService.getUserDefaultFolderName2()
        selectedFolderTypeName = UserDefaultService.getUserDefaultFolderTypeName2()

        tapGesture.isEnabled = false
        
        CollectionViewService.deselectAll(collectionView: collectionView)
        
        SearchBarService.setDefaultSortImage(searchBar: searchBar)
        collectionView.reloadData()
        
        tabBarController?.tabBar.isHidden = true
        
        //it is not necessary if tab bar is hidden
        for i in self.newFolder.getImageArray(){
            i.setCategoryName(self.selectedFolderTypeName)
            i.setSubCategoryName(self.selectedFolderName)
            
            let hashTags = List<HashTag>()
            
            let hashTag1 = HashTag(hashTag: "#"+self.selectedFolderName)
            let hashTag2 = HashTag(hashTag: "#"+self.selectedFolderTypeName)
            
            if self.selectedFolderTypeName == "Default"{
                hashTags.append(hashTag1)
            }else{
                hashTags.append(hashTag1)
                hashTags.append(hashTag2)
            }
            
            
            i.setHashTags(hashTags)
        }

    }
    
    
    //a function will be performed when it is first launched
    override func viewDidLoad() {
        print("viewDidLoad function performed")
        super.viewDidLoad()
        
        self.navigationItem.title = "Downloads"
 
        SearchBarService.setSearchBarProperty(searchBar: self.searchBar, searchBarDelegate: self, placeholder: "Search Images", bookmark: false)
        CollectionViewService.pinHeaderToTopWhenScrolling(collectionView: self.collectionView)
        
        CollectionViewService.initCollectionView(collectionView: self.collectionView, collectionDataSource: self, collectionDelegate: self)
        
        DownloadService.setEmptyMessageWhenNoCell(text: "Please enter some texts to search image", downloadedImageArray: downloadedImageArray, collectionView: collectionView)
        
        
        
        loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        print("prepare function performed")
        
        if segue.identifier == segueIdentfier{
            let imageDetailVC = segue.destination as! ImageDetailsViewController
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            
            let selectedImage = self.newFolder.getImageArray()[indexpaths![0].item]
            
            imageDetailVC.currentImage = selectedImage
            imageDetailVC.selectedFolder = self.newFolder
            imageDetailVC.saveBtn.isEnabled = true
        }
        
    }
    
    // //a function to be performed when user tap the screen and the search bar is clicked
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        print("tap function performed")
        self.searchBar.endEditing(true)
    }
    
}


extension DownloadViewController: UICollectionViewDataSource{
    //a function to set number of cell to be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView return num of cell function performed")

        return self.downloadedImageArray.getTotalImage()
    }
    
    //a function to set cell property when user see the view and scroll the view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView return cell function performed")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.IDENTIFIER, for: indexPath) as! ImageCollectionViewCell

        cell.photoImage.sd_setImage(with: self.downloadedImageArray.getPreviewImageURLs()[indexPath.item], placeholderImage: #imageLiteral(resourceName: "Placeholder"))

        cell.photoImage.image = Image.compressImage(cell.photoImage.image!, maxWidth: 120, quality: 0.5)

        return cell
    }
    

}

extension DownloadViewController: UICollectionViewDelegate{
    
    
    //a function to initialize header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("collectionView return header function performed")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "downloadSearchBar", for: indexPath)
        
        return SearchBarService.createSearchBarGraphic(searchBar: searchBar, header: header)
    }
    
    //a function to change all button status when starting editing on search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       print("searchBarTextDidBeginEditing function performed")
        
        SearchBarService.searchBarButtonChangeWhenIsEditing(viewController: self, collectionView: self.collectionView, searchBar: self.searchBar, tapGesture: self.tapGesture, isBeginEditing: true, bookmark: false)
    }
    
    //a function to change all button status when finishing editing on search bar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       
        print("searchBarTextDidEndEditing function performed")
        SearchBarService.searchBarButtonChangeWhenIsEditing(viewController: self, collectionView: self.collectionView, searchBar: self.searchBar, tapGesture: self.tapGesture, isBeginEditing: false, bookmark: false)
    }
    
    //a function will be performed when you click enter on search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked function performed")
        
        searchBar.endEditing(true)
        self.newFolder.clearImageArray()
    
        self.downloadedImageArray.setCurrentPage(currentPage: 1)
        self.downloadedImageArray.clearPreviewImageURLs()
        self.downloadedImageArray.clearLargeImageURLs()

        
        if searchBar.text != ""{
            
            print("search text not empty")
            DownloadService.fetchDataFromPixabay(page: self.downloadedImageArray.getCurrentPage(), text: searchBar.text!, collectionView: collectionView, downloadedImageArray: downloadedImageArray, loadingAlert: loadingAlert, downloadedVC: self, selectedFolderName: selectedFolderName, selectedFolderTypeName: selectedFolderTypeName, newFolder: newFolder) { (result) -> (Void) in
                if result{
                    
                    DispatchQueue.main.async {
                        
                        print("core function")
                        
                        self.loadingAlert.dismiss(animated: true)
                        self.collectionView.reloadData()
                        DownloadService.setEmptyMessageWhenNoCell(text: "No data found", downloadedImageArray: self.downloadedImageArray, collectionView: self.collectionView)
                       
                    }
                   
                    
                }else{
                    print("failed")
                    self.loadingAlert.dismiss(animated: true, completion: nil)
                    self.collectionView.reloadData()
                }
            }
        }else{
            
            print("search text empty")
            DownloadService.setEmptyMessageWhenNoCell(text: "Please enter some texts to search image", downloadedImageArray: downloadedImageArray, collectionView: collectionView)
            self.collectionView.reloadData()

        }


    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging function performed")
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print(" you reached end of the table")
            
            self.downloadedImageArray.setCurrentPage(currentPage: self.downloadedImageArray.getCurrentPage() + 1)

            DownloadService.fetchDataFromPixabay(page: self.downloadedImageArray.getCurrentPage(), text: searchBar.text!, collectionView: collectionView, downloadedImageArray: downloadedImageArray, loadingAlert: loadingAlert, downloadedVC: self, selectedFolderName: selectedFolderName, selectedFolderTypeName: selectedFolderTypeName, newFolder: newFolder) { (result) -> (Void) in
                if result{
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.loadingAlert.dismiss(animated: true, completion: nil)
                    }

                }else{
                    print("failed")
                    self.loadingAlert.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
        
    }
    
    //a function will be performed when you scroll the view.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // self.collectionView.isUserInteractionEnabled = true
        print("scrollViewWillBeginDragging function performed")
        searchBar.endEditing(true)
    }
    
}


//
//  ImageSearchViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-15.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController, UISearchBarDelegate{

    
    lazy var searchBar : UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search Image"
        s.delegate = self
        s.barTintColor = UIColor.black// color you like
        s.barStyle = .default
        s.sizeToFit()
        return s
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedImage: Image!
    let segueIdentfier = "imageDetailSegue"
    @IBOutlet weak var collectionView: UICollectionView!
    let identifier = "imageCell"
    var foundImages:[Image] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Image Search"
        searchBar.enablesReturnKeyAutomatically = false
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "imageSearchBar")
        collectionView.dataSource = self
        collectionView.delegate = self
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == segueIdentfier{
            let imageDetailVC = segue.destination as! ImageDetailsViewController
            let indexpaths = self.collectionView?.indexPathsForSelectedItems

            self.selectedImage = self.foundImages[indexpaths![0].item]

            imageDetailVC.image = self.selectedImage

        }
        
    }
}

extension ImageSearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return foundImages.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! ImageSearchCell
       
        let image = UIImage(data: (self.foundImages[indexPath.item].getImageBinaryData()) as Data, scale:1.0)
        
        cell.photoImage.image = image
        
        return cell
    }
}
extension ImageSearchViewController: UICollectionViewDelegate{

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "imageSearchBar", for: indexPath)
        header.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let cells = collectionView.visibleCells
        for i in cells{
            i.alpha = 0.5
        }
        self.collectionView.allowsSelection = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        initailization()
    }
    
    func initailization(){
        let cells = collectionView.visibleCells
        for i in cells{
            i.alpha = 1
        }
        self.collectionView.allowsSelection = true
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let images = RealmService.shared.realm.objects(Image.self)
        
        self.foundImages = []
        var found = false
        
        let searchText = searchBar.text ?? ""
        
        let myStrippedString = searchText.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: " ")
        
        let ok = myStrippedString.lowercased().split(whereSeparator: { $0 == " " })
        
        if !searchText.isEmpty {
            for i in images{
                for j in i.getHashTags(){
                    
                    for word in ok{
//                        print("\(word) -\(j.getHashTag().lowercased().contains(word.lowercased())) \(j.getHashTag().lowercased() == word)")
                        if j.getHashTag().lowercased().contains(word.lowercased()){
                            found = true
                            break
                        }
                        
                    }
                    
                }
                if(found){
                    self.foundImages.append(i)
                    
                    found = false
                }
            }
            
        }else{
            self.foundImages = []

        }
        self.collectionView?.reloadData()
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        searchBar.endEditing(true)
        
    }
    
}

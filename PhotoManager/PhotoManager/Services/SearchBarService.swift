//
//  SearchBarService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-30.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
class SearchBarService{
    
    public static func setSearchBarProperty(searchBar: UISearchBar, searchBarDelegate: UISearchBarDelegate, placeholder: String){
        //searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.delegate = searchBarDelegate
        searchBar.barTintColor = UIColor.black// color you like
        searchBar.barStyle = .default
        searchBar.sizeToFit()
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "ascendingSortForToolbar.png"), for: .bookmark, state: .normal)
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    public static func createSearchBarGraphic(searchBar: UISearchBar, header: UICollectionReusableView)->UICollectionReusableView{
        header.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        
        return header
    }
    
    public static func searchBarButtonChangeWhenIsEditing(viewController: UIViewController, collectionView: UICollectionView, searchBar: UISearchBar, tapGesture: UITapGestureRecognizer,isBeginEditing: Bool){
        let cells = collectionView.visibleCells
        if(isBeginEditing == false){
            for i in cells{
                i.alpha = 1
            }
            viewController.navigationItem.rightBarButtonItem?.isEnabled = true
            collectionView.allowsSelection = true
            searchBar.showsBookmarkButton = true
            tapGesture.isEnabled = false
            //searchBar.isUserInteractionEnabled = true
            //searchBar.alpha = 1
            //searchBar.isHidden = true
            
        }else{
            for i in cells{
                i.alpha = 0.5
            }
            viewController.navigationItem.rightBarButtonItem?.isEnabled = false
            collectionView.allowsSelection = false
            searchBar.showsBookmarkButton = false
            tapGesture.isEnabled = true
            //searchBar.isUserInteractionEnabled = false
            //searchBar.user
            //searchBar.isHidden = false
            //searchBar.alpha = 0.5
        }
    }
    
    public static func searchBarChangeWhenSetEditng(searchBar: UISearchBar,editing: Bool){
        searchBar.showsBookmarkButton = !editing
        searchBar.isUserInteractionEnabled = !editing
       
        searchBar.barTintColor = !editing ? UIColor.black : UIColor.darkGray
        
      
    }
    
    public static func setDefaultSortImage(searchBar: UISearchBar){
        searchBar.setImage(UIImage(named: "ascendingSortForToolbar.png"), for: .bookmark, state: .normal)
    }
    
    public static func sortFolderTypeWhenClickingOrNil(searchBar: UISearchBar, folderTypes: TypeList){
        if searchBar.text != ""{
            folderTypes.filterFolderType(sortBy: searchBar.text ?? "")
        }
    }
    
    public static func sortFolderWhenClickingOrNil(searchBar: UISearchBar, folderType: Type){
        if searchBar.text != ""{
            folderType.filterFolder(sortBy: searchBar.text ?? "")
        }
    }
    
    public static func changeSortImage(searchBar: UISearchBar,ascSort: Bool){
        if ascSort{
            searchBar.setImage(UIImage(named: "descendingSortForToolbar.png"), for: .bookmark, state: .normal)
        }else{
            searchBar.setImage(UIImage(named: "ascendingSortForToolbar.png"), for: .bookmark, state: .normal)
        }
    }
    
    public static func sortByAType(folderTypes: TypeList,controller: UIViewController, collectionView: UICollectionView, searchBar: UISearchBar){
        AlertDialog.showSortAlertMessage(title: "Pick Sort Type", btnTitle1: "Sort by name", handler1: { (_) in
            folderTypes.sortByName()
            SearchBarService.changeSortImage(searchBar: searchBar, ascSort: folderTypes.getASCSort())
            collectionView.reloadData()
        }, btnTitle2: "Sort by created date", handler2: { (_) in
            folderTypes.sortByDateCreated()
            SearchBarService.changeSortImage(searchBar: searchBar, ascSort: folderTypes.getASCSort())
            collectionView.reloadData()
        }, btnTitle3: "Sort by number of folders", handler3: { (_) in
            folderTypes.sortByNumOfFolder()
            SearchBarService.changeSortImage(searchBar: searchBar, ascSort: folderTypes.getASCSort())
            collectionView.reloadData()
        }, cancelBtnTitle: "Cancel", controller: controller)
        
    }
    
    
    public static func sortByAType(folderType: Type,controller: UIViewController, collectionView: UICollectionView, searchBar: UISearchBar){
        AlertDialog.showSortAlertMessage(title: "Pick Sort Type", btnTitle1: "Sort by name", handler1: { (_) in
            folderType.sortByName()
            SearchBarService.changeSortImage(searchBar: searchBar, ascSort: folderType.getASCSort())
            collectionView.reloadData()
        }, btnTitle2: "Sort by created date", handler2: { (_) in
            folderType.sortByDateCreated()
            SearchBarService.changeSortImage(searchBar: searchBar, ascSort: folderType.getASCSort())
            collectionView.reloadData()
        }, btnTitle3: "Sort by number of images", handler3: { (_) in
            folderType.sortByNumOfImages()
            SearchBarService.changeSortImage(searchBar: searchBar, ascSort: folderType.getASCSort())
            collectionView.reloadData()
        }, cancelBtnTitle: "Cancel", controller: controller)
        
    }
    
    
}

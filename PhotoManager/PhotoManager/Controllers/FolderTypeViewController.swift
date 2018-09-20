//
//  FolderTypeViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-03-12
//  Updated by Jason Chih-Yuan on 2018-08-31
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
class FolderTypeViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    static let NUM_OF_LIMIT_WORD_CHARACTER = 9
    var searchBar : UISearchBar = UISearchBar()
    var folderTypes: TypeList!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //a function will be performed after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        isEditing = false
        folderTypes = TypeList()
        folderTypes.getFolderTypeDataFromRealm()
        folderTypes.setDefaultSort()
        SearchBarService.sortFolderTypeWhenClickingOrNil(searchBar: searchBar, folderTypes: folderTypes)
        CollectionViewService.initCollectionViewWhenWillAppear(tabBar: (self.tabBarController?.tabBar)!, toolbar: toolbar, searchBar: searchBar, collectionView: collectionView, tapGesture: self.tapGesture)
        
    }
    
    
    //a function will be performed when it is first launched
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationService.initNavigationItem(title: "Types", navigationItem: navigationItem, editButtonItem: editButtonItem)
        
        SearchBarService.setSearchBarProperty(searchBar: self.searchBar, searchBarDelegate: self, placeholder: "Search Folder Types")
        CollectionViewService.pinHeaderToTopWhenScrolling(collectionView: self.collectionView)
        
        CollectionViewService.initCollectionView(collectionView: self.collectionView, collectionDataSource: self, collectionDelegate: self)
        
    }
    
    //a function to be performed when a user click a folder
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        TransitionToOtherViewService.folderTypeViewTransition(folderTypes: self.folderTypes, segue: segue, collectionView: self.collectionView)
        
    }
    
    
    //a function to check if it can go to the next folder and to be performed before prepare()
    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
    
    //a function to be performed when a user clicks edit button
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        SearchBarService.searchBarChangeWhenSetEditng(searchBar: self.searchBar, editing: editing)
        TabBarService.tabBarChangeWhenSetEditing(tabBarController: self.tabBarController!, editing: editing)
        ToolBarService.toolbarItemChangeWhenSetEditing(toolbar: self.toolbar, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton,navigationItem: navigationItem, editing: editing)
        CollectionViewService.collectionViewChnageWhenSetEditing(collectionView: self.collectionView, editing: editing)
    }
    
    
    
    //add a folder type to realm database
    @IBAction func addFolderType(_ sender: UIBarButtonItem) {
        CollectionViewService.addTypesToRealm(folderTypes: self.folderTypes, controller: self, collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, textFieldDelegate: self)
        
    }
    
    //delete one or many folder type from realm database
    @IBAction func deleteFolderType(_ sender: UIBarButtonItem) {
        CollectionViewService.deleteTypesToRealm(folderTypes: self.folderTypes, controller: self, collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, textFieldDelegate: self)
       
    }
    
    //update a folder type from realm database
    @IBAction func updateFolderType(_ sender: UIBarButtonItem) {
        CollectionViewService.updateTypesToRealm(folderTypes: self.folderTypes, controller: self, collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, textFieldDelegate: self)
        
    }
    
    //a function to limit number of character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        let newLength = text.count + string.count - range.length
        return newLength <= FolderTypeViewController.NUM_OF_LIMIT_WORD_CHARACTER
    }

    // //a function to be performed when user tap the screen and the search bar is clicked
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        self.searchBar.endEditing(true)
    }
    
}


extension FolderTypeViewController: UICollectionViewDataSource{
    //a function to set number of cell to be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.folderTypes.getFolderTypeSize()
    }
    
    //a function to set cell property when user see the view and scroll the view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderTypeCellCollectionViewCell.IDENTIFIER, for: indexPath) as! FolderTypeCellCollectionViewCell
        
        
        
        let folderNmaeString = self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getName()
        cell.folderTypeLabel.text = folderNmaeString
        
        let numOfFolders = self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getFolders().count
        
//        if cell.folderTypeLabel.text != "Default"{
//            cell.folderTypeImage.image = #imageLiteral(resourceName: "folder_Category")
//        }else
//
        if cell.folderTypeLabel.text == "Default"{
            
            cell.folderTypeImage.image = #imageLiteral(resourceName: "folder_Details")
            
            cell.numOfFolders.text = "\(self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getFolders()[0].getImageCount())"
        }else{
            cell.numOfFolders.text = numOfFolders == 0 ? "Empty" : "\(numOfFolders)"
            cell.folderTypeImage.image = #imageLiteral(resourceName: "folder_Category")
        }
        
        cell.cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: isEditing)
        
        
        return cell
    }
    
}

extension FolderTypeViewController: UICollectionViewDelegate{
    
    //a function to be performed when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("1")
        let indexpaths = self.collectionView?.indexPathsForSelectedItems
        let selectedFolderType = self.folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
        
        if !isEditing{
            if selectedFolderType.getName() != TransitionToOtherViewService.DEFAULT_FOLDER_TYPE_NAME{
                self.performSegue(withIdentifier: TransitionToOtherViewService.SEGUE_IDENTIFIER_FOR_TYPE_TO_FOLDER, sender: nil)
                
            } else {
                self.performSegue(withIdentifier: TransitionToOtherViewService.SEGUE_IDENTIFIER_FOR_TYPE_TO_IMAGE, sender: nil)
                
            }
        }
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton)
        
    }
    
    //a function to be performed when you deselect item
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("2")
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton)
    }
    
    //a function to initialize header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "folderTypeSearchBar", for: indexPath)
        
        return SearchBarService.createSearchBarGraphic(searchBar: searchBar, header: header)
    }
    
    //a function to change all button status when starting editing on search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        SearchBarService.searchBarButtonChangeWhenIsEditing(viewController: self, collectionView: self.collectionView, searchBar: self.searchBar, tapGesture: self.tapGesture, isBeginEditing: true)
    }
    
    //a function to change all button status when finishing editing on search bar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        SearchBarService.searchBarButtonChangeWhenIsEditing(viewController: self, collectionView: self.collectionView, searchBar: self.searchBar, tapGesture: self.tapGesture, isBeginEditing: false)
    }
    
    //a function will be performed when you click enter on search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.folderTypes.clearFolderTypeList()
        self.folderTypes.getFolderTypeDataFromRealm()
        SearchBarService.sortFolderTypeWhenClickingOrNil(searchBar: searchBar, folderTypes: folderTypes)
        self.collectionView?.reloadData()
        searchBar.endEditing(true)
    }
    
    //a function will be performed when you scroll the view.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       // self.collectionView.isUserInteractionEnabled = true
        searchBar.endEditing(true)
    }
    
    //a function will be performed when you click sort button
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        SearchBarService.sortByAType(folderTypes: self.folderTypes, controller: self, collectionView: self.collectionView, searchBar: self.searchBar)
        
    }
}

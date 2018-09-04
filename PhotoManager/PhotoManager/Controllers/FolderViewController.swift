//
//  FolderViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-03-13
//  Updated by Jason Chih-Yuan on 2018-09-03
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import RealmSwift

class FolderViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {

    static let NUM_OF_LIMIT_WORD_CHARACTER = 9
    var searchBar : UISearchBar = UISearchBar()
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var folderType: Type!

    //a function will be performed after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        self.folderType.setFolderArray(folders: Array(self.folderType.getFolders()))
        //folderType = Type()
        //folderType.getFolderDataFromRealm(typeName: navigationItem.title!)
        
        self.folderType.setDefaultSort()
        SearchBarService.sortFolderWhenClickingOrNil(searchBar: searchBar, folderType: folderType)
        CollectionViewService.initCollectionViewWhenWillAppear(tabBar: (self.tabBarController?.tabBar)!, toolbar: toolbar, searchBar: searchBar, collectionView: collectionView)
    }

    //a function will be performed when it is first launched
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationService.initNavigationItem(title: folderType.getName(), navigationItem: navigationItem, editButtonItem: editButtonItem)
        
        SearchBarService.setSearchBarProperty(searchBar: self.searchBar, searchBarDelegate: self, placeholder: "Search Folders")
        CollectionViewService.pinHeaderToTopWhenScrolling(collectionView: self.collectionView)
        
        CollectionViewService.initCollectionView(collectionView: self.collectionView, collectionDataSource: self, collectionDelegate: self)
        
    }
    
    //a function to be performed when a user click a folder
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        TransitionToOtherViewService.folderViewTransition(folderType: self.folderType, segue: segue, collectionView: self.collectionView)
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
        ToolBarService.toolbarItemChangeWhenSetEditing(toolbar: self.toolbar, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, editing: editing)
        CollectionViewService.collectionViewChnageWhenSetEditing(collectionView: self.collectionView, editing: editing)
    }


    //add a folder to realm database
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
       CollectionViewService.addFoldersToRealm(folderType: self.folderType, controller: self, collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, textFieldDelegate: self)
    }


    //update a folder from realm database
    @IBAction func updateFolder(_ sender: UIBarButtonItem) {
        CollectionViewService.updateFolderToRealm(folderType: self.folderType, controller: self, collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, textFieldDelegate: self)
    }

    //delete one or many folder from realm database
    @IBAction func deleteFolder(_ sender: UIBarButtonItem) {
        CollectionViewService.deleteTypesToRealm(folders: self.folderType, controller: self, collectionView: self.collectionView, addButton:self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton, textFieldDelegate: self)
    }
    
    //a function to limit number of character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        let newLength = text.count + string.count - range.length
        return newLength <= FolderViewController.NUM_OF_LIMIT_WORD_CHARACTER
    }
}


extension FolderViewController: UICollectionViewDataSource{
     //a function to set number of cell to be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.folderType.getFolderArray().count
    }
    
    //a function to set cell property when user see the view and scroll the view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.IDENTIFIER, for: indexPath) as! FolderCollectionViewCell
        
        let folderNmaeString = self.folderType.getFolderArray()[indexPath.item].getName()
        cell.folderLabel.text = folderNmaeString
        
        let numOfImages = self.folderType.getFolderArray()[indexPath.item].getImages().count
        cell.countLabel.text = numOfImages == 0 ? "Empty" : "\(numOfImages)"
        
        cell.cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: isEditing)
        

        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
}

extension FolderViewController: UICollectionViewDelegate{
    //a function to be performed when a cell is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton)
        
    }
    
    //a function to be performed when you deselect item
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        ToolBarService.toolbarItemWhenCellIsClickedAndDeclicked(collectionView: self.collectionView, addButton: self.addButton, updateButton: self.updateButton, deleteButton: self.deleteButton)
        
    }

    //a function to initialize header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "folderSearchBar", for: indexPath)
       
        return SearchBarService.createSearchBarGraphic(searchBar: searchBar, header: header)
    }

    //a function to change all button status when starting editing on search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        SearchBarService.searchBarButtonChangeWhenIsEditing(viewController: self, collectionView: self.collectionView, searchBar: self.searchBar, isBeginEditing: true)
    }
    
    //a function to change all button status when finishing editing on search bar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        SearchBarService.searchBarButtonChangeWhenIsEditing(viewController: self, collectionView: self.collectionView, searchBar: self.searchBar, isBeginEditing: false)
    }
    
    //a function will be performed when you click enter on search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.folderType.clearFolderArrayData()
        self.folderType.getFolderDataFromRealm(typeName: navigationItem.title!)

        SearchBarService.sortFolderWhenClickingOrNil(searchBar: searchBar, folderType: folderType)
        self.collectionView?.reloadData()
        searchBar.endEditing(true)
    }

    //a function will be performed when you scroll the view.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    //a function will be performed when you click sort button
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        SearchBarService.sortByAType(folderType: self.folderType, controller: self, collectionView: self.collectionView, searchBar: self.searchBar)
        
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touching")
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("ending")
//    }

    
}

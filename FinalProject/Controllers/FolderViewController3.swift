//
//  FolderViewController3.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-13.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import RealmSwift

class FolderViewController3: UIViewController, UISearchBarDelegate {

    lazy var searchBar : UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search Folder"
        s.delegate = self
        s.barTintColor = UIColor.black// color you like
        s.barStyle = .default
        s.sizeToFit()
        return s
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    var edit:Bool!
    var selectedFolder: Folder!
    let segueIdentfier = "folderImageSegue"
    let identifier = "folderCell"
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var folderType: Type!
    var folders: [Folder]!
    var numOfSelection: Int!
    
    var nameASCSort: Bool!
    var dateCreatedASCSort: Bool!
    var numOfImageASCSort: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        
        toolbar.isHidden = true
        
        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", navigationItem.title ?? "")
        
        let tempFolders = tempFolderType[0].getFolders()
        
        folders = [Folder]()
        for i in tempFolders{
            folders.append(i)
        }

        if searchBar.text != ""{
            
            self.folders = self.folders.filter{ $0.getName().lowercased().contains(searchBar.text?.lowercased() ?? "")}
            
        }
        self.collectionView.reloadData()
        
        self.isEditing = false
        
        self.nameASCSort = false
        self.dateCreatedASCSort = false
        self.numOfImageASCSort = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "sort.png"), for: .bookmark, state: .normal)
        
        searchBar.enablesReturnKeyAutomatically = false
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "folderSearchBar")
        
        self.edit = false
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navigationItem.title = folderType.getName()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
           
        if segue.identifier == segueIdentfier{
            let imageVC = segue.destination as! ImageViewController
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            
            self.selectedFolder = self.folders[indexpaths![0].item]
            
            imageVC.selectedFolderType = self.folderType
            imageVC.selectedFolder = self.selectedFolder
            
        }

    }
    
    
    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            self.tabBarController?.tabBar.isHidden = true
            
            self.edit = true
        }else{
            self.edit = false
            self.tabBarController?.tabBar.isHidden = false
            
        }
        collectionView?.allowsMultipleSelection = editing
        toolbar.isHidden = !editing
        addButton.isEnabled = true
        deleteButton.isEnabled = false
        updateButton.isEnabled = false
        collectionView.reloadData()
    }

    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add name?", message: "Enter the folder name", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            let folderName = alertController.textFields?[0].text

            if let tempFolderName = folderName?.trimmingCharacters(in: .whitespaces), !UtilityService.shared.isTextEmpty(tempFolderName) {


                if UtilityService.shared.repeatedFolderFound(self.folders, folderName){
                    UtilityService.shared.showAlert(title: "Existed Folder Error", message: "The folder type is already existed, please create another unique name for this folder type", buttonTitle: "Confirm", vc: self)
                }else{
                    var folders: List<Folder>
                    if self.folders.isEmpty{
                        folders = List<Folder>()
                    }else{
                        folders = List<Folder>()
                        for sectionFolder in self.folders{
                            folders.append(sectionFolder)
                        }
                        
                    }
                    let newImages = List<Image>()
                    let newFolder = Folder(name: tempFolderName, createdDate: Date() ,images: newImages, imageCount: newImages.count)
                    
                    folders.append(newFolder)
                    
                    RealmService.shared.update(self.folderType, with: ["name": self.folderType.getName(), "folderCount": folders.count, "folders": folders])
                    
                    
       
                    self.folders.append(newFolder)
                    self.collectionView?.reloadData()

            }
            }else{
                UtilityService.shared.showAlert(title: "Null String Error", message: "We don't accept the empty string; please give your folder a descriptive name", buttonTitle: "Confirm", vc: self)
            }
            
            
            self.initButtons()
            
        }
        
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        
        alertController.addTextField(configurationHandler: { (textField) in
            
            textField.placeholder = "Enter Folder Name"
            
        })
        
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func updateFolder(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Modify name?", message: "Enter the folder name", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                    
                let modifiedName = alertController.textFields?[0].text

                var imagesInFolders: List<Image>
                if (!self.folders[indexPath.item].getImages().isEmpty){
                    imagesInFolders = List<Image>()
                    for s in self.folders[indexPath.item].getImages(){
                        imagesInFolders.append(s)
                    }
                }else{
                    imagesInFolders = List<Image>()
                }

                // 1. update the folder from our data source
                let folderType = self.folders[indexPath.item]
                RealmService.shared.update(folderType, with: ["name": modifiedName, "createdDate":self.folders[indexPath.item].getCreatedDate(),"images": imagesInFolders])
                
                self.initButtons()
                    self.collectionView?.reloadData()

            }
            }
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        
        //adding textfields to our dialog box
        
        alertController.addTextField(configurationHandler: { (textField) in
            
            
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                let folderTypeName = self.folders[indexPath.item].getName()
                textField.text = folderTypeName
                confirmAction.isEnabled = false
                
                textField.placeholder = "Enter Folder Type Name"
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    
                    let modifiedName = alertController.textFields?[0].text
                    
                    if !UtilityService.shared.repeatedFolderFound(self.folders, modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)!{
                        confirmAction.isEnabled = true
                    }else{
                        confirmAction.isEnabled = false
                    }
                    
                    
                }
                }}
        })
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteFolder(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(title: "Delete this folder?", message: "Are you sure you want to delete this folder?", preferredStyle: .alert)
        

        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            var deletedFolders:[Folder] = []
            
            if let indexpaths = indexpaths {
                for item  in indexpaths {
                    self.collectionView?.deselectItem(at: (item), animated: true)
                    
                    let folder = self.folders[item.row]
                
                
                if(!folder.getImages().isEmpty){
                    for i in folder.getImages(){
                        for j in i.getHashTags(){
                            RealmService.shared.delete(j)
                        }
                        RealmService.shared.delete(i.getLocation())
                        RealmService.shared.delete(i)
                    }
                }

                    deletedFolders.append(folder)
                }
                
                
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(deletedFolders)
                }
               
               
//                RealmService.shared.update(self.folderType, with: ["name": self.folderType.getName(), "folderCount": self.folders.count, "folders": self.folders])
//
                
                
                let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", self.navigationItem.title ?? "")
                
                let tempFolders = tempFolderType[0].getFolders()
                
                self.folders = [Folder]()
                for i in tempFolders{
                    self.folders.append(i)
                }
                
                 self.collectionView?.deleteItems(at: indexpaths)
                self.initButtons()
                

            }
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initButtons(){
        addButton.isEnabled = true
        updateButton.isEnabled = false
        deleteButton.isEnabled = false
    }
}


extension FolderViewController3: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.folders.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! FolderCollectionViewCell
        
        let folderNmaeString = self.folders[indexPath.item].getName()
        cell.folderLabel.text = folderNmaeString
        
        let numOfImages = self.folders[indexPath.item].getImages().count
        cell.countLabel.text = numOfImages == 0 ? "Empty" : "\(numOfImages)"
        
        if edit{

            cell.uncheckedBoxImage.isHidden = false

        }else{

            cell.uncheckedBoxImage.isHidden = true

        }

        return cell
    }
}

extension FolderViewController3: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.numOfSelection = self.collectionView?.indexPathsForSelectedItems?.count
        if numOfSelection == 0{
            updateButton.isEnabled = false
            deleteButton.isEnabled = false
            addButton.isEnabled = true
        }else if numOfSelection == 1{
            updateButton.isEnabled = true
            deleteButton.isEnabled = true
            addButton.isEnabled = false
        }else if numOfSelection > 1{
            updateButton.isEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        self.numOfSelection = self.collectionView?.indexPathsForSelectedItems?.count
        if numOfSelection == 0{
            updateButton.isEnabled = false
            deleteButton.isEnabled = false
            addButton.isEnabled = true
        }else if numOfSelection == 1{
            updateButton.isEnabled = true
            deleteButton.isEnabled = true
            addButton.isEnabled = false
        }else if numOfSelection > 1{
            updateButton.isEnabled = false
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "folderSearchBar", for: indexPath)
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
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.collectionView.allowsSelection = false
        self.searchBar.showsBookmarkButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        initailization()
    }
    
    func initailization(){
        let cells = collectionView.visibleCells
        for i in cells{
            i.alpha = 1
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.collectionView.allowsSelection = true
        self.searchBar.showsBookmarkButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", navigationItem.title ?? "")
        
        let tempFolders = tempFolderType[0].getFolders()
        
        self.folders = [Folder]()
        for i in tempFolders{
            folders.append(i)
        }
        
        if searchBar.text != ""{
            
            self.folders = self.folders.filter{ $0.getName().lowercased().contains(searchBar.text?.lowercased() ?? "")}
            
        }
        self.collectionView?.reloadData()
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        searchBar.endEditing(true)
        
    }

    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let actionSheet = UIAlertController(title: "Choose Package Type", message: nil , preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: { (_) in
            
            self.sortByName()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Sort by created date", style: .default, handler: { (_) in
            self.sortByDateCreated()
        } ))
        actionSheet.addAction(UIAlertAction(title: "Sort by number of images", style: .default, handler: {(_) in
            self.sortByNumOfImages()
        } ))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: {
            (action: UIAlertAction) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        present( actionSheet , animated:  true , completion:  nil)
        
    }
    func sortByName(){

        if !self.nameASCSort{
            self.nameASCSort = true
            self.dateCreatedASCSort = false
            self.numOfImageASCSort = false
            
            self.folders = self.folders.sorted(by: { $0.getName() > $1.getName() })

            self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfImageASCSort = false
            self.folders = self.folders.sorted(by: { $0.getName() < $1.getName() })

            self.collectionView.reloadData()
            
        }
        

    }
    
    func sortByDateCreated(){
        if !self.dateCreatedASCSort{
            self.nameASCSort = false
            self.dateCreatedASCSort = true
            self.numOfImageASCSort = false
            
            self.folders = self.folders.sorted(by: { $0.getCreatedDate() > $1.getCreatedDate() })
            
            self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfImageASCSort = false
            self.folders = self.folders.sorted(by: { $0.getCreatedDate() < $1.getCreatedDate() })
            
            self.collectionView.reloadData()
            
        }
        
        
    }
    
    func sortByNumOfImages(){
        if !self.numOfImageASCSort{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfImageASCSort = true
            
            self.folders = self.folders.sorted(by: { $0.getImageCount() > $1.getImageCount() })
            
            self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfImageASCSort = false
            self.folders = self.folders.sorted(by: { $0.getImageCount() < $1.getImageCount() })
            
            self.collectionView.reloadData()
            
        }
        
    }
    
}

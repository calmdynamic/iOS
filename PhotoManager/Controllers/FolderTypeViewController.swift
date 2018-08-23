//
//  FolderTypeViewController2.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-12.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import RealmSwift

class FolderTypeViewController: UIViewController, UISearchBarDelegate {

    lazy var searchBar : UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search Folder Types"
        s.delegate = self
        s.barTintColor = UIColor.black// color you like
        s.barStyle = .default
        s.sizeToFit()
        return s
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    var currentIndexPath: IndexPath!
    var edit:Bool!
    let identifier = "folderTypeCell"
    let segueIdentfier = "typeFolderSegue"
    var selectedFolderType: Type!
    var folderTypes: [Type]!
    var numOfSelection: Int!
    var nameASCSort: Bool!
    var dateCreatedASCSort: Bool!
    var numOfFolderASCSort: Bool!
  
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = false
        toolbar.isHidden = true
        let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)
        

        folderTypes = [Type]()
        for i in tempFolderTypes{
            folderTypes.append(i)
        }
        
        
        numOfSelection = 0
        deselectAll()
        
        if searchBar.text != ""{
            self.folderTypes = self.folderTypes.filter{ $0.getName().lowercased().contains(searchBar.text?.lowercased() ?? "")}
            
        }
        collectionView.reloadData()
        
        
        self.nameASCSort = false
        self.dateCreatedASCSort = false
        self.numOfFolderASCSort = false
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Types"
        
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "sort.png"), for: .bookmark, state: .normal)
 
        
        searchBar.enablesReturnKeyAutomatically = false
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "folderTypeSearchBar")

        
        collectionView.dataSource = self
        
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        toolbar.isHidden = true
        
        self.edit = false

        self.collectionView?.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deselectAll(){
        if let indexpaths = self.collectionView?.indexPathsForSelectedItems{
            for i in indexpaths{
                let cell = collectionView.cellForItem(at: i as IndexPath)
                if (cell?.isSelected)!{
                    self.collectionView.deselectItem(at: i, animated: false)
                }
            }
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
 
        let indexpaths = self.collectionView?.indexPathsForSelectedItems
        self.selectedFolderType = self.folderTypes[indexpaths![0].item]
        
        if selectedFolderType.getName() != "Default"{
            if segue.identifier == segueIdentfier{
                let folderVC = segue.destination as! FolderViewController

                self.selectedFolderType = self.folderTypes[indexpaths![0].item]
                folderVC.folderType = self.selectedFolderType

                
            }
            
        } else {
            if segue.identifier == "typeImageSegue"{
            let imageVC = segue.destination as! ImageViewController
            self.selectedFolderType = self.folderTypes[indexpaths![0].item]
            let selectedFolder = self.selectedFolderType.getFolders()[0]

            imageVC.selectedFolderType = self.selectedFolderType
            imageVC.selectedFolder = selectedFolder

        }
        }
        
    }
    
   
    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {
        searchBar.endEditing(true)
        
        var result = false
        
        if (!isEditing == true){
            result = true
        }else{
            result = false
        }
        
        return result
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
    

    
    
    @IBAction func addFolderType(_ sender: UIBarButtonItem) {
        
        
        let alertController = UIAlertController(title: "Add name?", message: "Enter the folder name", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            var newType: Type
            let folderType = alertController.textFields?[0].text
            
            if let tempTypeName = folderType?.trimmingCharacters(in: .whitespaces), !UtilityService.shared.isTextEmpty(tempTypeName) {
                
                
                if UtilityService.shared.repeatedTypeFound(self.folderTypes, folderType){
                    UtilityService.shared.showAlert(title: "Existed Folder Error", message: "The folder type is already existed, please create another unique name for this folder type", buttonTitle: "Confirm", vc: self)
                }else{
                    
                    var folders: List<Folder>
                    folders = List<Folder>()
                    newType = Type(name: tempTypeName, folders: folders, folderCount: folders.count)
                    RealmService.shared.create(newType)
                    self.folderTypes.append(newType)
                    self.collectionView?.reloadData()
                    
                }
            }else{
                UtilityService.shared.showAlert(title: "Null String Error", message: "We don't accept the empty string; please give your folder a descriptive name", buttonTitle: "Confirm", vc: self)
            }
            
            self.initButtons()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField(configurationHandler: { (textField) in
            
            textField.placeholder = "Enter Folder Type Name"
            
        })
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteFolderType(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(title: "Delete this folder type?", message: "Are you sure you want to delete this folder type?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in
        
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
        var deletedFolderTypes:[Type] = []
        
        if let indexpaths = indexpaths {
            
            for item  in indexpaths {
                self.collectionView?.deselectItem(at: (item), animated: true)
                
                let folderType = self.folderTypes[item.row]
                
                if(!folderType.getFolders().isEmpty){
                    for s in self.folderTypes[item.row].getFolders(){
    
                        if(!s.getImages().isEmpty){
                            
                            for image in s.getImages(){
                                
                                for j in image.getHashTags(){
                                    RealmService.shared.delete(j)
                                }
                                RealmService.shared.delete(image.getLocation())
                                RealmService.shared.delete(image)
                            }
                        }
                        RealmService.shared.delete(s)
                        
                        
                        
                    }
                    
                }

                deletedFolderTypes.append(folderType)
            }
            
          
            let realm = try! Realm()
            try! realm.write {
                realm.delete(deletedFolderTypes)
            }
            
            let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)
            
            
            self.folderTypes = [Type]()
            for i in tempFolderTypes{
                self.folderTypes.append(i)
            }
            
            
            
            self.collectionView?.deleteItems(at: indexpaths)
            self.initButtons()
            }}
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
        
            self.present(alertController, animated: true, completion: nil)
            
        
    }
    
    @IBAction func updateFolderType(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Modify name?", message: "Enter the folder name", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                let modifiedName = alertController.textFields?[0].text
                
                
                var sectionFolders: List<Folder>
                    if (!self.folderTypes[indexPath.item].getFolders().isEmpty){
                    sectionFolders = List<Folder>()
                        for s in self.folderTypes[indexPath.item].getFolders(){
                        sectionFolders.append(s)
                    }
                }else{
                    sectionFolders = List<Folder>()
                }
                


                    RealmService.shared.update(self.folderTypes[indexPath.item], with: ["name": modifiedName, "folders": sectionFolders])
                
                    self.initButtons()
                self.collectionView?.reloadData()
                
                

                }
            }
            
        }
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        

        
        alertController.addTextField(configurationHandler: { (textField) in
            
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                
                    let folderTypeName = self.folderTypes[indexPath.item].getName()
                textField.text = folderTypeName
                confirmAction.isEnabled = false
                
                textField.placeholder = "Enter Folder Type Name"
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    
                    let modifiedName = alertController.textFields?[0].text
                    
                    if !UtilityService.shared.repeatedTypeFound(self.folderTypes, modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)!{
                        confirmAction.isEnabled = true
                    }else{
                        confirmAction.isEnabled = false
                    }
                    
                    
                    }
                    
                }
            }
        })
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    func initButtons(){
        addButton.isEnabled = true
        updateButton.isEnabled = false
        deleteButton.isEnabled = false
    }
}


extension FolderTypeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.folderTypes.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! FolderTypeCellCollectionViewCell
        
        let folderNmaeString = self.folderTypes[indexPath.item].getName()
        cell.folderTypeLabel.text = folderNmaeString
        
        let numOfFolders = self.folderTypes[indexPath.item].getFolders().count
        if cell.folderTypeLabel.text == "Default"{
            cell.numOfFolders.text = "\(self.folderTypes[indexPath.item].getFolders()[0].getImageCount())"
        }else{
        cell.numOfFolders.text = numOfFolders == 0 ? "Empty" : "\(numOfFolders)" 
        }
        if edit{
            if cell.folderTypeLabel.text == "Default"{
                cell.uncheckedBoxImage.isHidden = true
                cell.isUserInteractionEnabled = false
            }else{
                cell.uncheckedBoxImage.isHidden = false
            }
        }else{
             cell.isUserInteractionEnabled = true
            cell.uncheckedBoxImage.isHidden = true
            
        }
        
    
        
        return cell
    }
}

extension FolderTypeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        let indexpaths = self.collectionView?.indexPathsForSelectedItems
        self.selectedFolderType = self.folderTypes[indexpaths![0].item]
        
        if !isEditing{
        if selectedFolderType.getName() != "Default"{
            self.performSegue(withIdentifier: self.segueIdentfier, sender: nil)

        } else {
            self.performSegue(withIdentifier: "typeImageSegue", sender: nil)
            
        }
        }
        
        
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "folderTypeSearchBar", for: indexPath)
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

        let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)
        
        folderTypes = [Type]()
        for i in tempFolderTypes{
            folderTypes.append(i)
        }
        
        
        
        if searchBar.text != ""{
            self.folderTypes = self.folderTypes.filter{ $0.getName().lowercased().contains(searchBar.text?.lowercased() ?? "")}
            
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
        actionSheet.addAction(UIAlertAction(title: "Sort by number of folders", style: .default, handler: {(_) in
            self.sortByNumOfFolder()
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
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getName() > $1.getName() })
            
            self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getName() < $1.getName() })
            
            self.collectionView.reloadData()
            
        }
        
    }
    
    func sortByDateCreated(){
        if !self.dateCreatedASCSort{
            self.nameASCSort = false
            self.dateCreatedASCSort = true
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getDateCreated() > $1.getDateCreated() })
            
            self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getDateCreated() < $1.getDateCreated() })
            
            self.collectionView.reloadData()
            
        }
        
    }
    
    func sortByNumOfFolder(){
        if !self.numOfFolderASCSort{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = true
            self.folderTypes = self.folderTypes.sorted(by: { $0.getFolderCount() > $1.getFolderCount() })
            
            self.collectionView.reloadData()
        }else{
            self.nameASCSort = false
            self.dateCreatedASCSort = false
            self.numOfFolderASCSort = false
            self.folderTypes = self.folderTypes.sorted(by: { $0.getFolderCount() < $1.getFolderCount() })
            self.collectionView.reloadData()
            
        }
        
    }
    
    
}

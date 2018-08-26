//
//  FolderTypeViewController2.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-12.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
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
    //var edit:Bool!
    let identifier = "folderTypeCell"
    let segueIdentfier = "typeFolderSegue"
    var selectedFolderType: Type!
    var folderTypes: TypeList!
    var numOfSelection: Int!
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = false
        toolbar.isHidden = true
        folderTypes = TypeList()
        folderTypes.getFolderTypeDataFromRealm()
        
        numOfSelection = 0
        deselectAll()
        if searchBar.text != ""{
            folderTypes.filterFolderType(sortBy: searchBar.text ?? "")
        }
        collectionView.reloadData()
        
        self.folderTypes.setDefaultSort()
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
        
        //self.edit = false

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
        self.selectedFolderType = self.folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
        
        if selectedFolderType.getName() != "Default"{
            if segue.identifier == segueIdentfier{
                let folderVC = segue.destination as! FolderViewController

                self.selectedFolderType = self.folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
                folderVC.folderType = self.selectedFolderType

                
            }
            
        } else {
            if segue.identifier == "typeImageSegue"{
            let imageVC = segue.destination as! ImageViewController
            self.selectedFolderType = self.folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
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
        //isEditing = !isEditing
        super.setEditing(editing, animated: animated)
//        if editing{
//            //self.tabBarController?.tabBar.isHidden = true
//            //self.searchBar.showsBookmarkButton = false
//            self.edit = true
//        }else{
//            self.edit = false
//            //self.searchBar.showsBookmarkButton = true
//            //self.tabBarController?.tabBar.isHidden = false
//        }
        
        collectionView?.allowsMultipleSelection = editing
        toolbar.isHidden = !editing
        self.searchBar.showsBookmarkButton = !editing
        self.tabBarController?.tabBar.isHidden = editing
        addButton.isEnabled = true
        deleteButton.isEnabled = false
        updateButton.isEnabled = false
        collectionView.reloadData()
        
        
        
//        if let indexPaths = collectionView?.indexPathsForVisibleItems {
//            for indexPath in indexPaths {
//                if let cell = collectionView?.cellForItem(at: indexPath) as? PhotoCell {
//                    cell.isEditing = editing
//                }
//            }
//        }
//
        
        
        //isEditing = !isEditing
//        let indexpaths = self.collectionView?.indexPathsForVisibleItems
//
//
//        for indexPath in indexpaths!{
//
//         let cell = collectionView?.cellForItem(at: indexPath) as! FolderTypeCellCollectionViewCell
//
//
//            cell.isEditing = editing
//
//        }
//        self.collectionView?.reloadData()
    }


    @IBAction func addFolderType(_ sender: UIBarButtonItem) {

        AlertDialog.showAlertMessage(controller: self, title: "Add a new type", message: "Enter a new folder type name", leftBtnTitle: "Cancel", rightBtnTitle: "Confirm", completion: { folderType in
            let tempTypeName = folderType.trimmingCharacters(in: .whitespaces)
            if !UtilityService.shared.isTextEmpty(tempTypeName){

                if self.folderTypes.foundRepeatedType(folderType){
                    AlertDialog.showAlertMessage(controller: self, title: "Existed Folder Error", message: "The folder type is already existed, please create another unique name for this folder type", btnTitle: "Confirm")
                }else{
                    //add a new folder type to the collection view
                    self.folderTypes.addFolderTypeToRealm(typename: tempTypeName)
                    self.collectionView?.reloadData()

                }
            }else{
                AlertDialog.showAlertMessage(controller: self, title: "Null String Error", message: "We don't accept the empty string; please give your folder a descriptive name", btnTitle: "Confirm")
            }

            self.initButtons()

        }, textFieldPlaceHolderTitle: "Enter Folder Type Name")

    }

    @IBAction func deleteFolderType(_ sender: UIBarButtonItem) {

        AlertDialog.showAlertMessage(controller: self, title: "Delete this folder type", message: "Ensure to delete this folder type?", leftBtnTitle: "Cancel", rightBtnTitle: "Delete", completion: { (_) in

            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if let indexpaths = indexpaths {

                for item  in indexpaths {
                    self.collectionView?.deselectItem(at: (item), animated: true)
                }
                self.folderTypes.deleteFolderTypeFromRealm(indexpaths: indexpaths)

                self.collectionView?.deleteItems(at: indexpaths)
                self.initButtons()
            }

        }, textFieldPlaceHolderTitle: "")

    }

    @IBAction func updateFolderType(_ sender: UIBarButtonItem) {
        
        AlertDialog.showAlertMessage(controller: self, title: "Modify name?", message: "Enter a new folder name", leftBtnTitle: "Cancel", rightBtnTitle: "Update", completion: {(modifiedName) in
            
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                self.folderTypes.updateFolderTypeFromRealm(indexpaths: indexpaths!, modifiedName: modifiedName)
                self.initButtons()
                self.collectionView?.reloadData()
            }
            
        }, completion2: {(textField, confirmAction, alertController) in
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            if indexpaths!.count == 1 {
                for indexPath in indexpaths!{
                    
                    let folderTypeName = self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getName()
                    textField.text = folderTypeName
                    confirmAction.isEnabled = false
                    
                    textField.placeholder = "Enter Folder Type Name"
                    NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                        
                        let modifiedName = alertController.textFields?[0].text
                        
                        if !self.folderTypes.foundRepeatedType(modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)!{
                            confirmAction.isEnabled = true
                        }else{
                            confirmAction.isEnabled = false
                        }
                        
                        
                    }
                    
                }
            }
            
        })

    }

    func initButtons(){
        addButton.isEnabled = true
        updateButton.isEnabled = false
        deleteButton.isEnabled = false
    }
}


extension FolderTypeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.folderTypes.getFolderTypeSize()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! FolderTypeCellCollectionViewCell
        
        let folderNmaeString = self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getName()
        cell.folderTypeLabel.text = folderNmaeString
        
        let numOfFolders = self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getFolders().count
        if cell.folderTypeLabel.text == "Default"{
            cell.numOfFolders.text = "\(self.folderTypes.getOneFolderTypeByIndedx(index: indexPath.item).getFolders()[0].getImageCount())"
        }else{
        cell.numOfFolders.text = numOfFolders == 0 ? "Empty" : "\(numOfFolders)" 
        }
        
        //isEditing = !isEditing
        if isEditing{
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
        self.selectedFolderType = self.folderTypes.getOneFolderTypeByIndedx(index: indexpaths![0].item)
        
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

        self.folderTypes.clearFolderTypeList()
        self.folderTypes.getFolderTypeDataFromRealm()


        if searchBar.text != ""{
            self.folderTypes.filterFolderType(sortBy: "")

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

            self.folderTypes.sortByName()
            self.collectionView.reloadData()
        }))

        actionSheet.addAction(UIAlertAction(title: "Sort by created date", style: .default, handler: { (_) in
            self.folderTypes.sortByDateCreated()
            self.collectionView.reloadData()
        } ))
        actionSheet.addAction(UIAlertAction(title: "Sort by number of folders", style: .default, handler: {(_) in
            self.folderTypes.sortByNumOfFolder()
            self.collectionView.reloadData()
        } ))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: {
            (action: UIAlertAction) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        present( actionSheet , animated:  true , completion:  nil)

    }
    
}

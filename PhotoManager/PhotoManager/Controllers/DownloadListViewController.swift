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

class DownloadListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedFolderTypeName: String!
    var selectedFolder: Folder!
   // var location: Location!
    var currentKey:String!
    var currentID:String!
    
    var imagesURL: [String]!
    //var images: [UIImage]!
    var imagesArray: [Image]!
    let ref = Database.database().reference()
    let identifier = "folderListCell"
    
    
    override func viewWillAppear(_ animated: Bool) {
       //images = [UIImage]()
        imagesArray = [Image]()
        imagesURL = [String]()
       // self.activityIndicator.startAnimating()
        fetechData2()
        self.tabBarController?.tabBar.isHidden = true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func fetechData2()
    {
        
        if self.currentKey == nil{
            var userEmail: String = (Auth.auth().currentUser?.email)!
            userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
            
            Database.database().reference().child(userEmail).queryOrdered(byChild: "imageID").queryLimited(toLast: 12).observeSingleEvent(of: .value) { (snap:DataSnapshot) in
                
                
                
                if snap.childrenCount > 0 {
                    
                    let first = snap.children.allObjects.first as! DataSnapshot
                    
                    for s in snap.children.allObjects as! [DataSnapshot]{
                        let item = s.value as! Dictionary<String,AnyObject?>
                        
                        self.getDataFromFirebase(item, 0)
                    }
                    
                    self.currentKey = first.key
                    
                    self.currentID = first.childSnapshot(forPath: "imageID").value as! String
                    
                    self.tableView.reloadData()
                }
            }
        }else{
            var userEmail: String = (Auth.auth().currentUser?.email)!
            userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
            
            Database.database().reference().child(userEmail).queryOrdered(byChild: "imageID").queryEnding(atValue: self.currentID).queryLimited(toLast: 5).observeSingleEvent(of: .value , with: { (snap:DataSnapshot) in
                
                
                let index = self.imagesURL.count
                
                if snap.childrenCount > 0 {
                    
                    let first = snap.children.allObjects.first as! DataSnapshot
                    
                    for s in snap.children.allObjects as! [DataSnapshot]{
                        
                        if s.key != self.currentKey{
                            let item = s.value as! Dictionary<String,AnyObject?>
                            
                            self.getDataFromFirebase(item, index)
                            
                        }
                        
                    }
                    
                    self.currentKey = first.key
                    self.currentID = first.childSnapshot(forPath: "imageID").value as! String
                    
                    self.tableView.reloadData()
                }
                
            })
        }
        }
    
   
    func getDataFromFirebase(_ item : Dictionary<String,AnyObject?>, _ index : Int){
        
        
        let userImageID = item["imageID"] as? String
        
        let userHashtag = item["Hashtag"] as? [String: String]
        
        //print("hashtag")
        //print(GettingFirebaseData.getHashTagDataFromFirebase(userHashtag!).description)
        
        let userLocation = item["location"] as? NSDictionary
        
        //print("location")
        //print(GettingFirebaseData.getLocationDataFromFirebase(userLocation!).description)
        let userDate = item["dateCreated"] as? NSDictionary
        //print("date")
        //print(GettingFirebaseData.getImageCreatedDateFromFirebase(userDate!))
        
        let imageURL = item["imageURL"] as? String
        self.handledDownload(imageURL!, userImageID!, GettingFirebaseData.getImageCreatedDateFromFirebase(userDate!),GettingFirebaseData.getLocationDataFromFirebase(userLocation!), GettingFirebaseData.getHashTagDataFromFirebase(userHashtag!))
        self.imagesURL.insert(imageURL!, at: index)
        
    }
    
    
    //MARK: - IBActions
    func handledDownload(_ newURL: String,_ imageID: String , _ date: Date,_ location: Location,_ hashtags: List<HashTag> ) {
        self.activityIndicator.startAnimating()
        //self.downloadingInProgress = true
        guard let url = URL(string: newURL) else {
            print("Unable to create URL")
            return
        }
        //Ask the download manager to download an image and return it as Data
        DownloadManager.downloadManager.downloadFileAtURL(activityIndicator,
            url,
            
            //This is the code to execute when the data is available
            //(or the network request fails)
            completion: {
                [weak self] //Create a capture group for self to avoid a retain cycle.
                data, error in
                
                //If self is not nil, unwrap it as "strongSelf". If self IS nil, bail out.
                guard let strongSelf = self else {
                    return
                }
                
                if let error = error {
                    print("download failed. message = \(error.localizedDescription)")
                    self?.activityIndicator.stopAnimating()
                    return
                }

                
                guard let data = data else {
                    print("Data is nil!")
                    self?.activityIndicator.stopAnimating()
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    print("Unable to load image from data")
                    self?.activityIndicator.stopAnimating()
                    return
                }
                
                self?.activityIndicator.startAnimating()
                print("33333")

                self?.imagesArray.append(Image(imageID: imageID, dateCreated: date, image: image, hashTags: hashtags, location: location))

                self?.tableView.reloadData()

                    self?.activityIndicator.stopAnimating()

                
            }
        )
    }
    
    func deleteFirebaseImage(indexPath: IndexPath){
       
        print(self.imagesArray[indexPath.item])
        var userEmail: String = (Auth.auth().currentUser?.email)!
        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child(userEmail).child(self.imagesArray[indexPath.item].getImageID()).setValue(nil){
            error,_  in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        Storage.storage().reference().child(self.imagesArray[indexPath.item].getImageID()+".png").delete { error in
            if error != nil{
                AlertDialog.showAlertMessage(controller: self, title: "Message", message: "Deleted Unsuccessfully", btnTitle: "Ok")
                
            }else{
                AlertDialog.showAlertMessage(controller: self, title: "Message", message: "Deleted Successfully", btnTitle: "Ok")
            }
        }
        self.imagesArray.remove(at: indexPath.item)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        //self.tableView!.reloadData()
        
    }
    
    
    
    func saveDownloadedImage(indexPath: IndexPath){
        
        //to be fixed
        //selectedFolder.addImageToRealm(newImage: self.imagesArray[indexPath.item].getUIImage(), location: self.imagesArray[indexPath.item].getLocation())
            //UtilityService.shared.addImageToDatabase(selectedFolder: selectedFolder, selectedFolderType: self.selectedFolderTypeName, newImage: self.imagesArray[indexPath.item].getUIImage(), location: self.location)
        
        //if realmImage != nil
        //{
            AlertDialog.showAlertMessage(controller: self, title: "Message", message: "Saved Successfully", btnTitle: "Ok")
        //}
        
    }
    

    
    
    
}


extension DownloadListViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if self.imagesArray.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return self.imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! FolderListTableViewCell
        
        //cell.folderListLabel.text = self.folders[indexPath.item].getName()
        //to be fixed
        //cell.folderListImage.image = self.imagesArray[indexPath.item].getUIImage()
        
        return cell
    }

    
}
extension DownloadListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedFolder = self.folders[indexPath.item]
        doneBtn.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("more button tapped")
            self.deleteFirebaseImage(indexPath: index)
        }
        delete.backgroundColor = .red
        
        let save = UITableViewRowAction(style: .normal, title: "Save") { action, index in
            print("favorite button tapped")
            self.saveDownloadedImage(indexPath: index)
            //index.item
        }
        save.backgroundColor = .orange
        
        return [delete, save]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffset - currentOffset <= 40{
            self.fetechData2()
        }
    }
    
    
}

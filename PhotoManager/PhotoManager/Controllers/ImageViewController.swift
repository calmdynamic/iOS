//
//  ImageViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-13.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

protocol PositionControllerDelegate: class {
    func didUpdatePosition(_ newPosition: Location)
}

class ImageViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {

    weak var delegate: PositionControllerDelegate?
    
    let locationMgr = CLLocationManager()
    var location: Location!
    var selectedFolderType: Type!
    var newImage: UIImage!
    var edit:Bool!
    var selectedImage: Image!
    var numOfSelection: Int!
    
    var numOfSuccess: Double!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var hashTagBtn: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var uploadBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    
    var images: [Image]!
    
    let pickerController = UIImagePickerController()
    
    var selectedFolder: Folder!
    let segueIdentfier = "imageDetailSegue"
    let segueIdentfier2 = "downloadSegue"
    let identifier = "imageCell"
    override func viewWillAppear(_ animated: Bool) {
        isEditing = false
        
        locationMgr.stopUpdatingLocation()
        
        
        toolbar.isHidden = true
        

        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", selectedFolderType.getName() )
        
        
        let tempFolders = tempFolderType[0].getFolders().filter("name = %@", selectedFolder.getName() )
        
        self.images = [Image]()
        for i in tempFolders[0].getImages(){
            images.append(i)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        locationMgr.delegate = self
        self.location = Location()
        
        UtilityService.shared.locationChecker(locationMgr: locationMgr, viewController: self)
        
        navigationItem.title = selectedFolder.getName()
        navigationItem.rightBarButtonItem = editButtonItem
        self.edit = false
        pickerController.delegate = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == segueIdentfier{
            let imageDetailVC = segue.destination as! ImageDetailsViewController
            let indexpaths = self.collectionView?.indexPathsForSelectedItems

            self.selectedImage = images[indexpaths![0].item]

            imageDetailVC.image = self.selectedImage

        }

        if segue.identifier == segueIdentfier2{
            let downloadVC = segue.destination as! DownloadListViewController
            //let indexpaths = self.collectionView?.indexPathsForSelectedItems
            downloadVC.selectedFolderType = self.selectedFolderType
            downloadVC.selectedFolder = self.selectedFolder
            downloadVC.location = self.location
            
        }
        

    }
    
    
    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
    

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
            self.tabBarController?.tabBar.isHidden = true
            self.navigationItem.hidesBackButton = true
            self.edit = true
            self.cameraBtn.isEnabled = false
            self.downloadBtn.isEnabled = false
            
        }else{
            self.edit = false
            self.tabBarController?.tabBar.isHidden = false
            self.navigationItem.hidesBackButton = false
            self.cameraBtn.isEnabled = true
            self.downloadBtn.isEnabled = true
            
        }
        collectionView?.allowsMultipleSelection = editing
        toolbar.isHidden = !editing
        
        deleteButton.isEnabled = false
        hashTagBtn.isEnabled = false
        uploadBtn.isEnabled = false
        collectionView.reloadData()
    }
    
    
    @IBAction func addPhoto(_ sender: UIButton) {
       

        if Reachability.isConnectedToNetwork(){
        self.locationMgr.requestWhenInUseAuthorization()
        self.locationMgr.startUpdatingLocation()
        }
        if !UtilityService.shared.cameraChecker(pickerController: pickerController, viewController: self){
            self.addImageForTesting()
            
        }

    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        UtilityService.shared.getLocationDetailedInfo(locationMgr: self.locationMgr, location: self.location)

    }
    
    

    
    func addImageForTesting(){
        let realmImage = UtilityService.shared.addImageForTestingToRealm(selectedFolder: self.selectedFolder, selectedFolderTypeName: self.selectedFolderType.getName(), location: self.location)
        
        self.images.append(realmImage)
        self.collectionView?.reloadData()
        
        if Reachability.isConnectedToNetwork(){
            locationMgr.stopUpdatingLocation()
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let realmImage = UtilityService.shared.addImageToDatabase(selectedFolder: selectedFolder, selectedFolderType: selectedFolderType.getName(), newImage: self.newImage, location: self.location)
        
        self.images.append(realmImage)
        self.collectionView?.reloadData()
        
        if Reachability.isConnectedToNetwork(){
            locationMgr.stopUpdatingLocation()
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("The camera has been closed")
        
    }
    
    
    @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Delete this image?", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
            let indexpaths = self.collectionView?.indexPathsForSelectedItems
            var deletedImages:[Image] = []
            if let indexpaths = indexpaths {
                for item  in indexpaths {
                    self.collectionView?.deselectItem(at: (item), animated: true)
                    
                    let selectedImage = self.images[item.row]
                
                    let realm = try! Realm()
                    try! realm.write {
                        realm.delete(selectedImage.getLocation())
                        realm.delete(selectedImage.getHashTags())
                    }
                    
                  
                    deletedImages.append(selectedImage)
                   
                }
                

                let realm = try! Realm()
                try! realm.write {
                    realm.delete(deletedImages)
                }
                
                let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", self.selectedFolderType.getName() )
                
                
                let tempFolders = tempFolderType[0].getFolders().filter("name = %@", self.selectedFolder.getName() )
                
                self.images = [Image]()
                for i in tempFolders[0].getImages(){
                    self.images.append(i)
                }
                
                self.collectionView!.deleteItems(at: indexpaths)
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
    
    @IBAction func addHashtag(_ sender: UIBarButtonItem) {

        let indexpaths = self.collectionView?.indexPathsForSelectedItems
      
        self.selectedImage = images[indexpaths![0].item]
        
        let currentHashTags = self.selectedImage.getHashTags()
        
        var hashtagsString = ""
        for i in currentHashTags{
            hashtagsString += "\(i.getHashTag()) "
           
        }
        

        let actionSheet = UIAlertController(title: "This image includes the following hashtags:\n \(hashtagsString)", message: nil, preferredStyle: .actionSheet)
        
      
        
         let updateHashtags = UIAlertAction(title: "Update hashtags", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
             let textView = UITextView()
            textView.keyboardType = UIKeyboardType.twitter
            let alertController = UIAlertController(title: "Update hashtags?", message: "Are you sure you want to update this image hashtag?", preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Update", style: .destructive) { (_) in
                
                
                let indexpaths = self.collectionView?.indexPathsForSelectedItems
                if indexpaths!.count == 1 {

                        var tempHashTags = textView.text.components(separatedBy: " ")
                        if(tempHashTags[tempHashTags.count-1]==""){
                            tempHashTags.remove(at: tempHashTags.count-1)
                        }
                        
                        var hashtags: List<HashTag>
                        hashtags = List<HashTag>()
                        var anyProblem: Bool = false
                        var title = ""
                        var numberOfDuplicated = 0
                        for i in tempHashTags{
                            let firstletter = i.prefix(1)
                            if (!firstletter.contains("#")){
                                title = "One or more of your hashtag is missing # that is or are separated by a space"
                                anyProblem = true
                            }
                            
                            if (i == ""){
                                title = "No empty hashtags"
                                anyProblem = true
                            }
                            
                            
                            if (UtilityService.shared.repeatedHashTagFound(self.selectedImage.getHashTags(), i)){
                                numberOfDuplicated += 1
                                title = "The hash tag is already in the image; please do not duplicate any hashtags"
                                if(numberOfDuplicated > self.selectedImage.getHashTags().count){
                                    anyProblem = true
                                }
                            }
                            
                            if(anyProblem){
                                let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                                
                                let cancelAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
                                alert.addAction(cancelAction)
                                self.present(alert, animated: true)
                                return
                            }
                            hashtags.append(HashTag(hashTag: i))
                        }
                    
                        for i in self.selectedImage.getHashTags(){
                            RealmService.shared.delete(i)
                        }

                        RealmService.shared.update(self.selectedImage, with: ["dateCreated": self.selectedImage.getDateCreated(), "imageBinaryData":self.selectedImage.getImageBinaryData(),"hashTags": hashtags])

                }
                }
            
            //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            //adding the action to dialogbox
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
           
            textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let controller = UIViewController()
            
            textView.frame = controller.view.frame
            controller.view.addSubview(textView)
            textView.text = hashtagsString
            alertController.setValue(controller, forKey: "contentViewController")
         
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
            
            
        })
        
        actionSheet.addAction(updateHashtags)
        if numOfSelection != 1{
            updateHashtags.isEnabled = false
        }else{
            updateHashtags.isEnabled = true
        }
        actionSheet.addAction(UIAlertAction(title: "Add a HashTag to Multiple Images", style: .default, handler: {
             (alert: UIAlertAction!) -> Void in
            let alertController = UIAlertController(title: "Add name?", message: "Enter the hashtag name", preferredStyle: .alert)
            
            
            let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
                let newHashtagName = alertController.textFields?[0].text
                
                let indexpaths = self.collectionView?.indexPathsForSelectedItems
               
                
                if let indexpaths = indexpaths {
                    for item  in indexpaths {
                        self.collectionView?.deselectItem(at: (item), animated: true)
                        
                        let image = self.images[item.row]
                        
                        
                        var hashtags: List<HashTag>
                        hashtags = List<HashTag>()
                        
                        for i in image.getHashTags(){
       
                            hashtags.append(HashTag(hashTag: i.getHashTag()))
                        }
                        
                        hashtags.append(HashTag(hashTag: newHashtagName!))
                        
                        for i in image.getHashTags(){
                            RealmService.shared.delete(i)
                        }
                        

                        RealmService.shared.update(image, with: ["dateCreated": image.getDateCreated(), "imageBinaryData":image.getImageBinaryData(),"hashTags": hashtags])
                        

                    }

                }
            }
            
            
            //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            //adding textfields to our dialog box
            
            alertController.addTextField(configurationHandler: { (textField) in
                
                let indexpaths = self.collectionView?.indexPathsForSelectedItems
                for _ in indexpaths!{
                        
                        confirmAction.isEnabled = false
                        
                        textField.placeholder = "Enter a New Hashtag name"
                        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                            
                            let modifiedName = alertController.textFields?[0].text
                             if let indexpaths = indexpaths {
                            for item  in indexpaths {
                                
                                let image = self.images[item.row]
                                if !UtilityService.shared.repeatedHashTagFound(image.getHashTags(), modifiedName) && !(modifiedName?.trimmingCharacters(in: .whitespaces).isEmpty)! && modifiedName?.prefix(1) == "#"{
                                confirmAction.isEnabled = true
                            }else{
                                confirmAction.isEnabled = false
                            }
                                }
                            }
                    }}
            })
            
            
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
            
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    

    func showPregressBarWindow(){
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
    
    
    func uploadMedia(_ okButton: UIButton, _ selectionRemaining: Double, progressBar: UIProgressView, progressPercent: UILabel, selectedImage: Image, completion: @escaping (_ url: String?) -> Void) {
        progressBar.setProgress(0, animated: false)
        let storageRef = Storage.storage().reference().child(selectedImage.getImageID()+".png")
        
        var uploadTask: StorageUploadTask? = nil
        var getURLTask: Void? = nil
        
        getURLTask = storageRef.downloadURL { (url, error) in
            if url != nil{
                completion(url?.absoluteString)
                 self.numOfSuccess = self.numOfSuccess + 1
                progressPercent.text = String(format: "%.2f%%", (100.0 * (self.numOfSuccess / selectionRemaining)))
                
                progressBar.progress = Float(self.numOfSuccess / selectionRemaining)
                
                if self.numOfSuccess == selectionRemaining {
                    okButton.isEnabled = true
                }
            }else{
                
            
        
        uploadTask = storageRef.putData(selectedImage.getImageBinaryData() as Data, metadata: nil, completion: {
            (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                    // your uploaded photo url.
                }
            }
            )
        }
        
            
            
            uploadTask?.observe(.success) { (snapshot) in
            self.numOfSuccess = self.numOfSuccess + 1
            
           // let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            
            
            
            progressPercent.text = String(format: "%.2f%%", (100.0 * (self.numOfSuccess / selectionRemaining)))
            
            progressBar.progress = Float(self.numOfSuccess / selectionRemaining)
            
            if self.numOfSuccess == selectionRemaining {
                okButton.isEnabled = true
            }
        }
    }
    }
    
    func uploadingOperation(_ okButton: UIButton, progressBar: UIProgressView, progressPercent: UILabel){
        self.numOfSuccess = 0
        let ref = Database.database().reference()
        let indexpaths = self.collectionView?.indexPathsForSelectedItems
        var selectionRemaining = 0
        if let indexpaths = indexpaths {
            selectionRemaining = indexpaths.count
            for item  in indexpaths {
                self.collectionView?.deselectItem(at: (item), animated: true)
                let selectedImage = self.images[item.row]
                
                self.uploadMedia(okButton ,Double(selectionRemaining), progressBar: progressBar, progressPercent: progressPercent, selectedImage: selectedImage) { url in
                    if url != nil {
                        
                        //ref.child("user").setValue(selectedImage.getImageID())
                        let calendar = Calendar.current
                        
                        let year = calendar.component(.year, from: selectedImage.getDateCreated())
                        let month = calendar.component(.month, from: selectedImage.getDateCreated())
                        let day = calendar.component(.day, from: selectedImage.getDateCreated())
                        let hour = calendar.component(.hour, from: selectedImage.getDateCreated())
                        let minute = calendar.component(.minute, from: selectedImage.getDateCreated())
                        let second = calendar.component(.second, from: selectedImage.getDateCreated())
                        
                       print("email")
                        
                        var userEmail: String = (Auth.auth().currentUser?.email)!
                        userEmail = userEmail.replacingOccurrences(of: ".", with: ",")
                        
                        ref.child(userEmail).child(selectedImage.getImageID()).setValue(
                            [
                            "imageID"      : selectedImage.getImageID(),
                            "dateCreated"    :
                                ["year": year,
                                 "month": month,
                                 "day": day,
                                 "hour": hour,
                                 "minute": minute,
                                  "second": second] as Any,
                            
                            "location"     :
                                ["locationID":selectedImage.getLocation().getLocationID(),
                                 "latitude":selectedImage.getLocation().getLatitude(),
                                 "longtitude":selectedImage.getLocation().getLongtitude(),
                                 "street":selectedImage.getLocation().getStreet(),
                                 "city":selectedImage.getLocation().getCity(),
                                 "province":selectedImage.getLocation().getProvince()
                                    ] as Any,
                            "Hashtag"       : selectedImage.getHashTagDictionary(),
                            "imageURL" : url!
                            ])
                    }
                }
                
                
                
                self.initButtons()
                
            }
        }else{
            print("no image selected")
        }
    }
    
    @IBAction func uploadImage(_ sender: UIBarButtonItem) {
        if Reachability.isConnectedToNetwork(){
         
            if Auth.auth().currentUser != nil{
        
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Upload this image?", message: "Are you sure you want to upload this image?", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Upload", style: .default) { (_) in
            self.showPregressBarWindow()
            //self.progressBar.setProgress(0, animated: false)
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
            }else{
                AlertDialog.showAlertMessage(controller: self, title: "Message", message: "You have not signed in the firebase account; You cannot upload images", btnTitle: "Ok")
                
            }
        }else{
            AlertDialog.showAlertMessage(controller: self, title: "No Networking Message", message: "No Networking Detection", btnTitle: "Ok")
            
        }
        
    }
    
    @IBAction func downloadImage(_ sender: UIBarButtonItem) {
    }
    
    func initButtons(){
        deleteButton.isEnabled = false
        hashTagBtn.isEnabled = false
        uploadBtn.isEnabled = false
    }
}

extension ImageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! ImageCollectionViewCell
        
        let image = UIImage(data: (self.images[indexPath.item].getImageBinaryData()) as Data, scale:1.0)
        
        cell.photoImage.image = image
        
        if edit{
            cell.uncheckedBoxImage.isHidden = false
        }else{
            cell.uncheckedBoxImage.isHidden = true
        }
        
        return cell
    }
}

extension ImageViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.numOfSelection = self.collectionView?.indexPathsForSelectedItems?.count
        if numOfSelection == 0{
            deleteButton.isEnabled = false
            hashTagBtn.isEnabled = false
            uploadBtn.isEnabled = false
            self.cameraBtn.isEnabled = true
            self.downloadBtn.isEnabled = true
        }else if numOfSelection == 1{
            deleteButton.isEnabled = true
            hashTagBtn.isEnabled = true
            uploadBtn.isEnabled = true
            self.cameraBtn.isEnabled = false
            self.downloadBtn.isEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        self.numOfSelection = self.collectionView?.indexPathsForSelectedItems?.count
        if numOfSelection == 0{
            deleteButton.isEnabled = false
            hashTagBtn.isEnabled = false
            uploadBtn.isEnabled = false
        }else if numOfSelection == 1{
            deleteButton.isEnabled = true
            hashTagBtn.isEnabled = true
            uploadBtn.isEnabled = true
        }
        
    }
    
}

extension ImageViewController: CustomAlertViewDelegate {
    
    func runProgressBarRunning(progressBar: UIProgressView, progressPercent: UILabel, okButton: UIButton) {
        self.uploadingOperation(okButton, progressBar: progressBar, progressPercent: progressPercent)
    }
}

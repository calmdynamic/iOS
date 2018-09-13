//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit
import FirebaseStorage
class UploadingAlertView: UIViewController {
    
    static let IDENTIFIER = "UploadingAlertView"
    @IBOutlet weak var resumeBtn: UIButton!
    
    @IBOutlet weak var stopBtn: UIButton!
    var numOfSuccess: Double = 0.0
    var uploadTask: StorageUploadTask = StorageUploadTask()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var progressPercent: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
 //   var delegate: CustomAlertViewDelegate?
    //let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        self.progressBar.setProgress(0, animated: false)
        //delegate?.runProgressBarRunning()
        self.okButton.isEnabled = false
        self.stopBtn.isEnabled = true
        self.resumeBtn.isEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
       
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    

    func initailizedView(controller: UIViewController){
        //show customAlert Window
        //controller.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! UploadingAlertView
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //self.customAlert.delegate = self
        controller.present(self, animated: true, completion: nil)
    }
    
    

    
    
    func uploadMedia(_ selectionRemaining: Double, selectedImage: Image, completion: @escaping (_ url: String?) -> Void) {
        progressBar.setProgress(0, animated: false)
        let storageRef = Storage.storage().reference().child(selectedImage.getImageID()+".png")
        
        storageRef.downloadURL { (url, error) in
            if url != nil{
                completion(url?.absoluteString)
                self.numOfSuccess = self.numOfSuccess + 1
                self.progressPercent.text = String(format: "%.2f%%", (100.0 * (self.numOfSuccess / selectionRemaining)))
                
                self.progressBar.progress = Float(self.numOfSuccess / selectionRemaining)
                
                if self.numOfSuccess == selectionRemaining {
                    self.okButton.isEnabled = true
                }
            }else{
                
                //self.customAlert.putData(storageRef: storageRef, selectedImage: selectedImage, completion: completion)
                
                //to be fixed
//                self.uploadTask = storageRef.putData(selectedImage.getImageBinaryData() as Data, metadata: nil, completion: {
//                                    (metadata, error) in
//                                    if error != nil {
//                                        print("error")
//                                        //self.failedToUpload = true
//                                        completion(nil)
//                                    } else {
//
//                                        completion((metadata?.downloadURL()?.absoluteString)!)
//                                        // your uploaded photo url.
//                                    }
//                                }
//
//
//                )
            }
            
            
            self.uploadTask.observe(.success) { (snapshot) in
                self.numOfSuccess = self.numOfSuccess + 1
                
                self.progressPercent.text = String(format: "%.2f%%", (100.0 * (self.numOfSuccess / selectionRemaining)))
                
                self.progressBar.progress = Float(self.numOfSuccess / selectionRemaining)
                
                if self.numOfSuccess == selectionRemaining {
                    self.okButton.isEnabled = true
                    self.resumeBtn.isEnabled = false
                    self.stopBtn.isEnabled = false
                }
                
                
            }
            
        }
    }
    
    
    func uploadingOperation(collectionView: UICollectionView, selectedFolder: Folder, deletedButton: UIBarButtonItem, hashTagBtn: UIBarButtonItem, uploadBtn: UIBarButtonItem){
        //self.numOfSuccess = 0
        let indexpaths = collectionView.indexPathsForSelectedItems
        var selectionRemaining = 0
        if let indexpaths = indexpaths {
            selectionRemaining = indexpaths.count
            for item  in indexpaths {
                collectionView.deselectItem(at: (item), animated: true)
                let selectedImage = selectedFolder.getImageArray()[item.row]
                
                self.uploadMedia(Double(selectionRemaining), selectedImage: selectedImage) { (url) in
                    if url != nil {
                        
                        selectedImage.uploadImageToFirebase(url: url)
                    }else{
                        
                        
                        AlertDialog.showAlertMessage(controller: self, title: "Failure Message", message: "Failed to upload; ensure you checked if you login or any network issues", btnTitle: "Ok", handler: { (_) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        
                    }
                }
                
                ToolBarService.initButtons(deleteButton: deletedButton, hashTagBtn: hashTagBtn, uploadBtn: uploadBtn)
                
            }
        }else{
            print("no image selected")
        }
    }
    
    
    @IBAction func stopUploading(_ sender: Any) {
        self.okButton.isEnabled = true
        self.stopBtn.isEnabled = false
        self.resumeBtn.isEnabled = true
        
        self.uploadTask.pause()
        
    }
    
    
    
    @IBAction func resumeUploading(_ sender: Any) {
        self.okButton.isEnabled = false
        self.stopBtn.isEnabled = true
        self.resumeBtn.isEnabled = false
        
        self.uploadTask.resume()
    }
    
    @IBAction func tapOkBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

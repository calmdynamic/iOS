//
//  UploadingService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-15.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
class UploadingService{
    
    private static var numOfSuccess : Double = 0
    private static var uploadTask: StorageUploadTask = StorageUploadTask()

    public static func uploadMedia(progressBar: UIProgressView, resumeBtn: UIButton, stopBtn: UIButton, okButton: UIButton, progressPercent: UILabel, selectionRemaining: Double, selectedImage: Image, completion: @escaping (_ url: String?) -> Void) {
        progressBar.setProgress(0, animated: false)
        let storageRef = Storage.storage().reference().child(selectedImage.getImageID()+".png")
        
        storageRef.downloadURL { (url, error) in
            if url != nil{
                completion(url?.absoluteString)
                UploadingService.performIfUploadingTheSameImage(selectionRemaining: selectionRemaining, progressPercent: progressPercent, resumeBtn: resumeBtn, stopBtn: stopBtn, okButton: okButton, progressBar: progressBar)
            }else{
                uploadTask = storageRef.putData(selectedImage.getImageBinaryData() as Data, metadata: nil, completion: {
                    (metadata, error) in
                    if error != nil {
                        print("error")
                        //self.failedToUpload = true
                        completion(nil)
                    } else {
                        
                        completion((metadata?.downloadURL()?.absoluteString)!)
                        // your uploaded photo url.
                    }
                }
                )
            }
            
            
            UploadingService.observeProgressBar(progressPercent: progressPercent, progressBar: progressBar, resumeBtn: resumeBtn, stopBtn: stopBtn, okBtn: okButton)
            UploadingService.observeSuccessUploadTask(selectionRemaining: selectionRemaining, progressPercent: progressPercent, resumeBtn: resumeBtn, stopBtn: stopBtn, okButton: okButton, progressBar: progressBar)
            
        }
        
        
    }
 
    
    public static func stopUploadingTask(okButton: UIButton, stopBtn: UIButton, resumeBtn: UIButton){
        okButton.isEnabled = true
        stopBtn.isEnabled = false
        resumeBtn.isEnabled = true
        
        self.uploadTask.pause()
    }
    
    public static func restartUploadingTask(okButton: UIButton, stopBtn: UIButton, resumeBtn: UIButton){
        okButton.isEnabled = false
        stopBtn.isEnabled = true
        resumeBtn.isEnabled = false
        
        self.uploadTask.resume()
    }
    
    public static func initNumOfSuccess(){
        self.numOfSuccess = 0
    }
    
    public static func observeSuccessUploadTask(selectionRemaining: Double, progressPercent: UILabel, resumeBtn: UIButton, stopBtn: UIButton, okButton: UIButton, progressBar: UIProgressView){
        uploadTask.observe(.success) { (snapshot) in
            
            UploadingService.numOfSuccess = self.numOfSuccess + 1
            
            progressPercent.text = String(format: "%.2f%%", (100.0 * (numOfSuccess / selectionRemaining)))
            
            progressBar.progress = Float(100)
            
            UploadingService.initButtonWhenCompletelyUploading(selectionRemaining: selectionRemaining, progressPercent: progressPercent, numOfSuccess: self.numOfSuccess, resumeBtn: resumeBtn, stopBtn: stopBtn, okButton: okButton)
        }
    }
    
    
    public static func observeProgressBar(progressPercent: UILabel, progressBar: UIProgressView, resumeBtn: UIButton, stopBtn: UIButton, okBtn: UIButton){
        print("progress...")
        uploadTask.observe(.progress) { (snapshot) in
            // Download reported progress
            
            progressPercent.text = String(format: "%.2f%%",  (100.0 * Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount)))
            
            progressBar.progress = Float( Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount))
            
            UploadingService.initButtonWhenAlmostDone(progressPercent: progressPercent, resumeBtn: resumeBtn, stopBtn: stopBtn, okButton: okBtn)
        }
        
        
    }
    
    
    public static func performIfUploadingTheSameImage(selectionRemaining: Double, progressPercent: UILabel, resumeBtn: UIButton, stopBtn: UIButton, okButton: UIButton, progressBar: UIProgressView){
        numOfSuccess = numOfSuccess + 1
        progressPercent.text = String(format: "%.2f%%", (100.0 * (numOfSuccess / selectionRemaining)))
        
        progressBar.progress = Float(numOfSuccess / selectionRemaining)
        UploadingService.observeProgressBar(progressPercent: progressPercent, progressBar: progressBar, resumeBtn: resumeBtn, stopBtn: stopBtn, okBtn: okButton)
        UploadingService.initButtonWhenCompletelyUploading(selectionRemaining: selectionRemaining, progressPercent: progressPercent, numOfSuccess: numOfSuccess, resumeBtn: resumeBtn, stopBtn: stopBtn, okButton: okButton)
    }
    
    public static func initButtonWhenAlmostDone(progressPercent: UILabel, resumeBtn: UIButton, stopBtn: UIButton, okButton: UIButton){
        if progressPercent.text == "100.00%"{
            resumeBtn.isEnabled = false
            stopBtn.isEnabled = false
            okButton.isEnabled = true
            progressPercent.text = "Finished"
            self.numOfSuccess = 0
        }
    }

    public static func initButtonWhenCompletelyUploading(selectionRemaining: Double, progressPercent: UILabel, numOfSuccess: Double, resumeBtn: UIButton, stopBtn: UIButton, okButton: UIButton){
        if numOfSuccess == selectionRemaining {
            resumeBtn.isEnabled = false
            stopBtn.isEnabled = false
            okButton.isEnabled = true
            progressPercent.text = "Finished"
            self.numOfSuccess = 0
        }
    }

    public static func uploadImageToFirebase(controller: UIViewController, currentIndex: Int, uploadingAlertView: UploadingOneImageView, selectedFolder: Folder){
        if Reachability.isConnectedToNetwork(){
            if Auth.auth().currentUser != nil{
                AlertDialog.showAlertMessage(controller: controller, title: "", message: "Are you sure you want to upload this image?", leftBtnTitle: "Cancel", rightBtnTitle: "Upload", handler: { (_) in
                    uploadingAlertView.initailizedView(controller: controller)
                    uploadingAlertView.uploadOndImageOperation(selectedImage: selectedFolder.getImageArray()[currentIndex])
                })
                
            }else{
                AlertDialog.showAlertMessage(controller: controller, title: "Error", message: "You have not signed in your account; you cannot upload images", btnTitle: "Ok")
                
            }
        }else{
            AlertDialog.showAlertMessage(controller: controller, title: "Error", message: "No internet connection found", btnTitle: "Ok")
        }
    }
}




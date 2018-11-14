//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit
class UploadingOneImageView: UIViewController {
    
    static let IDENTIFIER = "UploadingOneTaskView"
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var progressPercent: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        self.progressBar.setProgress(0, animated: false)
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
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        controller.present(self, animated: true, completion: nil)
    }
    
    
    func uploadOndImageOperation(selectedImage: Image){
        
        UploadingService.uploadMedia(progressBar: self.progressBar, resumeBtn: self.resumeBtn, stopBtn: self.stopBtn, okButton: self.okButton, progressPercent: self.progressPercent, selectionRemaining: Double(1.0), selectedImage: selectedImage) { (url) in
            if url != nil {
                selectedImage.uploadImageToFirebase(url: url)
            }else{
                AlertDialog.showAlertMessage(controller: self, title: "Error", message: "Failed to upload. Check your internet connection and/or sign in.", btnTitle: "Ok", handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            }
        }
    }
    
    @IBAction func stopUploading(_ sender: Any) {
        UploadingService.stopUploadingTask(okButton: self.okButton, stopBtn: self.stopBtn, resumeBtn: self.resumeBtn)
    }
    
    @IBAction func resumeUploading(_ sender: Any) {
        UploadingService.restartUploadingTask(okButton: self.okButton, stopBtn: self.stopBtn, resumeBtn: self.resumeBtn)
    }
    
    @IBAction func tapOkBtn(_ sender: Any) {
        UploadingService.initNumOfSuccess()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

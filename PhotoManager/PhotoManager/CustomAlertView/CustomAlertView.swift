//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var progressPercent: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var delegate: CustomAlertViewDelegate?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        self.progressBar.setProgress(0, animated: false)
        delegate?.runProgressBarRunning(progressBar: self.progressBar, progressPercent: self.progressPercent, okButton: self.okButton)
        self.okButton.isEnabled = false
        
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
    

    
    
    @IBAction func tapOkBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

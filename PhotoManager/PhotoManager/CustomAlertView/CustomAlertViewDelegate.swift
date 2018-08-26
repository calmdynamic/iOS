//
//  CustomAlertViewDelegate.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit
protocol CustomAlertViewDelegate: class {
    
    func runProgressBarRunning(progressBar: UIProgressView, progressPercent: UILabel, okButton: UIButton)
}

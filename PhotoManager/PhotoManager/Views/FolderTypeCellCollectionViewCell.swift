//
//  FolderTypeCellCollectionViewCell.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-12.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class FolderTypeCellCollectionViewCell: UICollectionViewCell {
    static let IDENTIFIER = "folderTypeCell"
    var checkedCell: Bool!
    var isEditing: Bool!
    @IBOutlet weak var folderTypeImage: UIImageView!
    @IBOutlet weak var folderTypeLabel: UILabel!
    @IBOutlet weak var uncheckedBoxImage: UIImageView!
    @IBOutlet weak var numOfFolders: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkedCell = false
        self.isEditing = false
    }
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.5 : 1.0
            uncheckedBoxImage.image = isSelected ? #imageLiteral(resourceName: "boxCheckedIconForImage") : #imageLiteral(resourceName: "boxUncheckedIconForImage")
            
        }
    }
    
    
    
    
    func cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: Bool){
        if isEditing{
            if folderTypeLabel.text == "Default"{
                uncheckedBoxImage.isHidden = true
                isUserInteractionEnabled = false
            }else{
                uncheckedBoxImage.isHidden = false
                isUserInteractionEnabled = true
            }
        }else{
            isUserInteractionEnabled = true
            uncheckedBoxImage.isHidden = true
            
        }
    }
    
}

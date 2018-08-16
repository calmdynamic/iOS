//
//  ImageCollectionViewCell.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-13.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var checkedCell: Bool!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var uncheckedBoxImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkedCell = false
        
    }
    
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.5 : 1.0
            uncheckedBoxImage.image = isSelected ? #imageLiteral(resourceName: "boxCheckedIconForImage") : #imageLiteral(resourceName: "boxUncheckedIconForImage")
            
        }
    }
    
    var isEditing: Bool = false{
        didSet{
            uncheckedBoxImage!.isHidden = !isEditing
        }
    }
}

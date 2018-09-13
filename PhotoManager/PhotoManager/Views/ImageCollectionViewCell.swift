//
//  ImageCollectionViewCell.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-13.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import PinterestLayout

class ImageCollectionViewCell: UICollectionViewCell {
    static let IDENTIFIER = "imageCell"
    var checkedCell: Bool!
    var isEditing: Bool!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var uncheckedBoxImage: UIImageView!

    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkedCell = false
        self.isEditing = false
        
        photoImage.layer.cornerRadius = 8.0
        photoImage.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.5 : 1.0
            uncheckedBoxImage.image = isSelected ? #imageLiteral(resourceName: "boxCheckedIconForImage") : #imageLiteral(resourceName: "boxUncheckedIconForImage")
            
        }
    }
    
    
    func cellImageWhenSettingPropertyAndScrollingRecreating(isEditing: Bool){
        if isEditing{
            uncheckedBoxImage.isHidden = false
            
        }else{
            
            uncheckedBoxImage.isHidden = true
            
        }
        
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            //change image view height by changing its constraint
            imageViewHeightLayoutConstraint.constant = attributes.imageHeight
        }
    }
    
}

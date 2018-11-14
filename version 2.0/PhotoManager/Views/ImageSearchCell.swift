//
//  ImageSearchCell.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-15.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import PinterestLayout

class ImageSearchCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        photoImage.layer.cornerRadius = 8.0
        photoImage.clipsToBounds = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            //change image view height by changing its constraint
            imageViewHeightLayoutConstraint.constant = attributes.imageHeight
        }
    }
}

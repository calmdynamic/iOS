//
//  FolderTypeCellCollectionViewCell.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-12.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class FolderTypeCellCollectionViewCell: UICollectionViewCell {
    var checkedCell: Bool!
    @IBOutlet weak var folderTypeImage: UIImageView!
    @IBOutlet weak var folderTypeLabel: UILabel!
    @IBOutlet weak var uncheckedBoxImage: UIImageView!
    @IBOutlet weak var numOfFolders: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkedCell = false
    }
    override var isSelected: Bool {
        didSet {
            alpha = isSelected ? 0.5 : 1.0
            uncheckedBoxImage.image = isSelected ? #imageLiteral(resourceName: "tick-check-box-hi") : #imageLiteral(resourceName: "checkbox-unchecked-hi")
            
        }
    }
    var isEditing: Bool = false{
        didSet{
            uncheckedBoxImage!.isHidden = !isEditing
        }
    }
}

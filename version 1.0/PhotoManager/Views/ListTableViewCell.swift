//
//  FolderTypeListTableViewCell.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-22.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
    
    @IBOutlet weak var listImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

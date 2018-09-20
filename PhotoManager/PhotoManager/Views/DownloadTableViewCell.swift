//
//  DownloadTableViewCell.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-15.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {

    static let IDENTIFIER = "downloadListCell"
    @IBOutlet weak var imageTitle: UILabel!
 
    @IBOutlet weak var uploadedTime: UILabel!
    
    @IBOutlet weak var imagePicture: UIImageView!
    
   
    @IBOutlet weak var dateAndTime: UILabel!
    
    @IBOutlet weak var locationText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse(){
        super.prepareForReuse()
        imagePicture.sd_cancelCurrentImageLoad()
        //self.imagePicture = nil
    }

}

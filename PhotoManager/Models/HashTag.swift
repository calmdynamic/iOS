//
//  HashTag.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift
class HashTag: Object{
    @objc private dynamic var hashTagID: String = UUID().uuidString
    @objc private dynamic var hashTag: String = ""
   
    override class func primaryKey() -> String?{
        return "hashTagID"
    }
    
    convenience init(hashTag: String){
        self.init()
        self.hashTag = hashTag
    }
    
    public func setHashTag(_ hashTag: String){
        self.hashTag = hashTag
    }
    
    public func getHashTagID() -> String{
        return self.hashTagID
    }
    
    public func getHashTag() -> String{
        return self.hashTag
    }
    
 
}


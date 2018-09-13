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
    
    public func isHashtagEmpty() -> Bool{
        if (self.hashTag == "#".trimmingCharacters(in: .whitespaces)){
            //title = "No empty hashtags"
            return true
        }
        return false
    }
    
    public func isHashtagContainHashSymbol() -> Bool{
        let firstletter = self.hashTag.prefix(1)
        if (!firstletter.contains("#")){
            //title = "One or more of your hashtag is missing # that is or are separated by a space"
             return true
        }
        return false
    }
    
 
}


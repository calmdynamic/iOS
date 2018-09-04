//
//  TextFieldService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-02.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
class StringService{
    public static func formattedTextField(textField: String)->String{
        let text = textField
        
        let first = String((text.prefix(1))).capitalized
        let other = String((text.dropFirst())).lowercased()
        
        return first + other
    }
    
    public static func isTextEmpty(_ textString: String?) -> Bool{
        if let tempString = textString?.trimmingCharacters(in: .whitespaces) {
            if tempString.trimmingCharacters(in: .whitespaces).isEmpty{
                return true
            }
            
        }
        
        return false
    }
    
}

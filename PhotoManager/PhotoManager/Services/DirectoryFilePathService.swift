//
//  DirectoryFilePathService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-23.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation

class DirectoryFilePathService{
    
    public static func checkIfAppIsReinstalled()-> Bool{
        print("11")
        let images = RealmService.shared.realm.objects(Image.self)

        if images.count > 0 {
        let oldImagePathArr = images[0].getImagePath().components(separatedBy: "/")
        var oldImagePathCode = ""
        
        print("22")
        for i in 0...oldImagePathArr.count-1{
            if oldImagePathArr[i] == "Application"{
                oldImagePathCode = oldImagePathArr[i+1]
            }
        }

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let newFullFilePath = (documentsDirectory as NSString)
        let newImagePathArr = newFullFilePath.components(separatedBy: "/")
        var newImagePathCode = ""
        
        for i in 0...newImagePathArr.count-1{
            if newImagePathArr[i] == "Application"{
                newImagePathCode = newImagePathArr[i+1]
            }
        }
        
        if newImagePathCode != oldImagePathCode{
            return true
        }
        }
        return false
    }
    
    public static func changeOldImageFilePathToNewFilePath(){
        
        let images = RealmService.shared.realm.objects(Image.self)
        var oldImagePath = [String]()
        var fileName = [String]()
        for i in images{
            oldImagePath.append(i.getImagePath() as String)
        }
        
        for i in oldImagePath{
            let oldImagePathArr = i.components(separatedBy: "/")
            fileName.append(oldImagePathArr[oldImagePathArr.count-1])
        }

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let fullFilePath = (documentsDirectory as NSString)
        
        
        var newImagePath = [String]()
        
        for i in fileName{
            
            let currentFilenamePath = (fullFilePath as NSString).appendingPathComponent(i)
            newImagePath.append(currentFilenamePath)
            
        }
        
        for i in 0...images.count-1{
            let oldImagePathArr = images[i].getImagePath().components(separatedBy: "/")
            if oldImagePathArr[oldImagePathArr.count-1] == fileName[i]{

                images[i].setImagePath(newImagePath[i] as NSString)
                
                
            }
        }

    }
}

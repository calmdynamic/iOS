//
//  DemoDataService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-11.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation

class DemoDataService{
    
    
    public static func dummyData(){
        let type: TypeList = TypeList()
        type.createTypeData()
        
        for i in type.getFolderTypes(){
            if i.getName() == "Sports"{
                i.createSportFolders()
                for j in i.getFolders(){
                    if j.getName() == "Olympics"{
                        j.createOlympicData()
                    }
                }
            }
            if i.getName() == "Mountains"{
                i.createMountainFolders()
                for j in i.getFolders(){
                    if j.getName() == "Rocky"{
                        j.createRockeyMountainData()
                    }
                    if j.getName() == "Grouse"{
                        j.createGrouseMountainData()
                    }
                }
            }
            if i.getName() == "Default"{
                i.createDefaultFolder()
                for j in i.getFolders(){
                    if j.getName() == "Default"{
                        j.createDefaultData()
                    }
                }
            }
        }
    }
}

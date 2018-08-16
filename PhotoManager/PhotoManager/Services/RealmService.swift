//
//  RealmService.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-02-27.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService{
    
    private init(){}
    static let shared = RealmService()
    
    var realm = try! Realm()
    
   
    
    func create<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.add(object)
            }
        }catch{
            post(error)
        }
    }
    //not good for oo design but ok for the final project??
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        do{
            try realm.write {
                for(key, value) in dictionary{
                    object.setValue(value, forKey: key)
                }
            }
        }catch{
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T){
        do{
            try realm.write {
                realm.delete(object)
            }
        }catch{
            post(error)
        }
    }
    
    func deleteAll(){
        do{
            try realm.write {
                realm.deleteAll()
            }
        }catch{
            post(error)
        }
    }
    
    func post(_ error: Error){
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completetion: @escaping (Error?) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completetion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}

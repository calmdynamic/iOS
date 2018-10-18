//
//  HashTagListViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-21.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {

    
    var selectedLocation: [String] = [String]()
    var numOfSelection: Int = 0

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    var locations: [String] = [String]()
    let identifier = "listCell"
    
    override func viewWillAppear(_ animated: Bool) {
        let tempLocations = RealmService.shared.realm.objects(Location.self)
        
        var locationSet: Set<String> = Set<String>()
        
        for i in tempLocations{
            if i.getCity() != "" && i.getProvince() != ""{
            locationSet.insert("@" + i.getCity() + ", " + i.getProvince())
            }
        }
        
        for i in locationSet{

                self.locations.append(i)
            
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.isEnabled = false
        navigationItem.title = "Location List"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
}


extension LocationListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! ListTableViewCell
        
        cell.listLabel.text = self.locations[indexPath.item]
        cell.listImage.image = #imageLiteral(resourceName: "locationForImage")
        
        return cell
    }
    
}

extension LocationListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.selectedLocation = [String]()
        
        self.numOfSelection = self.numOfSelection + 1
        
        if self.numOfSelection <= 0{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
        
        let indexpaths = self.tableView.indexPathsForSelectedRows
        
        for i in indexpaths!{
            self.selectedLocation.append(self.locations[i.item])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         self.selectedLocation = [String]()

        self.numOfSelection = self.numOfSelection - 1

        if self.numOfSelection <= 0{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
        
        let indexpaths = self.tableView.indexPathsForSelectedRows
        
        for i in indexpaths!{
            self.selectedLocation.append(self.locations[i.item])
        }
    }
    
    
    
}

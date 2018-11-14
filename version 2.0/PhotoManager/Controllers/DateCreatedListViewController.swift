//
//  DateCreatedListViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-24.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class DateCreatedListViewController: UIViewController {

    var selectedCreatedDate: [String] = [String]()
    var numOfSelection: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var createdDates: [String] = [String]()
    let identifier = "listCell"
    
    override func viewWillAppear(_ animated: Bool) {
        let tempImages = RealmService.shared.realm.objects(Image.self)
        
        var dateSet: Set<String> = Set<String>()
        
        for i in tempImages{
            if i.getImageCreatedDateString() != ""{
                dateSet.insert("&" + i.getImageCreatedDateString() + " ")
            }
        }
        
        for i in dateSet{
            
            self.createdDates.append(i)
            
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.isEnabled = false
        navigationItem.title = "Date of Creation List"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension DateCreatedListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.createdDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! ListTableViewCell
        
        cell.listLabel.text = self.createdDates[indexPath.item]
        cell.listImage.image = #imageLiteral(resourceName: "calenderForToolbar")
        
        return cell
    }
    
}


extension DateCreatedListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCreatedDate = [String]()
        
        self.numOfSelection = self.numOfSelection + 1
        
        if self.numOfSelection <= 0{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
        
        let indexpaths = self.tableView.indexPathsForSelectedRows
        
        if indexpaths != nil{
            for i in indexpaths!{
                self.selectedCreatedDate.append(self.createdDates[i.item])
                print("p")
                print(self.selectedCreatedDate)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        self.selectedCreatedDate = [String]()
        
        self.numOfSelection = self.numOfSelection - 1
        
        if self.numOfSelection <= 0{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
        
        let indexpaths = self.tableView.indexPathsForSelectedRows
        
        if indexpaths != nil{
            for i in indexpaths!{
                self.selectedCreatedDate.append(self.createdDates[i.item])
                print("p")
                print(self.selectedCreatedDate)
            }
        }
    }
    
    
    
}

//
//  LocationListViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-23.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class HashtagListViewController: UIViewController {

    var selectedHashTag: [String] = [String]()
    var numOfSelection: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    var hashtags: [String] = [String]()
    let identifier = "listCell"
    
    override func viewWillAppear(_ animated: Bool) {
        let tempHashTags = RealmService.shared.realm.objects(HashTag.self)
        
        var hashtagSet: Set<String> = Set<String>()
        
        for i in tempHashTags{
            hashtagSet.insert(i.getHashTag())
        }
        
        for i in hashtagSet{
            self.hashtags.append(i)
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.isEnabled = false
        navigationItem.title = "Hashtag List"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension HashtagListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hashtags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! ListTableViewCell
        
        cell.listLabel.text = self.hashtags[indexPath.item]
        cell.listImage.image = #imageLiteral(resourceName: "hashTagIconForToolbar")
        
        return cell
    }
    
}

extension HashtagListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedHashTag = [String]()
        
        self.numOfSelection = self.numOfSelection + 1
        
        if self.numOfSelection <= 0{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
        
        let indexpaths = self.tableView.indexPathsForSelectedRows
        
        for i in indexpaths!{
            self.selectedHashTag.append(self.hashtags[i.item])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedHashTag = [String]()
        
        self.numOfSelection = self.numOfSelection - 1
        
        if self.numOfSelection <= 0{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
        
        let indexpaths = self.tableView.indexPathsForSelectedRows
        
        for i in indexpaths!{
            self.selectedHashTag.append(self.hashtags[i.item])
        }
        
}
}

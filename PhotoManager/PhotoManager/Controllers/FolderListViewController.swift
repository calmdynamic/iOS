//
//  FolderListViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-22.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit

class FolderListViewController: UIViewController {

    var selectedFolderType: Type!
    var selectedFolder: Folder!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var folders: [Folder]!
    let identifier = "listCell"
    var previousControllerName = ""

    override func viewWillAppear(_ animated: Bool) {
       
        let tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", navigationItem.title ?? "")
        
        let tempFolders = tempFolderType[0].getFolders()
        
        folders = [Folder]()
        for i in tempFolders{

            folders.append(i)
 
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.isEnabled = false
        navigationItem.title = selectedFolderType.getName()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FolderListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! ListTableViewCell
        
        cell.listLabel.text = self.folders[indexPath.item].getName()
        cell.listImage.image = #imageLiteral(resourceName: "folder_Details")
        
        return cell
    }
    
    
    
    
}
extension FolderListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFolder = self.folders[indexPath.item]
        doneBtn.isEnabled = true
    }
    
    
}

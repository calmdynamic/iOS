//
//  StatisticsTableViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-24.
//  Updated by Jason Chih-Yuan on 2018-09-19.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import Charts
import RealmSwift


class StatisticsTableViewController: UITableViewController{

    @IBOutlet weak var statisticsTitleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var statisticsPieChartView: PieChartView!
    @IBOutlet weak var folderTypeSaveLocation: UILabel!
    
    var selectedFolderType: String!
    var segueIdentifier = "statFolderListSegue"
    var folderType: TypeList = TypeList()
    
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var found = false
        folderType = TypeList()

        folderType.getFolderTypeDataFromRealm()
        
        for i in folderType.getFolderTypes(){
            if i.getName() == selectedFolderType{
                found = true
                break
            }
        }

        if !found{
            self.folderTypeSaveLocation.text = "Default"
        }
        
        StatisticsService.pieChart(statisticsTitleLabel: self.statisticsTitleLabel, folderType: self.folderType, statisticsPieChartView: self.statisticsPieChartView, selectedFolderTypeSaveLocation: self.folderTypeSaveLocation.text!, noDataAvailableLabel: self.noDataAvailableLabel, segmentedControl: self.segmentedControl)
       
    }

    
    @IBAction func segmentedControlBtn(_ sender: UISegmentedControl) {

        StatisticsService.pieChart(statisticsTitleLabel: self.statisticsTitleLabel, folderType: self.folderType, statisticsPieChartView: self.statisticsPieChartView, selectedFolderTypeSaveLocation: self.folderTypeSaveLocation.text!, noDataAvailableLabel: self.noDataAvailableLabel, segmentedControl: self.segmentedControl)
        
       
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueIdentifier{
            let destViewController = segue.destination as? UINavigationController
            let secondViewcontroller = destViewController?.viewControllers.first as! FolderTypeListViewController
            secondViewcontroller.isFolderTypeOnly = true
        }
    }
    
    // remove the section when you click the first button
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1{
            if segmentedControl.selectedSegmentIndex == 0 ||
                segmentedControl.selectedSegmentIndex == 1{
                return 0
            }else{
                return 43.5
            }
        }
        if indexPath.section == 2{
            if segmentedControl.selectedSegmentIndex == 0 ||
                segmentedControl.selectedSegmentIndex == 1{
                return 476
            }else{
                return 376
            }
        }
        return 43.5
    }

    @IBAction func didUnwindFromFolderTypeList(segue: UIStoryboardSegue){
        let folderListType = segue.source as! FolderTypeListViewController
        self.selectedFolderType = folderListType.selectedFolderType.getName()
        self.folderTypeSaveLocation.text = selectedFolderType

    }

}

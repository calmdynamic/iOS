//
//  StatisticsTableViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-24.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

protocol GetChartData{
    func getChartData(with dataPoints: [String], values: [String])
    
    var folderTypes: [String] {get set}
    var folders: [String] {get set}
}
class StatisticsTableViewController: UITableViewController, GetChartData{

    @IBOutlet weak var cell1: UITableViewCell!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var statisticsView: UIView!

    @IBOutlet weak var folderTypeSaveLocation: UILabel!
    
    var selectedFolderType: String!
    var selectedFolderName: String!
    var segueIdentifier = "statFolderListSegue"
    var folderTypes = [String]()
    var folders = [String]()
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()


        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        folderTypes.removeAll()
        folders.removeAll()

        populateChartData()
        
        barChart()
        
    }
    
    
    
    
    
    @IBAction func segmentedControlBtn(_ sender: UISegmentedControl) {
        self.statisticsView.setNeedsDisplay()
        
        folderTypes.removeAll()
        folders.removeAll()
        
        populateChartData()
        barChart()
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueIdentifier{
            let destViewController = segue.destination as? UINavigationController
            let secondViewcontroller = destViewController?.viewControllers.first as! FolderTypeListViewController
            secondViewcontroller.isFolderTypeOnly = true
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1{
            if segmentedControl.selectedSegmentIndex == 0{
                return 0
            }else{
                return 43.5
            }
        }
        if indexPath.section == 2{
            if segmentedControl.selectedSegmentIndex == 0{
                return 476
            }else{
                return 376
            }
        }
        return 43.5
    }
    


    func populateChartData(){
        
        
        if segmentedControl.selectedSegmentIndex == 0{
            let tempFolderTypes = RealmService.shared.realm.objects(Type.self).sorted(byKeyPath: "dateCreated", ascending: true)

            for i in tempFolderTypes{
                self.folderTypes.append(i.getName())
                self.folders.append("\(i.getFolderCount())")
            }
            
            self.getChartData(with: folderTypes, values: folders)
        }else{

            var tempFolderType: Results<Type>?
            
            tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", folderTypeSaveLocation.text ?? "Default")

            
            for j in tempFolderType![0].getFolders(){
                self.folderTypes.append(j.getName())//execute one time
                self.folders.append("\(j.getImageCount())")
            }
            
            
            self.getChartData(with: folderTypes, values: folders)
            
        }
    }
    
    func barChart(){

        if(segmentedControl.selectedSegmentIndex == 0){
            let barChart = BarChart(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
            barChart.delegate = self
            if let removedView = self.view.viewWithTag(200){
                removedView.removeFromSuperview()
            }
            
            barChart.tag = 100
             self.statisticsView.addSubview(barChart)
            
        }else{
            let barChart = BarChart(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height-100))
            barChart.backgroundColor = UIColor.blue
            
            barChart.delegate = self
            if let removedView = self.view.viewWithTag(100){
                removedView.removeFromSuperview()
            }
            
            barChart.tag = 200
            
            self.statisticsView.addSubview(barChart)
            
        }

    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.folderTypes = dataPoints
        self.folders = values
    }
    
    @IBAction func didUnwindFromFolderTypeList(segue: UIStoryboardSegue){
        let folderListType = segue.source as! FolderTypeListViewController
        self.selectedFolderType = folderListType.selectedFolderType.getName()
        self.folderTypeSaveLocation.text = selectedFolderType
        
    }
}

public class ChartFormatter: NSObject, IAxisValueFormatter{
    var workoutDuration = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return workoutDuration[Int(value)]
    }
    
    public func setValues(values: [String]){
        self.workoutDuration = values
    }
}

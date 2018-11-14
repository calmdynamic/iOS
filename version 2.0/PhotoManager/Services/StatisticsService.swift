//
//  StatisticsService.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-09-19.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import Foundation
import Charts

class StatisticsService{
    static var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    
    
    static func pieChart(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView, selectedFolderTypeSaveLocation: String, noDataAvailableLabel: UILabel, segmentedControl : UISegmentedControl){
        
        if(segmentedControl.selectedSegmentIndex == 0){
            
            numberOfDownloadsDataEntries.removeAll()
            
            self.populateFoldersVSTypeDataEntry(folderType: folderType)
            
            statisticsPieChartView.chartDescription?.text = ""
            StatisticsService.updateFirstChartData(statisticsTitleLabel: statisticsTitleLabel, folderType: folderType, statisticsPieChartView: statisticsPieChartView)
            
            
        }else if segmentedControl.selectedSegmentIndex == 1{
            numberOfDownloadsDataEntries.removeAll()
            
            self.populateImagesVSTypeDataEntry(folderType: folderType)
            statisticsPieChartView.chartDescription?.text = ""
            StatisticsService.updateSecondChartData(statisticsTitleLabel: statisticsTitleLabel, folderType: folderType, statisticsPieChartView: statisticsPieChartView)
            
        }else{
            numberOfDownloadsDataEntries.removeAll()
            let type = folderType.getOneFolderTypeByName(typeName: selectedFolderTypeSaveLocation)
            
            self.populateImagesVSFolderDateEntry(type: type)
            statisticsPieChartView.chartDescription?.text = ""
            StatisticsService.updateThirdChartData(statisticsTitleLabel: statisticsTitleLabel, folderType: folderType, statisticsPieChartView: statisticsPieChartView, selectedFolderTypeSaveLocation: selectedFolderTypeSaveLocation)
        }
        
        if self.numberOfDownloadsDataEntries.isEmpty{
            noDataAvailableLabel.isHidden = false
        }else{
            noDataAvailableLabel.isHidden = true
        }
//        if segmentedControl.selectedSegmentIndex == 0 || segmentedControl.selectedSegmentIndex == 1{
//            print("num of empty")
//            print(folderType.getNumOfEmptyFolderType())
//            print(folderType.getFolderTypeSize())
//            if folderType.getNumOfEmptyFolderType() == (folderType.getFolderTypeSize()-1){
//                noDataAvailableLabel.isHidden = false
//            }else{
//                noDataAvailableLabel.isHidden = true
//            }
//        }
    }
    
    
    public static func updateFirstChartData(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView) {
        
        statisticsTitleLabel.text = "# of Folders in Each Type"
        
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let newFolderTypeList = TypeList()
        newFolderTypeList.setFolderTypes(folderType.getNonEmptyFolderType())
        
        let colors: [UIColor] = self.populateColorArray(folderType: newFolderTypeList)
        
        chartDataSet.colors = colors
        chartDataSet.valueFont = UIFont(name:"futura",size:15)!
        chartDataSet.entryLabelColor = UIColor.black
        chartDataSet.valueTextColor = UIColor.black
        chartDataSet.yValuePosition = .outsideSlice
        
//        chartDataSet.valueLinePart1Length = 0.1
//        chartDataSet.valueLinePart2Length = 0.1
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.label = "[Total: \(folderType.getFolderTypes().count - 1)] [Empty: \(folderType.getNumOfEmptyFolderType())]"
        
        statisticsPieChartView.data = chartData
    }
    
    public static func updateSecondChartData(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView) {
        
        statisticsTitleLabel.text = "# of Images in Each Type"
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let newFolderTypeList = TypeList()
        newFolderTypeList.setFolderTypes(folderType.getNonEmptyFolderType())
        
        let colors: [UIColor] = self.populateColorArray(folderType: newFolderTypeList)
        
        chartDataSet.colors = colors
        chartDataSet.valueFont = UIFont(name:"futura",size:15)!
        chartDataSet.entryLabelColor = UIColor.black
        chartDataSet.valueTextColor = UIColor.black
        chartDataSet.yValuePosition = .outsideSlice
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.label = "[Total: \(folderType.getFolderTypes().count - 1)] [Empty: \(folderType.getNumOfEmptyFolderType())]"
        
        statisticsPieChartView.data = chartData
    }
    
    public static func updateThirdChartData(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView, selectedFolderTypeSaveLocation: String) {

        statisticsTitleLabel.text = "# of Images in Each Folder"
        
       
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let type = folderType.getOneFolderTypeByName(typeName: selectedFolderTypeSaveLocation)
        
        let colors: [UIColor] = self.populateColorArray(type: type)
        
        chartDataSet.colors = colors
        chartDataSet.valueFont = UIFont(name:"futura",size:15)!
        chartDataSet.entryLabelColor = UIColor.black
        chartDataSet.valueTextColor = UIColor.black
        chartDataSet.xValuePosition = .outsideSlice

        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.label = "[Total: \(type.getFolders().count)] [Empty: \(type.getNumOfEmptyFolder())]"
        
        statisticsPieChartView.data = chartData
    }
    
    
    private static func populateColorArray(folderType : TypeList)->[UIColor]{
        
        let brown = UIColor(red: 0.9098, green: 0.651, blue: 0, alpha: 1.0)
        let blue = UIColor(red: 0, green: 0.4863, blue: 0.698, alpha: 1.0)
        
        let green = UIColor(red: 0, green: 0.5686, blue: 0.2353, alpha: 1.0)
        
        
        let colorSamples = [brown, blue, green]
        var colors: [UIColor] = [UIColor]()
        for i in 0...folderType.getFolderTypes().count-1{
            colors.append(colorSamples[i % 3])
            
        }
        
        print("...")
        print(folderType.getFolderTypeSize())
        
        let last = folderType.getFolderTypeSize()-2
//        if last == -1{
//            last = folderType.getFolderTypes().count - 2
//        }
        
        // avoid the last color and first color are the same
        if colors.count > 2{
            var tempCount = 0
            while colors.first == colors[last]{
                colors[last] = colorSamples[tempCount % 3]
                tempCount = tempCount + 1
            }
        }
        return colors
        
    }
    
    private static func populateColorArray(type : Type)->[UIColor]{
        let brown = UIColor(red: 0.9098, green: 0.651, blue: 0, alpha: 1.0)
        let blue = UIColor(red: 0, green: 0.4863, blue: 0.698, alpha: 1.0)
        
        let green = UIColor(red: 0, green: 0.5686, blue: 0.2353, alpha: 1.0)
        
        let colorSamples = [brown, blue, green]
        var colors: [UIColor] = [UIColor]()
        for i in 0...type.getFolders().count-1{
            colors.append(colorSamples[i % 3])
            
        }
        
        print(colors)
        var last = type.getNumOfRemainingFolder()-1
        if last == -1{
            last = type.getFolders().count - 1
        }
        print(last)

        // avoid the last color and first color are the same
        if colors.count > 2{
            var tempCount = 0
            
            while colors.first == colors[last]{
                colors[last] = colorSamples[tempCount % 3]
                tempCount = tempCount + 1
            }
        }
        
        return colors
        
    }
    
    
    
    static func populateFoldersVSTypeDataEntry(folderType : TypeList){
        for i in folderType.getFolderTypes(){
            if i.getFolderCount() != 0 && i.getName() != "Default"{
                let newDataEntry = PieChartDataEntry(value: Double(i.getFolderCount()))
                newDataEntry.label = i.getName()
                numberOfDownloadsDataEntries.append(newDataEntry)
            }
        }
    }
    
    static func populateImagesVSTypeDataEntry(folderType : TypeList){
        for i in folderType.getFolderTypes(){
            if i.getFolderCount() != 0 && i.getName() != "Default" && i.getImageCount() != 0{
                
                let newDataEntry = PieChartDataEntry(value: Double(i.getImageCount()))
                newDataEntry.label = i.getName()
                
                numberOfDownloadsDataEntries.append(newDataEntry)
            }
        }
    }
    
    static func populateImagesVSFolderDateEntry(type: Type){
        for i in type.getFolders(){
            let newDataEntry = PieChartDataEntry(value: Double(i.getImageCount()))
            newDataEntry.label = i.getName()
            if i.getImageCount() != 0{
                numberOfDownloadsDataEntries.append(newDataEntry)
            }
        }
    }

}

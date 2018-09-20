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
        
        
    }
    
    
    public static func updateFirstChartData(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView) {
        
        statisticsTitleLabel.text = "# of Folder vs Types"
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let colors: [UIColor] = self.populateColorArray(folderType: folderType)
        
        chartDataSet.colors = colors
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.label = "[Total: \(folderType.getFolderTypes().count - 1)] [Empty: \(folderType.getNumOfEmptyFolderType())] [Reamining: \(folderType.getNumOfReaminingFolderType()-1)]"
        
        statisticsPieChartView.data = chartData
    }
    
    public static func updateSecondChartData(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView) {
        
        statisticsTitleLabel.text = "# of Image vs Types"
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let colors: [UIColor] = self.populateColorArray(folderType: folderType)
        
        chartDataSet.colors = colors
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.label = "[Total: \(folderType.getFolderTypes().count - 1)] [Empty: \(folderType.getNumOfEmptyFolderType())] [Reamining: \(folderType.getNumOfReaminingFolderType()-1)]"
        
        statisticsPieChartView.data = chartData
    }
    
    public static func updateThirdChartData(statisticsTitleLabel: UILabel, folderType: TypeList, statisticsPieChartView: PieChartView, selectedFolderTypeSaveLocation: String) {
        
        statisticsTitleLabel.text = "# of Images vs Folder"
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let type = folderType.getOneFolderTypeByName(typeName: selectedFolderTypeSaveLocation)
        
        let colors: [UIColor] = self.populateColorArray(type: type)
        
        chartDataSet.colors = colors
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.label = "[Total: \(type.getFolders().count)] [Empty: \(type.getNumOfEmptyFolder())] [Reamining: \(type.getNumOfRemainingFolder())]"
        
        statisticsPieChartView.data = chartData
    }
    
    
    private static func populateColorArray(folderType : TypeList)->[UIColor]{
        let colorSamples = [UIColor.red, UIColor.blue, UIColor.black]
        var colors: [UIColor] = [UIColor]()
        for i in 0...folderType.getFolderTypes().count{
            colors.append(colorSamples[i % 3])
        }
        return colors
        
    }
    
    private static func populateColorArray(type : Type)->[UIColor]{
        let colorSamples = [UIColor.red, UIColor.blue, UIColor.black]
        var colors: [UIColor] = [UIColor]()
        for i in 0...type.getFolders().count{
            colors.append(colorSamples[i % 3])
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

//
//  BarChart.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-23.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import Charts

class BarChart: UIView{
    
    let barChartView = BarChartView()
    var dataEntry: [BarChartDataEntry] = []
    
    var folderTypes = [String]()
    var folders = [String]()
    
    
    var delegate: GetChartData!{
        didSet{
            populateData()
            barChartSetup()
        }
    }
    
    func populateData(){
        folderTypes = delegate.folderTypes
        folders = delegate.folders
        
    }
    
    
    func barChartSetup(){
        self.backgroundColor = UIColor.white
        self.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150).isActive = true
        barChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        barChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        if folderTypes.count != 0{
        setBarCHart(dataPoints: folderTypes, values: folders)
        }
    }
    
    func setBarCHart(dataPoints: [String], values: [String]){
        
        barChartView.noDataTextColor = UIColor.white
        
        barChartView.backgroundColor = UIColor.white
        
        barChartView.noDataText = "NO data for the chart"
        
        for i in 0..<dataPoints.count{
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntry.append(dataPoint)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Folder # per each Type")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        chartDataSet.colors = [UIColor.blue]
        
        let formatter2: ChartFormatter = ChartFormatter()
        formatter2.setValues(values: dataPoints)
        
        
        let xaxis: XAxis = XAxis()
        
        xaxis.valueFormatter = formatter2
        barChartView.xAxis.setLabelCount(dataEntry.count, force: false)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = true
        barChartView.rightAxis.enabled = true
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.rightAxis.enabled = false
        barChartView.data = chartData

        barChartView.xAxis.labelRotationAngle = 90
        barChartView.xAxis.axisLineWidth = 1
       
        barChartView.xAxis.granularity = 1
        
        barChartView.leftAxis.spaceBottom = 0.0
        barChartView.rightAxis.spaceBottom = 0.0
        
        barChartView.drawValueAboveBarEnabled = true

       
        
    }
    
}

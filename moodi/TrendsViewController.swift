//
//  trendsViewController.swift
//  moodi
//
//  Created by Amy Moretti on 3/12/22.
//

import UIKit

import Charts

import TinyConstraints

class TrendsViewController: UIViewController, ChartViewDelegate {

    var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemGray6
        return chartView
    }()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveCycleData()
        createMoodArray()
        createFlowArray()
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        // Do any additional setup after loading the view.
    }
    
    //func createLineArrays(Dictionary<String: String>, Dictionary<String: String>) -> {
        
    //}
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }

    
}

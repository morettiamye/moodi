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
    
    var moodValues: [ChartDataEntry] = []
    var flowValues: [ChartDataEntry] = []
    
    var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemGray6
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(7, force: false)
        yAxis.axisLineColor = .white
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.axisLineColor = .white
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveCycleData()
        (moodValues, flowValues) = createMoodArray()
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        setData()
        
        // Do any additional setup after loading the view.
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }

    func setData(){
        let moodSet = LineChartDataSet(entries: moodValues, label: "Mood")
        moodSet.drawCirclesEnabled = false
        moodSet.mode = .cubicBezier
        moodSet.lineWidth = 5
        moodSet.setColor(.black)
        moodSet.drawHorizontalHighlightIndicatorEnabled = false
        
        let cycleSet = LineChartDataSet(entries: flowValues, label: "Cycle")
        cycleSet.drawCirclesEnabled = false
        cycleSet.mode = .cubicBezier
        cycleSet.lineWidth = 5
        cycleSet.setColor(.systemPink)
        cycleSet.drawHorizontalHighlightIndicatorEnabled = false
        
        
        
        let moodDataSet = LineChartData(dataSets: [moodSet, cycleSet])
        lineChartView.data = moodDataSet
        
        //let cycleDataSet = LineChartData(dataSet: cycleSet)
        //lineChartView.data = cycleDataSet

        
    }
    

    
}

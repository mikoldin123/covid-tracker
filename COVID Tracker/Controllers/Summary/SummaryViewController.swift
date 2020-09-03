//
//  SummaryViewController.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVMCore
import Charts

class SummaryViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = SummaryViewModel

    // MARK: - Properties
    let coordinatedModel: CoordinatedInitiable
    fileprivate let viewModel: ViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    lazy var chartView: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chart)
        
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            chart.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            chart.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            chart.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        ])
        
        return chart
    }()
    
    required init(model: ViewModel) {
        self.viewModel = model
        self.coordinatedModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        self.setupPieChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.requestCasesSummary()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setupPieChart() {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        chartView.entryLabelColor = .black
        
        chartView.drawCenterTextEnabled = true
        
        chartView.centerText = "TOTAL CASES"
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        
        viewModel
            .globalSummary
            .subscribe(onNext: { [weak self] (summary) in
                
                guard let this = self, let summary = summary else {
                    return
                }
                
                let entries = [PieChartDataEntry(value: Double(summary.totalConfirmed - summary.totalRecovered), label: "ACTIVE"), PieChartDataEntry(value: Double(summary.totalRecovered), label: "RECOVERED"), PieChartDataEntry(value: Double(summary.totalDeaths), label: "DEATHS")]
                this.generateEntries(entries)
            })
            .disposed(by: disposeBag)
    }
    
    func generateEntries(_ entries: [PieChartDataEntry]) {
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.sliceSpace = 2.0
        
        dataSet.colors = ChartColorTemplates.vordiplom()
        + ChartColorTemplates.joyful()
        + ChartColorTemplates.colorful()
        + ChartColorTemplates.liberty()
        + ChartColorTemplates.pastel()
        + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        dataSet.valueColors = [UIColor.black]
        
        dataSet.valueTextColor = UIColor.black
        
        let data = PieChartData(dataSet: dataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
}

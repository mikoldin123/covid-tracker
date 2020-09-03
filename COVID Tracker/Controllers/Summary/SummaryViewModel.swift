//
//  SummaryViewModel.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MVVMCore

class SummaryViewModel: CoordinatedInitiable {
    var coordinateDelegate: CoordinatorDelegate?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var globalSummary = BehaviorRelay<GlobalSummary?>(value: nil)
    
    required init(model: Any?) { }
    
    func requestCasesSummary() {
        let successHandler = { [unowned self] (covid: CovidSummary) in
            print("SUCCESS ----- \(covid.global) === \(covid.countries.first(where: { $0.code == "PH"})) ")
            
            let summary = covid.global
            
            print("GLOBAL SUMMARY:\nTOTAL CASES: \(summary.totalConfirmed)\nTOTAL RECOVERED: \(summary.totalRecovered)\nTOTAL DEATHS: \(summary.totalDeaths)")
            self.globalSummary.accept(summary)
        }
        
        let errorHandler = { (error: Error) in
            
        }
        
        
        CovidAPI.summary.request().subscribe(onSuccess: successHandler, onError: errorHandler).disposed(by: disposeBag)
    }
    
}

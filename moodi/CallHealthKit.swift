//
//  CallHealthKit.swift
//  moodi
//
//  Created by Amy Moretti on 3/14/22.
//

import Foundation

import HealthKit

// Interaction with HealthKit
let healthStore = HKHealthStore()

func authorizeHK() {
    let allTypes = Set([HKObjectType.categoryType(forIdentifier: .menstrualFlow)!])

    healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
        if !success {
            fatalError("Healthkit can't authorize")
        }
    }
}

// Retrieve menstrual cycle data from Health
func retrieveCycleData(){
    
    guard let sampleType = HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.menstrualFlow) else {
        fatalError("*** This method should never fail ***")
    }
    
    let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
        query, results, error in
        
        guard let samples = results as? [HKCategorySample] else {
            // Handle any errors here.
            return
        }
        
        for sample in samples {
            // Process each sample here.
            let newCycleData = userCycle(
              flowValue: HKCategoryValueMenstrualFlow(rawValue: sample.value)!,
              date: truncatedDate(date: sample.startDate))
              saveFlow(fd: newCycleData)
            
            //print(sample)
        }
        
        // The results come back on an anonymous background queue.
        // Dispatch to the main queue before modifying the UI.
        
        DispatchQueue.main.async {
            // Update the UI here.
        }
    }
    
    healthStore.execute(query)
}

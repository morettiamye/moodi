//
//  mood.swift
//  moodi
//
//  Created by Amy Moretti on 3/13/22.
//

import Foundation

import SQLite

import HealthKit


// Structs for DB information
struct TodaysMood {
    var mood:String
    var weather:String
    var sleep:String
    var notes:String
    var moodContributors:String
    var date:Date = Date()
}

struct userCycle {
    var flowValue:HKCategoryValueMenstrualFlow
    var date:Date
}

var newMoodToLog = TodaysMood.init(mood: "", weather: "", sleep: "", notes: "", moodContributors: "", date: Date())


// Create SQLite Database & Table
func openDatabase() throws -> Connection {
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory,
        .userDomainMask,
        true).first!
    
    let db = try Connection("\(path)/db.sqlite3")

    return db
}

// Mood Table
let colMood = Expression<String>("mood")
let colWeather = Expression<String>("weather")
let colSleep = Expression<String>("sleep")
let colNotes = Expression<String>("notes")
let colMoodContrib = Expression<String>("contributers")
let colDate = Expression<Date>("logDate")

// Flow Table
let colFlow = Expression<Int>("flow")
let colFlowDate = Expression<Date>("flowDate")


// Create Tables
func createDatabase() {

    do {
        let db = try openDatabase()
        let loggedMood = Table("loggedMood")
        try db.run(loggedMood.create(ifNotExists: true) { t in
        t.column(colMood)
        t.column(colWeather)
        t.column(colSleep)
        t.column(colNotes)
        t.column(colMoodContrib)
        t.column(colDate, unique: true)
        })
        
        let flowData = Table("flowData")
        try db.run(flowData.create(ifNotExists: true) { t in
            t.column(colFlow)
            t.column(colFlowDate, unique: true)
        })
    } catch {
        print("Unexpected error: \(error)")
    }
}

// Add mood data to loggedMood table
func saveMood(tm: TodaysMood){
    do {
        let db = try openDatabase()
        let loggedMood = Table("loggedMood")
    
        try db.run(loggedMood.insert(
            colMood <- tm.mood,
            colWeather <- tm.weather,
            colSleep <- tm.sleep,
            colNotes <- tm.notes,
            colMoodContrib <- tm.moodContributors,
            colDate <- tm.date
        ))
    } catch {
        print("Unexpected error: \(error)")
    }
}


// add data to flowData table
func saveFlow(fd: userCycle){
    do {
        let db = try openDatabase()
        let flowData = Table("flowData")
    
        try db.run(flowData.insert(
            colFlow <- fd.flowValue.rawValue,
            colFlowDate <- fd.date
        ))
    } catch {
        print("Unexpected error: \(error)")
    }
}


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
            let newCycleData = userCycle(flowValue: HKCategoryValueMenstrualFlow(rawValue: sample.value)!, date: sample.startDate)
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

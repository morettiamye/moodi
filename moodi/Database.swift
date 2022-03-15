//
//  mood.swift
//  moodi
//
//  Created by Amy Moretti on 3/13/22.
//

import Foundation

import SQLite

import HealthKit

import Charts


// Structs for DB information
struct TodaysMood {
    var mood:String
    var weather:String
    var sleep:String
    var notes:String
    var moodContributors:String
    var date:String
}

struct userCycle {
    var flowValue:HKCategoryValueMenstrualFlow
    var date:String
}

var newMoodToLog =
  TodaysMood.init(
      mood: "",
      weather: "",
      sleep: "",
      notes: "",
      moodContributors: "",
      date: truncatedDate()
    )


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
let colDate = Expression<String>("logDate")

// Flow Table
let colFlow = Expression<Int>("flow")
let colFlowDate = Expression<String>("flowDate")

// Create Tables
func createDatabase() {
    
    do {
        let db = try openDatabase()
        let loggedMood = Table("loggedMood")
        let flowData = Table("flowData")
        
        // Comment out the below line if you need to clean up the table
        //try db.run(loggedMood.drop())
        try db.run(loggedMood.create(ifNotExists: true) { t in
        t.column(colMood)
        t.column(colWeather)
        t.column(colSleep)
        t.column(colNotes)
        t.column(colMoodContrib)
        t.column(colDate, unique: true)
        })
        
        // Comment out the below line if you need to clean up the table
        //try db.run(flowData.drop())
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

// Retreve relevent data for line chart, push to dictionary.
func createMoodArray() -> ([ChartDataEntry], [ChartDataEntry]) {
    
    var moodDict: [String: String] = [:]
    var flowDict: [String: String] = [:]
    
    do {
        let db = try openDatabase()
        let loggedMood = Table("loggedMood")
        let flowData = Table("flowData")
        //let query = loggedMood.select(colMood, colDate).order(colDate)
        
        for moodRow in try db.prepare(loggedMood.select(colMood, colDate).order(colDate)){
          moodDict[moodRow[colDate]] = String(moodRow[colMood])
        }
        
        for flowRow in try db.prepare(flowData.select(colFlow, colFlowDate).order(colFlowDate)){
            flowDict[flowRow[colFlowDate]] = String(flowRow[colFlow])
        }
        
        
    } catch {
        print("Unexpected error: \(error)")
    }
    
    var moodValues: [ChartDataEntry] = []
    var x = 0.0;
    for (_, mood) in moodDict {
        moodValues.append(ChartDataEntry(x: x, y: Double(getMoodValue(moodString: mood))))
      x = x + 1
    }
    
    var flowValues: [ChartDataEntry] = []
    x = 0.0;
    for (_, flow) in flowDict {
        flowValues.append(ChartDataEntry(x: x, y: Double(getFlowValue(flowValue: flow))))
      x = x + 1
    }
 
    return (moodValues, flowValues)
}

func getMoodValue(moodString: String) -> Int {
  switch (moodString) {
      case "angry":
          return 1;
      case "unhappy":
          return 2;
      case "anxious":
          return 3;
      case "neutral":
          return 4;
      case "content":
          return 5;
      case "happy":
          return 6;
      case "excited":
          return 7;
      default:
          return 1;
  }
}

func getFlowValue(flowValue: String) -> Int {
    switch (flowValue) {
        case "2":
            return 4;
        case "3":
            return 4;
        case "4":
            return 4;
        default:
            return 1;
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


// This function truncates the date
func truncatedDate(date: Date = Date()) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"

    let result = dateFormatter.string(from: date)
    return result
}

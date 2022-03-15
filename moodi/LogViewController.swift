//
//  logViewController.swift
//  moodi
//
//  Created by Amy Moretti on 3/12/22.
//

import UIKit

import SQLite


class LogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var sleepTextView: UITextView!
    
    
    @IBOutlet weak var weatherTextView: UITextView!
    
    
    // Set inputted sleep and weather data
    @IBAction func setConditionsData(_ sender: Any) {
        newMoodToLog.sleep = sleepTextView.text
        newMoodToLog.weather = weatherTextView.text
    }
    
    
    @IBOutlet weak var contributorsTextView: UITextView!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // Save additional data, push to table
    @IBAction func setMoodData(_ sender: Any) {
        newMoodToLog.moodContributors = contributorsTextView.text
        newMoodToLog.notes = notesTextView.text
        
        saveMood(tm: newMoodToLog)
        
    }
    
    // Simpler way of dismissing keyboard than demo'd in class
    // Apple docs on endEditing @ https://developer.apple.com/documentation/uikit/uiview/1619630-endediting
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    

}

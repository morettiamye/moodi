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
    
    
    @IBOutlet weak var contributorsTextView: UITextView!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBAction func setMoodData(_ sender: Any) {
        newMoodToLog.moodContributors = contributorsTextView.text
        newMoodToLog.notes = notesTextView.text
        
        
        saveMood(tm: newMoodToLog)
        
    }
    
    

}

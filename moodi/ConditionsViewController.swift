//
//  conditionsViewController.swift
//  moodi
//
//  Created by Amy Moretti on 3/12/22.
//

import UIKit

class ConditionsViewController: UIViewController {

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
    

}

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
    
    
    @IBAction func setConditionsData(_ sender: Any) {
        newMoodToLog.sleep = sleepTextView.text
        newMoodToLog.weather = weatherTextView.text
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

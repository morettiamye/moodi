//
//  moodViewController.swift
//  moodi
//
//  Created by Amy Moretti on 3/12/22.
//

import UIKit

class MoodViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Request Healthkit permission, start connection to DB
        authorizeHK()
        createDatabase()
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var exited: UIButton!
    
    @IBOutlet weak var happy: UIButton!

    @IBOutlet weak var content: UIButton!
    
    @IBOutlet weak var neutral: UIButton!
    
    @IBOutlet weak var anxious: UIButton!
    
    @IBOutlet weak var unhappy: UIButton!
    
    @IBOutlet weak var angry: UIButton!
    
    // MARK: - Navigation
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "excited":
            newMoodToLog.mood = "Excited"
        
        case "happy":
            newMoodToLog.mood = "Happy, Cheerful"
            
        case "content":
            newMoodToLog.mood = "Content"
            
        case "neutral":
            newMoodToLog.mood = "Neutral, No Feelings"
            
        case "anxious":
            newMoodToLog.mood = "Anxious, Nervous"
            
        case "unhappy":
            newMoodToLog.mood = "Unhappy, Sad"
            
        case "angry":
            newMoodToLog.mood = "Angry, Upset"
            
        default:
            break
            
        }

    }
    
}

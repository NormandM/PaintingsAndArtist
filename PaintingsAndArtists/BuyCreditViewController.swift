//
//  BuyCreditViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-17.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class BuyCreditViewController: UIViewController {
    
    
    @IBOutlet weak var creditsAvailable: UILabel!
    var credit = UserDefaults.standard.integer(forKey: "credit"){
        didSet {
            creditsAvailable.text = "You have \(credit) available"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        credit = UserDefaults.standard.integer(forKey: "credit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buy200CoinsAsBeenPressed(_ sender: UITapGestureRecognizer) {
        
        UserDefaults.standard.set(credit + 200, forKey: "credit")
        credit = UserDefaults.standard.integer(forKey: "credit")
    }
    @IBAction func watchVideoHasBeenPressed(_ sender: UITapGestureRecognizer) {
        UserDefaults.standard.set(credit + 20, forKey: "credit")
        credit = UserDefaults.standard.integer(forKey: "credit")
    }
    @IBAction func doneAsBeenPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "dismissBuyCredits", sender: self)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

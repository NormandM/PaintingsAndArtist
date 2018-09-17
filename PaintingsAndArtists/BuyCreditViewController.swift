//
//  BuyCreditViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-17.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class BuyCreditViewController: UIViewController {
    
    @IBOutlet weak var buyCreditViewTitle: SpecialLabel!
    @IBOutlet weak var buy200CoinsLabel: UILabel!
    @IBOutlet weak var watchVideoLabel: UILabel!
    @IBOutlet weak var doneButton: RoundButton!
    var provenance = String()
    
    let fontsAndConstraints = FontsAndConstraints()
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    var credit = UserDefaults.standard.integer(forKey: "credit"){
        didSet {
            buyCreditViewTitle.text = """
            CREDIT AVAILABLE: \(credit)
            To preserve the visual integrity of the App,
            except for this page, there are no adds in
            LEARN ART.
            """
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        credit = UserDefaults.standard.integer(forKey: "credit")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.width/2
        doneButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        doneButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        buyCreditViewTitle.font = sizeInfoAndFonts?.fontSize2
        buyCreditViewTitle.layer.borderColor = UIColor.white.cgColor
        buyCreditViewTitle.layer.borderWidth = 3.0
        buy200CoinsLabel.text = """
        Do you enjoy LEARN ART?
        Buy 200 coins for $ 1.00,
        It will last you for ever!
        """
        buy200CoinsLabel.font = sizeInfoAndFonts?.fontSize1
        watchVideoLabel.text = """
        Not sure yet?
        Watch a video and get
        20 coins for free.
        """
        watchVideoLabel.font = sizeInfoAndFonts?.fontSize1
        
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.width/2
    }

    @IBAction func doneHasBeenPressed(_ sender: RoundButton) {
        if provenance == "menu"{
            performSegue(withIdentifier: "menu", sender: self)
        }else if provenance == "quiz"{
            performSegue(withIdentifier: "quiz", sender: self)
        }
    }
    
    @IBAction func buy200CoinsAsBeenPressed(_ sender: UITapGestureRecognizer) {
        
        UserDefaults.standard.set(credit + 200, forKey: "credit")
        credit = UserDefaults.standard.integer(forKey: "credit")
    }
    @IBAction func watchVideoHasBeenPressed(_ sender: UITapGestureRecognizer) {
        UserDefaults.standard.set(credit + 20, forKey: "credit")
        credit = UserDefaults.standard.integer(forKey: "credit")
    }

    
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

    }
    

}

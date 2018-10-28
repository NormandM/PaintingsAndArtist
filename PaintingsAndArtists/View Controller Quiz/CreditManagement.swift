//
//  CreditManagement.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-16.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
class CreditManagment{
    class func increaseOneCredit(hintButton: UIButton?){
        let credit = UserDefaults.standard.integer(forKey: "credit") + 1
        let score = UserDefaults.standard.integer(forKey: "score") + 1
        UserDefaults.standard.set(score, forKey: "score")
        UserDefaults.standard.set(credit, forKey: "credit")
        if let button = hintButton {
            button.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        }
    }
    class func increaseTwentyCredit() {
        let credit = UserDefaults.standard.integer(forKey: "credit") + 20
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score") + 20
        UserDefaults.standard.set(score, forKey: "score")
    }
    class func increaseFiftheenCredit(){
        let credit = UserDefaults.standard.integer(forKey: "credit") + 40
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score") + 40
        UserDefaults.standard.set(score, forKey: "score")
    }
    class func increaseThirtyCredit(){
        let credit = UserDefaults.standard.integer(forKey: "credit") + 60
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score") + 60
        UserDefaults.standard.set(score, forKey: "score")
    }
    class func increseFiftyCredit() {
        let credit = UserDefaults.standard.integer(forKey: "credit") + 80
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score") + 80
        UserDefaults.standard.set(score, forKey: "score")
        
    }
    class func increseOneThousandCredit() {
        let credit = UserDefaults.standard.integer(forKey: "credit") + 100
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score") + 100
        UserDefaults.standard.set(score, forKey: "score")
        
    }
    class func decreaseOneCredit(hintButton: UIButton?){
        let credit = UserDefaults.standard.integer(forKey: "credit") - 1
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score")
        if let button = hintButton {
            button.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        }
        
    }
    class func decreaseTwoCredit(hintButton: UIButton?){
        let credit = UserDefaults.standard.integer(forKey: "credit") - 2
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score")
        if let button = hintButton {
             button.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        }
       
    }
    class func decreaseThreeCredit(hintButton: UIButton?){
        let credit = UserDefaults.standard.integer(forKey: "credit") - 3
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score")
        if let button = hintButton {
            button.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        }
        
    }
    class func decreaseFourCredit(hintButton: UIButton?){
        let credit = UserDefaults.standard.integer(forKey: "credit") - 4
        UserDefaults.standard.set(credit, forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score")
        if let button = hintButton {
            button.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        }
        
    }
    class func displayCredit(hintButton: UIButton?){
        let credit = UserDefaults.standard.integer(forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score")
        if let button = hintButton {
            button.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        }
    }
    
}

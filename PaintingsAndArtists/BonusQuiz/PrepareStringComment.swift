//
//  PrepareStringComment.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-04-30.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
class PrepareString {
    class func stringForCreditAndScore(painterName: String, credit: Int, score: Int, creditLabel: SpecialLabel, commentAfterResponse: SpecialLabel) {
        let formatedString = "Great!\n%@\nYou are right!\n\n1 coin was added".localized
        commentAfterResponse.text = String(format: formatedString, painterName)
        let formatedString1 = "Credits: %lld".localized
        let firstString = String(format: formatedString1, credit)
        let formatedString2 = "Score: %lld".localized
        let secondString = String(format: formatedString2, score)
        creditLabel.text = firstString + "\n" + secondString
          
    }
    class func stringForCreditAndScoreIfGaveUp(painterName: String, credit: Int, score: Int, creditLabel: SpecialLabel, commentAfterResponse: SpecialLabel){
        let formatedString = "Sorry you gave up!\nremember the name:\n%@".localized
        commentAfterResponse.text = String(format: formatedString, painterName)
        let formatedString1 = "Credits: %lld".localized
        let firstString = String(format: formatedString1, credit)
        let formatedString2 = "Score: %lld".localized
        let secondString = String(format: formatedString2, score)
        creditLabel.text = firstString + "\n" + secondString
        
    }
}

//
//  Hint.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-02.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class Hint{
    class func manageHints (buttonLabel: String, finalArrayOfButtonNames: [String]?, painterName: String?, painterButton: [UIButton]?, placeHolderButton: UIButton?, labelTitle: UILabel?, view: UIViewController?, nextButton: UIButton?, titleText: String?, hintButton: UIButton, showActionView: () -> Void) -> Int{
        var buttonIndexToBeHidden = [Int]()
        var errorcount = 0
        var n = 0
        switch buttonLabel {
        case HintLabel.buyCoins.rawValue.localized:
            return 0
        case HintLabel.dropTwoPainters.rawValue.localized:
            for buttonName in finalArrayOfButtonNames! {
                if buttonName != painterName {
                    buttonIndexToBeHidden.append(n)
                }
                n = n + 1
            }
            painterButton![buttonIndexToBeHidden[0]].isEnabled = false
            painterButton![buttonIndexToBeHidden[0]].isHidden = true
            painterButton![buttonIndexToBeHidden[1]].isEnabled = false
            painterButton![buttonIndexToBeHidden[1]].isHidden = true
            errorcount = 2
            CreditManagment.decreaseTwoCredit(hintButton: hintButton)
        case HintLabel.dropTwoArtMovements.rawValue.localized:
            for buttonName in finalArrayOfButtonNames! {
                if buttonName != painterName {
                    buttonIndexToBeHidden.append(n)
                }
                n = n + 1
            }
            painterButton![buttonIndexToBeHidden[0]].isEnabled = false
            painterButton![buttonIndexToBeHidden[0]].isHidden = true
            painterButton![buttonIndexToBeHidden[1]].isEnabled = false
            painterButton![buttonIndexToBeHidden[1]].isHidden = true
            CreditManagment.decreaseTwoCredit(hintButton: hintButton)
            errorcount = 2
        case HintLabel.giveAnswer.rawValue.localized:
            var painterIndex = Int()
            
            for buttonName in finalArrayOfButtonNames! {
                if buttonName == painterName {
                    painterIndex = n
                }else{
                    painterButton![n].isHidden = true
                    painterButton![n].isEnabled = false
                }
                
                n = n + 1
            }
            ButtonTranslation.translate(fromButton: painterButton![painterIndex], toButton: placeHolderButton!, painterName: painterName!)
            TitleDisplay.show(labelTitle: labelTitle!, titleText: titleText!, nextButton: nextButton!, view: view!)
            CreditManagment.decreaseThreeCredit(hintButton: hintButton)
        case HintLabel.showBio.rawValue.localized:
            showActionView()
            CreditManagment.decreaseOneCredit(hintButton: hintButton)
        case HintLabel.showLetter.rawValue.localized:
            showActionView()
            CreditManagment.decreaseOneCredit(hintButton: hintButton)
        case HintLabel.showPainterName.rawValue.localized:
            CreditManagment.decreaseFourCredit(hintButton: hintButton)
        case HintLabel.showArtMovementDefinition.rawValue.localized:
           
            showActionView()
        default:
            return 0
        }
        return errorcount
        
    }
}



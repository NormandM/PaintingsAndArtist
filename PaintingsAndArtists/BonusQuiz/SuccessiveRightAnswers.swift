//
//  SuccessiveRightAnswers.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-18.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class SuccessiveAnswer {
    class func progression (commentAfterResponse: SpecialLabel, creditLabel: SpecialLabel, painterName: String, gaveUp: Bool) -> (SpecialLabel, Int, SpecialLabel){
        let successiveRightAnswers =  UserDefaults.standard.integer(forKey: "successiveRightAnswers")
        let credit = UserDefaults.standard.integer(forKey: "credit")
        let score = UserDefaults.standard.integer(forKey: "score")
        let artAmateurIsDone = UserDefaults.standard.bool(forKey: "artAmateurIsDone")
        let artConoisseurIsDone = UserDefaults.standard.bool(forKey: "artConoisseurIsDone")
        let artExpertIsDone = UserDefaults.standard.bool(forKey: "artExpertIsDone")
        let artScholarIsDone = UserDefaults.standard.bool(forKey: "artScholarIsDone")
        let artMasterIsDone = UserDefaults.standard.bool(forKey: "artMasterIsDone")
        var totalQuestion = Int()
        switch successiveRightAnswers {
        case 0, 1, 2, 3, 4:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
            }
            totalQuestion = 5
        case 5:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else if !artAmateurIsDone{
                commentAfterResponse.text = "You have reach the level\nART AMATEUR!\nYou have correctly answered 5 consecutive questions!\n\n20 coins were added".localized
                CreditManagment.increaseTwentyCredit()
            }
            if artAmateurIsDone {
                totalQuestion = 10
            }else{
                totalQuestion = 5
            }
        case 6 ... 14:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }
            totalQuestion = 10
        case 15:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else if !artConoisseurIsDone{
                commentAfterResponse.text = "You have reach the level\nART CONNOISSEUR!\nYou have correctly answered 10 consecutive questions!\n\n40 coins were added".localized
                CreditManagment.increaseForthyCredit()
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }
            
            totalQuestion = 10
            if artConoisseurIsDone {
                totalQuestion = 15
            }else{
                totalQuestion = 10
            }
            
        case 16 ... 29:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }
            totalQuestion = 15
        case 30:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else if !artExpertIsDone{
                commentAfterResponse.text = "You have reach the level\nART EXPERT!\nYou have correctly answered 15 consecutive questions!\n\n60 coins were added".localized
                CreditManagment.increaseSixtyCredit()
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
            }
            if artExpertIsDone {
                totalQuestion = 20
            }else{
                totalQuestion = 15
            }
        case 31 ... 49:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }
            totalQuestion = 20
        case 50:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else if !artScholarIsDone{
                commentAfterResponse.text = "You have reach the level\nART SCHOLAR!\nYou have correctly answered 30 consecutive questions!\n\n80 coins were added".localized
                CreditManagment.increseEightyCredit()
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }
            if artScholarIsDone {
                totalQuestion = 50
            }else{
                totalQuestion = 20
            }
            
        case 51 ... 99:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
            }
            totalQuestion = 50
            
            
        case 100:
            if gaveUp{
                PrepareString.stringForCreditAndScoreIfGaveUp(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }else if !artMasterIsDone{
                commentAfterResponse.text = "\nYou have reach the level\nART MASTER!\n\n100 coins bonnus were added.\nYou know art and you know this game.\nAny ideas how I could improve it?\nIf you do I would like to hear from you!\n\nPlease write at nmartin1956@gmail.com.\n\nThank you!".localized
                CreditManagment.increseOneHundredCredit()
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
                
            }
            if artMasterIsDone {
                totalQuestion = 51
            }else{
                totalQuestion = 50
            }
            
        default:
            if gaveUp{
                let formatedString = "Sorry you gave up!\nremember the name:\n%@".localized
                commentAfterResponse.text = String(format: formatedString, painterName)
                
            }else{
                PrepareString.stringForCreditAndScore(painterName: painterName, credit: credit, score: score, creditLabel: creditLabel, commentAfterResponse: commentAfterResponse)
            }
            totalQuestion = 51
        }
        return (commentAfterResponse, totalQuestion, creditLabel)
    }
    class func afterMistake(successiveRightAnswers: Int) -> Int{
        var adjustedSuccessiveAnswer = successiveRightAnswers
        
        if successiveRightAnswers < 5 {
            adjustedSuccessiveAnswer = 0
        }
        if successiveRightAnswers > 5 && successiveRightAnswers < 15 {
            adjustedSuccessiveAnswer = 5
        }
        if successiveRightAnswers > 15 && successiveRightAnswers < 30 {
            adjustedSuccessiveAnswer = 15
        }
        if successiveRightAnswers > 30 && successiveRightAnswers < 50 {
            adjustedSuccessiveAnswer = 30
        }
        if successiveRightAnswers > 50 && successiveRightAnswers < 100 {
            adjustedSuccessiveAnswer = 50
        }
        if successiveRightAnswers > 100 {
            adjustedSuccessiveAnswer = 100
        }
        return adjustedSuccessiveAnswer
    }
}

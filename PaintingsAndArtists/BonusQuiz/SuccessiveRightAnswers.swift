//
//  SuccessiveRightAnswers.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-18.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class SuccessiveAnswer {
    class func progression (commentAfterResponse: SpecialLabel, creditLabel: SpecialLabel, painterName: String, gaveUp: Bool) -> (SpecialLabel, Int){
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
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
            }
            totalQuestion = 5
        case 5:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else if !artAmateurIsDone{
            
                commentAfterResponse.text = """
                You have reach the level
                    ART AMATEUR!
                You were right with 5 consecutive
                series of answers!
                
                20 coins was added
                """
                CreditManagment.increaseTwentyCredit()
            }
            if artAmateurIsDone {
                totalQuestion = 10
            }else{
                totalQuestion = 5
            }
        case 6 ... 14:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
            commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            totalQuestion = 10
        case 15:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """

            }else if !artConoisseurIsDone{
                commentAfterResponse.text = """
                You have reach the level
                    ART CONNOISSEUR!
                You were right with 10 consecutive
                series of answers!
                
                40 coins bonnus was added
                """
                CreditManagment.increaseForthyCredit()
                
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            
            totalQuestion = 10
            if artConoisseurIsDone {
                totalQuestion = 15
            }else{
                totalQuestion = 10
            }
            
        case 16 ... 29:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
            commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            totalQuestion = 15
        case 30:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else if !artExpertIsDone{
                commentAfterResponse.text = """
                You have reach the level
                    ART EXPERT!
                You were right with 15 consecutive
                series of answers!
                
                60 coins was added
                """
                CreditManagment.increaseSixtyCredit()
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            if artExpertIsDone {
                totalQuestion = 20
            }else{
                totalQuestion = 15
            }
        case 31 ... 49:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!

                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)

                Score: \(score)
                """
                
            }
            totalQuestion = 20
        case 50:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else if !artScholarIsDone{
                commentAfterResponse.text = """
                You have reach the level
                    ART SCHOLAR!
                You were right with 30 consecutive
                series of answers!
                
                80 coins bonnus was added
                """
                CreditManagment.increseEightyCredit()
               
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            if artScholarIsDone {
                totalQuestion = 50
            }else{
               totalQuestion = 20
            }
            
        case 51 ... 99:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            totalQuestion = 50
            
            
        case 100:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else if !artMasterIsDone{
            commentAfterResponse.text = """
                
                You have reach the level
                ART MASTER!
                
                
                100 coins bonnus was added.
                
                You know art and you know this game.
                Any ideas how I could improve it?
                If you do I would like to hear from you!
                
                Please write at nmartin1956@gmail.com.
                
                Thank you!
                """
                CreditManagment.increseOneHundredCredit()
                
            }else{
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            if artMasterIsDone {
                totalQuestion = 51
            }else{
                totalQuestion = 50
            }

        default:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                
                commentAfterResponse.text = """
                Great!
                \(painterName)
                You are right!
                
                1 coin was added
                """
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                
            }
            totalQuestion = 51
        }
        return (commentAfterResponse, totalQuestion)
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

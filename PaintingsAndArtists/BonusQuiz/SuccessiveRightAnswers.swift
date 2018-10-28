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
                
            }else{
            
                commentAfterResponse.text = """
                You have reach the level
                    ART AMATEUR!
                You were right with 5 consecutive
                series of answers!
                
                20 coins was added
                """
                CreditManagment.increaseTwentyCredit()
            }
            totalQuestion = 5
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
                totalQuestion = 10
            }
        case 15:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                commentAfterResponse.text = """
                You have reach the level
                    ART CONNOISSEUR!
                You were right with 15 consecutive
                series of answers!
                
                40 coins bonnus was added
                """
                CreditManagment.increaseFiftheenCredit()
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
                totalQuestion = 15
            }
        case 30:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                commentAfterResponse.text = """
                You have reach the level
                    ART EXPERT!
                You were right with 30 consecutive
                series of answers!
                
                60 coins was added
                """
                CreditManagment.increaseThirtyCredit()
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
                totalQuestion = 20
            }
        case 50:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
                commentAfterResponse.text = """
                You have reach the level
                    ART SCHOLAR!
                You were right with 50 consecutive
                series of answers!
                
                80 coins bonnus was added
                """
                CreditManagment.increseFiftyCredit()
                totalQuestion = 20
            }
        case 100:
            if gaveUp{
                commentAfterResponse.text = """
                Sorry you gave up!
                remember the name:
                
                \(painterName)
                
                """
                
            }else{
            commentAfterResponse.text = """
                
                Fantastic!
                YOU KNOW IT ALL!
                
                100 coins bonnus was added.
                
                You know art and you know this game.
                Any ideas how I could improve it?
                If you do I would like to hear from you!
                
                Please write at nmartin1956@gmail.com.
                
                Thank you!
                """
                CreditManagment.increseOneThousandCredit()
                totalQuestion = 50
            }
        default:
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
            totalQuestion = 50
        }
        return (commentAfterResponse, totalQuestion)
    }
}

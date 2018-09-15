//
//  SuccessiveRightAnswers.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-18.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class SuccessiveAnswer {
    class func progression (commentAfterResponse: SpecialLabel, painterName: String, totalPaintings: Int, gaveUp: Bool) -> (SpecialLabel, Int){
        let successiveRightAnswers =  UserDefaults.standard.integer(forKey: "successiveRightAnswers")
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
                
                1 coin bonnus was added to your credits
                """
            }
            totalQuestion = 5
        case 5:
            commentAfterResponse.text = """
            You have reach the level
                ART AMATEUR!
            You were right with 5 consecutive
            series of answers!
            
            A 5 coins bonnus was added to your credits
            """
            CreditManagment.increaseFiveCredit()
            totalQuestion = 5
        case 6 ... 14:
            commentAfterResponse.text = """
            Great!
            \(painterName)
            You are right!
            
            1 coin bonnus was added to your credits
            """
            totalQuestion = 15
        case 15:
            commentAfterResponse.text = """
            You have reach the level
                ART CONNOISSEUR!
            You were right with 15 consecutive
            series of answers!
            
            A 15 coins bonnus was added to your credits
            """
            CreditManagment.increaseFiftheenCredit()
            totalQuestion = 15
        case 16 ... 29:
            commentAfterResponse.text = """
            Great!
            \(painterName)
            You are right!
            
            1 coin bonnus was added to your credits
            """
            totalQuestion = 30
        case 30:
            commentAfterResponse.text = """
            You have reach the level
                ART EXPERT!
            You were right with 30 consecutive
            series of answers!
            
            A 30 coins bonnus was added to your credits
            """
            CreditManagment.increaseThirtyCredit()
            totalQuestion = 30
        case 31 ... 49:
            commentAfterResponse.text = """
            Great!
            \(painterName)
            You are right!
            
            1 coin bonnus was added to your credits
            """
            totalQuestion = 50
        case 50:
            commentAfterResponse.text = """
            You have reach the level
                ART SCHOLAR!
            You were right with 50 consecutive
            series of answers!
            
            A 50 coins bonnus was added to your credits
            """
            CreditManagment.increseFiftyCredit()
            totalQuestion = totalPaintings
        case totalPaintings:
            commentAfterResponse.text = """
            
            Fantastic!
            YOU KNOW IT ALL!
            
            A 1000 coins bonnus was added to your credits
            
            You know art and you know this game.
            Any ideas how I could improve it?
            If you do I would like to hear from you!
            
            Please write at nmartin1956@gmail.com.
            
            Thank you!
            """
            CreditManagment.increseOneThousandCredit()
        default:
            commentAfterResponse.text = """
            Great!
            \(painterName)
            You are right!
            
            1 coin bonnus was added to your credits
            """
            totalQuestion = totalPaintings
        }
        return (commentAfterResponse, totalQuestion)
    }
}

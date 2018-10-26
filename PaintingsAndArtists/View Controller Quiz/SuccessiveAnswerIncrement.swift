//
//  SuccessiveAnswerIncrement.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-10-23.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import Foundation

class SuccessiveAnswerIncrement{
    class func increment (successiveAnswer: Int)  -> Int {
        var resultSuccessiveAnswer = Int()
        if successiveAnswer >= 5 {
            resultSuccessiveAnswer = 5
        }
        if successiveAnswer >= 15 {
            resultSuccessiveAnswer = 15
        }
        if successiveAnswer >= 30 {
            resultSuccessiveAnswer = 30
        }
        if successiveAnswer >= 50 {
            resultSuccessiveAnswer = 50
        }
        if successiveAnswer >= 100 {
            resultSuccessiveAnswer = 100
        }

        return resultSuccessiveAnswer
    }
}

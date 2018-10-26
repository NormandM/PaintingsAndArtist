//
//  ProgressionBarDisplay.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-17.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
class QuizProgressionBar {
    class func barDisplay(successiveRightAnswers: Int,  quizProgressionBar: UIProgressView, totalQuestion: Int){
        var ajustedSuccessiveRightAnswers = Int()
        if totalQuestion == 5 {ajustedSuccessiveRightAnswers = successiveRightAnswers}
        if totalQuestion == 10 {ajustedSuccessiveRightAnswers = successiveRightAnswers - 5}
        if totalQuestion == 15 {ajustedSuccessiveRightAnswers = successiveRightAnswers - 15}
        if totalQuestion == 20 {ajustedSuccessiveRightAnswers = successiveRightAnswers - 30}
        if totalQuestion == 50 {ajustedSuccessiveRightAnswers = successiveRightAnswers - 50}
        let percentcompleted = Double(ajustedSuccessiveRightAnswers)/Double(totalQuestion)
        quizProgressionBar.isUserInteractionEnabled = false
        quizProgressionBar.progressViewStyle = .bar
        quizProgressionBar.progress = Float(percentcompleted)
        quizProgressionBar.progressTintColor = UIColor(displayP3Red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        quizProgressionBar.trackTintColor = UIColor(red: 100/255, green: 112/255, blue: 108/255, alpha: 1.0)
        quizProgressionBar.transform = quizProgressionBar.transform.scaledBy(x: 1, y: 3)
        quizProgressionBar.clipsToBounds = true
        quizProgressionBar.layer.cornerRadius = 15.0
    }
    
}


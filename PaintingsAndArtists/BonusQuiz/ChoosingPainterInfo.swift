//
//  ChoosingPainterInfo.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-31.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class ChoosingPainterInfo {
    func selection(artistList: [[String]]) -> (String, String, String, String, String){
        var randomizeArtistList = artistList
        let presentLanguage = NSLocale.preferredLanguages[0]
        let registeredLanguage = UserDefaults.standard.string(forKey: "registeredLanguage")
        var questionIndex = Int()
        var secondPainting = String()
        questionIndex = UserDefaults.standard.integer(forKey: "questionIndex")
        if !questionIndexAlreadyExist(questionIndex: "questionIndex") || questionIndex >= randomizeArtistList.count || presentLanguage != registeredLanguage{
            questionIndex = 0
            UserDefaults.standard.set(questionIndex, forKey: "questionIndex")
            randomizeArtistList.shuffle()
            UserDefaults.standard.set(randomizeArtistList, forKey: "randomizeArtistList")
            UserDefaults.standard.setValue(NSLocale.preferredLanguages[0], forKey: "registeredLanguage")
        }
        questionIndex = UserDefaults.standard.integer(forKey: "questionIndex")
        randomizeArtistList = UserDefaults.standard.array(forKey: "randomizeArtistList") as! [[String]]
        let painterInfo = randomizeArtistList[questionIndex]
        let painterName = painterInfo[5]
        let bioDate = painterInfo[1]
        let bioText = painterInfo[3]
        let firstPainting = painterInfo[14]
        for list in randomizeArtistList{
            if list[5] == painterName && list[14] != firstPainting{
                secondPainting = list[14]
            }
        }
        questionIndex = questionIndex + 1
        UserDefaults.standard.set(questionIndex, forKey: "questionIndex")
        return(painterName, bioDate, firstPainting, bioText, secondPainting)
    }
    func questionIndexAlreadyExist(questionIndex: String) -> Bool {
            return UserDefaults.standard.object(forKey: questionIndex) != nil
    }
}

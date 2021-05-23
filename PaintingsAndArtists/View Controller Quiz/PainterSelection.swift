//
//  PainterSelection.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-07.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
class PainterSelection {
    class func buttonsNameSelection(artistList: [[String]], indexPainting: [Int], painterButton: [UIButton], selectedIndex: Int) -> [String]{
        var otherPainters = [String]()
        var painterNamesForQuiz = [String]()
            for artist in artistList {
            let searchedPainter = artist[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let rightPainter = artistList[indexPainting[selectedIndex]][0].trimmingCharacters(in: .whitespacesAndNewlines)
            if searchedPainter != rightPainter && !otherPainters.contains(searchedPainter) {
                otherPainters.append(searchedPainter)
            }
            
        }
        otherPainters.shuffle()
        for n in 0...2{
            painterNamesForQuiz.append(otherPainters[n])
        }
        painterNamesForQuiz.append(artistList[indexPainting[selectedIndex]][0])
        let finalArrayOfButtonNames: [String] = painterNamesForQuiz.shuffled()
        LabelAndButton.buttonVisible(painterButton: painterButton, finalArrayOfButtonNames: finalArrayOfButtonNames)
        return finalArrayOfButtonNames
    }
}

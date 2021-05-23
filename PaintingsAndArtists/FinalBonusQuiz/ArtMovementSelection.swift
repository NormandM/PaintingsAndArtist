//
//  ArtMovementSelection.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-03-23.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
class ArtMovementSelection {
    class func buttonsNameSelection(artistList: [[String]], indexPainting: [Int], button: [UIButton], selectedIndex: Int) -> [String]{
        var otherMovements = [String]()
        var painterNamesForQuiz = [String]()
        for artist in artistList {
            let searchedArtmovement = artist[10].trimmingCharacters(in: .whitespacesAndNewlines)
            let rightArtMovement = artistList[indexPainting[selectedIndex]][10].trimmingCharacters(in: .whitespacesAndNewlines)
            if searchedArtmovement != rightArtMovement &&
                !otherMovements.contains(searchedArtmovement) {
                otherMovements.append(searchedArtmovement)
            }
        }
        otherMovements.shuffle()
        
        for n in 0...2 {
            painterNamesForQuiz.append(otherMovements[n])
        }
        painterNamesForQuiz.append(artistList[indexPainting[selectedIndex]][10])
        let finalArrayOfButtonNames: [String] = painterNamesForQuiz.shuffled()
        var finalArrayButtonNamesPerLine = [String]()
        for buttonName in finalArrayOfButtonNames {
            let newString = buttonName.replacingOccurrences(of: ",", with: "\n", options: .literal, range: nil)
            finalArrayButtonNamesPerLine.append(newString)
        }
        LabelAndButton.buttonVisible(painterButton: button, finalArrayOfButtonNames: finalArrayButtonNamesPerLine)
        return finalArrayButtonNamesPerLine
    }
}

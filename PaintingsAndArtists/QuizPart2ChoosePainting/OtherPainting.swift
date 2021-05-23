//
//  OtherPainting.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-16.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class OtherPaintings {
    class func choose(artistList: [[String]], painterName: String) -> [String]{
        var otherPaintingsChosen = [String]()
        var randomSelectedOtherTwoPaintings = [String]()
        for paintings in artistList {
            if paintings[0] != painterName{
                otherPaintingsChosen.append(paintings[2])
            }
        }

        otherPaintingsChosen.shuffle()
        for n in 0...1 {
            randomSelectedOtherTwoPaintings.append(otherPaintingsChosen[n])
        }
        return randomSelectedOtherTwoPaintings
    }
}

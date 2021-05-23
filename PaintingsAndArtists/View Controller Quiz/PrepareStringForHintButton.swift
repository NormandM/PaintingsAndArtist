//
//  PrepareStringForHintButton.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-04-30.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
class Prepare {
    class func stringForHinLabel(formatedString: String, formatedString2: String, credit: Int, score: Int, hintButton: UIButton) {
        let firstString =  String(format:formatedString, credit)
        let secondString = String(format: formatedString2, score)
        let hintLabelString = firstString + secondString
        hintButton.setTitle(hintLabelString, for: .normal)
    }
}

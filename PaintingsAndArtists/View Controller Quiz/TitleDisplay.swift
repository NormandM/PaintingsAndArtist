//
//  TitleDisplay.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-03.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class TitleDisplay {
    class func show(labelTitle: UILabel, titleText: String, nextButton: UIButton, view: UIViewController) {
        let fontsAndConstraints = FontsAndConstraints()
        labelTitle.backgroundColor = .clear
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 0
        labelTitle.font = fontsAndConstraints.size().2
        labelTitle.textAlignment = .center
        labelTitle.textColor = .white
        labelTitle.text = titleText
        nextButton.isEnabled = true
        nextButton.isHidden = false
    }
}

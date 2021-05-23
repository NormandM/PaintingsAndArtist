//
//  ArrowForNextButton.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-05-03.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
extension RoundButton {
    func includeArrow() {
        if #available(iOS 13.0, *) {
            let arrow = UIImage(systemName: "arrow.right")
            self.setImage(arrow, for: .normal)
        } else {
            self.setTitle("Ok", for: .normal)
        }
        self.tintColor = .white
    }
}

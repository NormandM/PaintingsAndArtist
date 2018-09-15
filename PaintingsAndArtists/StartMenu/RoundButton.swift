//
//  RoundButton.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-09-12.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
@IBDesignable
class RoundButton: UIButton {

    var x: CGFloat? = 0 {
        didSet {
            if let xExist = x, let yExist = y {
                self.frame = CGRect(x: xExist, y: yExist, width: buttonHeight, height: buttonHeight)
            }
        }
    }
    var y: CGFloat? = 0 {
        didSet {
            if let xExist = x, let yExist = y {
                self.frame = CGRect(x: xExist, y: yExist, width: buttonHeight, height: buttonHeight)

            }
        }
    }
    @IBInspectable var corneRadius: CGFloat = 0 {
        didSet {
            let height = buttonHeight/2
            self.layer.cornerRadius = height
        }
    }
    

    @IBInspectable var buttonHeight: CGFloat = 0 {
        didSet {
            if let xExist = x, let yExist = y {
                self.frame = CGRect(x: xExist, y: yExist, width: buttonHeight, height: buttonHeight)
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
            
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

}


//
//  FontsAndConstraints.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-06-02.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

struct FontsAndConstraints {
    let screenSize = UIScreen.main.bounds
    
    func size() ->  (String, UIFont, UIFont, UIFont, UIFont, UIFont, UIFont, UIFont, CGFloat, CGFloat){
        var screenDimension = String()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let surfaceScreen = screenWidth * screenHeight
        var bioTextConstraint = CGFloat()
        var fontSize = UIFont()
        var fontSize2 = UIFont()
        var fontSize3 = UIFont()
        var fontSize4 = UIFont()
        var fontSize5 = UIFont()
        var fontSize6 = UIFont()
        var fontSize7 = UIFont()
        var collectionViewTopConstraintConstant = CGFloat()
        if surfaceScreen < 200000 {
            screenDimension = "small"
            collectionViewTopConstraintConstant = 0
            bioTextConstraint = 30
            fontSize = UIFont(name: "HelveticaNeue-Italic", size: 12)!
            fontSize2 = UIFont(name: "HelveticaNeue-Bold", size: 12)!
            fontSize3 =  UIFont(name: "Helvetica-LightOblique", size: 12.0)!
            fontSize4 = UIFont(name: "Helvetica-Bold",size: 16.0)!
            fontSize5 = UIFont(name: "HelveticaNeue-Italic",size: 11.0)!
            fontSize6 = UIFont(name: "Helvetica-Bold",size: 11.0)!
            fontSize7 = UIFont(name: "HelveticaNeue",size: 10.0)!
        }else if surfaceScreen > 200000 && surfaceScreen < 304600 {
            screenDimension = "average"
            bioTextConstraint = 50
            collectionViewTopConstraintConstant = 20
            fontSize = UIFont(name: "HelveticaNeue-Italic", size: 14)!
            fontSize2 = UIFont(name: "HelveticaNeue-Bold", size: 14)!
            fontSize3 =  UIFont(name: "Helvetica-LightOblique", size: 14.0)!
            fontSize4 = UIFont(name: "Helvetica-Bold",size: 18.0)!
            fontSize5 = UIFont(name: "HelveticaNeue-Italic",size: 13.0)!
            fontSize6 = UIFont(name: "Helvetica-Bold",size: 10.0)!
            fontSize7 = UIFont(name: "HelveticaNeue",size: 11.0)!
        }else if surfaceScreen > 304600 && surfaceScreen < 700000 {
            screenDimension = "large"
            bioTextConstraint = 50
            collectionViewTopConstraintConstant = 30
            fontSize = UIFont(name: "HelveticaNeue-Italic", size: 16)!
            fontSize2 = UIFont(name: "HelveticaNeue-Bold", size: 16)!
            fontSize3 =  UIFont(name: "Helvetica-LightOblique", size: 16.0)!
            fontSize4 = UIFont(name: "Helvetica-Bold",size: 20.0)!
            fontSize5 = UIFont(name: "HelveticaNeue-Italic",size: 15.0)!
            fontSize6 = UIFont(name: "Helvetica-Bold",size: 12.0)!
            fontSize7 = UIFont(name: "HelveticaNeue",size: 12.0)!
        }else if surfaceScreen > 700000 && surfaceScreen < 800000{
            screenDimension = "extraLarge"
            collectionViewTopConstraintConstant = 40
            bioTextConstraint = 70
            fontSize = UIFont(name: "HelveticaNeue-Italic", size: 23)!
            fontSize2 = UIFont(name: "HelveticaNeue-Bold", size: 25)!
            fontSize3 =  UIFont(name: "Helvetica-LightOblique", size: 25.0)!
            fontSize4 = UIFont(name: "Helvetica-Bold",size: 30.0)!
            fontSize5 = UIFont(name: "HelveticaNeue-Italic",size: 19.0)!
            fontSize6 = UIFont(name: "Helvetica-Bold",size: 18.0)!
            fontSize7 = UIFont(name: "HelveticaNeue",size: 14.0)!
        }else if surfaceScreen > 800000 && surfaceScreen < 1000000{
            screenDimension = "extraExtraLarge"
            bioTextConstraint = 100
            collectionViewTopConstraintConstant = 50
            fontSize = UIFont(name: "HelveticaNeue-Italic", size: 28)!
            fontSize2 = UIFont(name: "HelveticaNeue-Bold", size: 28)!
            fontSize3 =  UIFont(name: "Helvetica-LightOblique", size: 28.0)!
            fontSize4 = UIFont(name: "Helvetica-Bold",size: 32.0)!
            fontSize5 = UIFont(name: "HelveticaNeue-Italic",size: 25.0)!
            fontSize6 = UIFont(name: "Helvetica-Bold",size: 21.0)!
            fontSize7 = UIFont(name: "HelveticaNeue",size: 15.0)!
        }else if surfaceScreen > 1000000{
            screenDimension = "extraExtraExtraLarge"
            collectionViewTopConstraintConstant = 60
            bioTextConstraint = 100
            fontSize = UIFont(name: "HelveticaNeue-Italic", size: 30)!
            fontSize2 = UIFont(name: "HelveticaNeue-Bold", size: 30)!
            fontSize3 =  UIFont(name: "Helvetica-LightOblique", size: 30.0)!
            fontSize4 = UIFont(name: "Helvetica-Bold",size: 32.0)!
            fontSize5 = UIFont(name: "HelveticaNeue-Italic",size: 27.0)!
            fontSize6 = UIFont(name: "Helvetica-Bold",size: 22.0)!
            fontSize7 = UIFont(name: "HelveticaNeue",size: 16.0)!
        }
        let sizeAndFontInfo = (screenDimension: screenDimension, fontSize: fontSize, fontSize2: fontSize2, fontSize3: fontSize3, fontSize4: fontSize4, fontSize5: fontSize5, fontSize6: fontSize6, fontSize7: fontSize7, bioTextConstraint: bioTextConstraint, collectionViewTopConstraintConstant: collectionViewTopConstraintConstant)

        return sizeAndFontInfo

    }
}

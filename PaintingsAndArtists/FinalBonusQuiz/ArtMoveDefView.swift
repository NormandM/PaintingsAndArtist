//
//  ArtMoveDefView.swift
//  PaintingsAndArtists
//
//  Created by NORMAND MARTIN on 2021-04-11.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
class ArtMoveDefView  {
    
    class func showView(view: UIView, artMovementView: UIView, button: RoundButton, artMovementDescriptionTextView: UITextView, titleArtMovementLabel: UILabel){
        let fontsAndConstraints = FontsAndConstraints()
        artMovementView.layer.cornerRadius = 5
        artMovementView.backgroundColor = .black
        view.addSubview(artMovementView)
        artMovementView.layer.borderWidth = 5
        artMovementView.layer.borderColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0).cgColor
        let messageViewWidth = view.frame.width * 0.8
        let messageViewHeight = view.frame.height * 0.8
        let messageXPosition = view.frame.size.width  / 2 - messageViewWidth/2
        let messageYPosition = view.frame.size.height/2 - messageViewHeight/2
        artMovementView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        artMovementView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            artMovementView.alpha = 1.0
            artMovementView.transform = CGAffineTransform.identity
        }
        artMovementView.frame = CGRect(x: messageXPosition, y: messageYPosition , width: messageViewWidth, height: messageViewHeight)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            artMovementDescriptionTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }

        button.titleLabel?.font = fontsAndConstraints.size().2
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.buttonHeight = view.frame.height * 0.075
        button.corneRadius = (view.frame.height * 0.1)/2
        button.x = messageViewWidth/2 - button.buttonHeight/2
        button.y = messageViewHeight * 0.85
        button.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        
    }
    class func dismissView (artMovementView: UIView){
        UIView.animate(withDuration: 0.8, animations: {
            artMovementView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            artMovementView.alpha = 0
        }) { (success: Bool) in
            artMovementView.removeFromSuperview()
        }
        
    }
}

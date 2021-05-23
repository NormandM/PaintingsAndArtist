//
//  ArtMovementView.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-03-17.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit
class ArtMovementView {
    class func showView(view: UIView, artMovementView: UIView, visualEffect: UIVisualEffectView, effect:UIVisualEffect, button: RoundButton, artMovementDescriptionTextView: UITextView){
        let fontsAndConstraints = FontsAndConstraints()
        artMovementView.layer.cornerRadius = 5
      //  artMovementView.backgroundColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 0.8)
        artMovementView.backgroundColor = .black
        view.addSubview(artMovementView)
        artMovementView.layer.borderWidth = 5
        artMovementView.layer.borderColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0).cgColor
        let messageViewWidth = view.frame.width * 0.9
        let messageViewHeight = view.frame.height * 0.8
        let messageXPosition = view.frame.size.width  / 2 - messageViewWidth/2
        let messageYPosition = view.frame.size.height/2 - messageViewHeight/2
        artMovementView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        artMovementView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            visualEffect.effect = effect
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
    class func dismissView (artMovementView: UIView, visualEffect: UIVisualEffectView, effect:UIVisualEffect){
        UIView.animate(withDuration: 0.8, animations: {
            artMovementView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            artMovementView.alpha = 0
            visualEffect.effect = nil
        }) { (success: Bool) in
            artMovementView.removeFromSuperview()
        }
        
    }
}

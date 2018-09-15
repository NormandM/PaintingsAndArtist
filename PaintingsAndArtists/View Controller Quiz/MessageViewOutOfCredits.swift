//
//  MessageViewOutOfCredits.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-09-10.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import Foundation
import UIKit
class MessageOutOfCredits{
    class func showMessageView(view: UIView, messageView: UIView, visualEffect: UIVisualEffectView, effect:UIVisualEffect, messageLabel: UILabel, okBuyCreditsButton: RoundButton){
        let fontsAndConstraints = FontsAndConstraints()
        messageView.layer.cornerRadius = 5
        messageView.backgroundColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 0.7)
        view.addSubview(messageView)
        messageView.layer.borderWidth = 5
        messageView.layer.borderColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0).cgColor
        let messageViewWidth = view.frame.width * 0.5
        let messageViewHeight = view.frame.height * 0.5
        let messageXPosition = view.frame.size.width  / 2 - messageViewWidth/2
        let messageYPosition = view.frame.size.height/2 - messageViewHeight/2
        messageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        messageView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            visualEffect.effect = effect
            messageView.alpha = 1.0
            messageView.transform = CGAffineTransform.identity
        }
        messageView.frame = CGRect(x: messageXPosition, y: messageYPosition , width: messageViewWidth, height: messageViewHeight)
        messageLabel.font = fontsAndConstraints.size().2
        okBuyCreditsButton.titleLabel?.textAlignment = NSTextAlignment.center
        okBuyCreditsButton.titleLabel?.numberOfLines = 0
        okBuyCreditsButton.titleLabel?.font = fontsAndConstraints.size().2
        okBuyCreditsButton.buttonHeight = view.frame.height * 0.075
        okBuyCreditsButton.corneRadius = (view.frame.height * 0.1)/2
        okBuyCreditsButton.x = messageViewWidth/2 - okBuyCreditsButton.buttonHeight/2
        okBuyCreditsButton.y = messageViewHeight * 0.8
        okBuyCreditsButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
    }
    class func dismissMessageview(messageView: UIView, visualEffect: UIVisualEffectView, effect:UIVisualEffect) {
        UIView.animate(withDuration: 0.8, animations: {
            messageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            messageView.alpha = 0
            visualEffect.effect = nil
        }) { (success: Bool) in
            messageView.removeFromSuperview()
        }
    }
}



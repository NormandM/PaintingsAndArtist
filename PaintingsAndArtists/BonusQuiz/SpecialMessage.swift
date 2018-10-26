//
//  MessageView.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-15.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class MessageView {
    class func showMessageView(view: UIView, messageView: UIView, button: RoundButton, visualEffect: UIVisualEffectView, effect:UIVisualEffect, diplomaImageView: UIImageView?, commentAfterResponse: UILabel, nextLevel: UILabel, responseRatio: UILabel) {
        let fontsAndConstraints = FontsAndConstraints()
        let successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
        messageView.layer.cornerRadius = 5
        messageView.backgroundColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 0.7)
        view.addSubview(messageView)
        messageView.layer.borderWidth = 5
        messageView.layer.borderColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0).cgColor
        
        commentAfterResponse.font = fontsAndConstraints.size().2
        nextLevel.font = fontsAndConstraints.size().1
        responseRatio.font = fontsAndConstraints.size().7
        let messageViewWidth = view.frame.width * 0.7
        var messageViewHeight = view.frame.height * 0.7
        var messageXPosition = view.frame.size.width  / 2 - messageViewWidth/2
        var messageYPosition = view.frame.size.height/2 - messageViewHeight/2
        messageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        messageView.alpha = 0
        UIView.animate(withDuration: 0.8) {
            visualEffect.effect = effect
            messageView.alpha = 1.0
            messageView.transform = CGAffineTransform.identity
        }
        messageView.frame = CGRect(x: messageXPosition, y: messageYPosition , width: messageViewWidth, height: messageViewHeight)
        var imageName = String()
        button.titleLabel?.font = fontsAndConstraints.size().2
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.buttonHeight = view.frame.height * 0.075
        button.corneRadius = (view.frame.height * 0.1)/2
        button.x = messageViewWidth/2 - button.buttonHeight/2
        button.y = messageViewHeight * 0.85
        button.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        
        switch successiveRightAnswers {
        case 5:
            imageName = "artist"
        case 15:
            imageName = "exhibition2"
        case 30:

            imageName = "artExpert3"
        case 50:
            imageName = "mortarboard"
            
        default:
            messageViewHeight = view.frame.height * 0.7
            messageXPosition = view.frame.size.width  / 2 - messageViewWidth/2
            messageYPosition = view.frame.size.height/2 - messageViewHeight/2
            button.y = messageViewHeight * 0.85

        }
        if let diplomaView = diplomaImageView {
            ImageManager.choosImage(imageView: diplomaView, imageName: imageName)
        }


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

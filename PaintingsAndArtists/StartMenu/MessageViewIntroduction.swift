//
//  MessageViewIntroduction.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-09-10.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class IntroductionMessage {
    class func showMessageView(view: UIView, messageView: UIView, visualEffect: UIVisualEffectView, effect:UIVisualEffect, learnArtLabel: UILabel, slideShowButton: UIButton, starHereLabel: UILabel, quizButton: UIButton, testYourKnowledgeLabel: UILabel, allTheDataButton: UIButton, consultAndLearnLabel: UILabel, manageYourCreditsButton: UIButton){
        let fontsAndConstraints = FontsAndConstraints()
        messageView.layer.cornerRadius = 5
        messageView.backgroundColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 0.7)
        view.addSubview(messageView)
        messageView.layer.borderWidth = 5
        messageView.layer.borderColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0).cgColor
        let messageViewWidth = view.frame.width * 0.7
        let messageViewHeight = view.frame.height * 0.6
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
        learnArtLabel.font = fontsAndConstraints.size().4
        slideShowButton.titleLabel?.font = fontsAndConstraints.size().2
        quizButton.titleLabel?.font = fontsAndConstraints.size().2
        allTheDataButton.titleLabel?.font = fontsAndConstraints.size().2
        manageYourCreditsButton.titleLabel?.font = fontsAndConstraints.size().2
        starHereLabel.font = fontsAndConstraints.size().7
        testYourKnowledgeLabel.font = fontsAndConstraints.size().7
        consultAndLearnLabel.font = fontsAndConstraints.size().7
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


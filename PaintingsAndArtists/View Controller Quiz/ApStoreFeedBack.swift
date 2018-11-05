//
//  ApStoreFeedBack.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-11-05.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import Foundation
import StoreKit

class AppStoreFeedBack {
    class func askForFeedback() {
        let score = UserDefaults.standard.integer(forKey: "score")
        var askAt20IsDone = UserDefaults.standard.bool(forKey: "askAt20IsDone")
        var askAt50IsDone = UserDefaults.standard.bool(forKey: "askAt50IsDone")
        var askAt100IsDone = UserDefaults.standard.bool(forKey: "askAt100IsDone")
        if #available( iOS 10.3,*){
            if score > 20 && askAt20IsDone ==  false {
                SKStoreReviewController.requestReview()
                askAt20IsDone = true
                UserDefaults.standard.set(askAt20IsDone, forKey: "askAt20IsDone")
            }else if score > 50 && askAt50IsDone ==  false {
                SKStoreReviewController.requestReview()
                askAt50IsDone = true
                UserDefaults.standard.set(askAt50IsDone, forKey: "askAt50IsDone")
            }else if score > 100 && askAt100IsDone ==  false {
                SKStoreReviewController.requestReview()
                askAt100IsDone = true
                UserDefaults.standard.set(askAt100IsDone, forKey: "askAt100IsDone")
            }
        }
    }
    
}

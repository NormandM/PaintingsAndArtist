//
//  ActivityIndicator.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-09-19.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import Foundation
//class ActivityIndicatorView
//{
//    var view: UIView!
//    
//    var activityIndicator: UIActivityIndicatorView!
//    
//    var title: String!
//    
//    init(title: String, center: CGPoint, width: CGFloat = 300.0, height: CGFloat = 50.0)
//    {
//        self.title = title
//        let x = center.x - width/2.0
//        let y = center.y - height/2.0 - 20
//        
//        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
//        self.view.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
//        self.view.layer.cornerRadius = 10
//        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        self.activityIndicator.color = UIColor.black
//        self.activityIndicator.hidesWhenStopped = false
//        
//        let titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
//        titleLabel.text = title
//        titleLabel.textColor = UIColor.white
//        
//        self.view.addSubview(self.activityIndicator)
//        self.view.addSubview(titleLabel)
//    }
//    
//    func getViewActivityIndicator() -> UIView
//    {
//        return self.view
//    }
//    
//    func startAnimating()
//    {
//        self.activityIndicator.startAnimating()
//       // UIApplication.shared.beginIgnoringInteractionEvents()
//        self.view.isUserInteractionEnabled = false
//    }
//    
//    func stopAnimating()
//    {
//        self.activityIndicator.stopAnimating()
//    //    UIApplication.shared.endIgnoringInteractionEvents()
//        self.view.isUserInteractionEnabled = true
//        
//        
//        self.view.removeFromSuperview()
//    }
//    //end
//}

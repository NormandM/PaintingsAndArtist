//
//  infoAndImageViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-05-23.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class infoAndImageViewController: UIViewController, UIScrollViewDelegate {
    
    let labelTitle = UILabel(frame: CGRect(x:0, y:0, width:1000, height:50))
    @IBOutlet weak var biotextLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var biotextTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideShowUIImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var artistName: UILabel!
    var isFromQuiz = Bool()
    var isFromMenu = Bool()
    var isFromSlideShow = Bool()
    var specificArtistInfo: Int?
    var artistList: [[String]] = []
    var artistsCount = 0
    var bioInfoEra = String()
    var bioInfoBio = String()
    var bioInfoImageName = String()
    var goingForwards = Bool()
    var n = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        if let info = specificArtistInfo {
            n = info
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: UIBarButtonItem.Style.plain, target: self, action: #selector(returnToSlideShow))
            navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            swipeLeft.isEnabled = false
            swipeRight.isEnabled = false
            
        }
        let fontsAndConstraints = FontsAndConstraints()
        labelTitle.backgroundColor = .clear
        labelTitle.numberOfLines = 2
        labelTitle.font = fontsAndConstraints.size().2
        labelTitle.textAlignment = .center
        labelTitle.textColor = .white
        self.navigationItem.titleView = labelTitle
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: fontsAndConstraints.size().4], for: UIControl.State.normal)
        biotextLeadingConstraint.constant = fontsAndConstraints.size().8
        biotextTrailingConstraint.constant = fontsAndConstraints.size().8
        bioTextView.layer.borderWidth = 2
        bioTextView.layer.borderColor = UIColor.white.cgColor
        bioTextView.textContainerInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 20, right: 20)
        bioTextViewFormat()
        scrollView.delegate = self
        artistName.font = fontsAndConstraints.size().4
        dateLabel.font = fontsAndConstraints.size().2
        bioTextView.font = fontsAndConstraints.size().1
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if goingForwards == false {
            performSegue(withIdentifier: "goToMenu", sender: self)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let fontsAndConstraints = FontsAndConstraints()
        labelTitle.backgroundColor = .clear
        labelTitle.numberOfLines = 2
        labelTitle.font = fontsAndConstraints.size().2
        labelTitle.textAlignment = .center
        labelTitle.textColor = .white
        self.navigationItem.titleView = labelTitle
        bioTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return slideShowUIImageView
    }


    func bioTextViewFormat() {
        if !isFromQuiz{
            bioTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            labelTitle.text =  artistList[n][2]
            artistName.text = artistList[n][0]
            dateLabel.text = artistList[n][1]
            bioTextView.text = """
            \(artistList[n][3])
            Ref: \(artistList[n][4])
            """
            ImageManager.choosImage(imageView: slideShowUIImageView, imageName: artistList[n][2])
        }else{
            dateLabel.text = bioInfoEra
            bioTextView.text = """
            \(bioInfoBio)
            """
            artistName.text = ""
            ImageManager.choosImage(imageView: slideShowUIImageView, imageName: bioInfoImageName)

        }

        
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            UIView.animate(withDuration: 0.5, animations: {
                let slideShowUIImageViewFrame = self.slideShowUIImageView.frame
                let maxSlideShowUIImageView =  slideShowUIImageViewFrame.maxX
                self.slideShowUIImageView.transform = CGAffineTransform(translationX: maxSlideShowUIImageView - maxSlideShowUIImageView/5, y: 0)}, completion:{finished in translate()})

        }else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            UIView.animate(withDuration: 0.5, animations: {
                let slideShowUIImageViewFrame = self.slideShowUIImageView.frame
                let maxSlideShowUIImageView =  slideShowUIImageViewFrame.maxX
                self.slideShowUIImageView.transform = CGAffineTransform(translationX: maxSlideShowUIImageView/5 - maxSlideShowUIImageView , y: 0)}, completion:{finished in translate()})
            
        }
        func translate() {
            if gesture.direction == UISwipeGestureRecognizer.Direction.right {
                if n > 0 {
                    if labelTitle.text !=  artistList[n][2] { n = n - 1}
                    n = n - 1
                    bioTextViewFormat()
                }else{
                    n = artistList.count - 1
                    bioTextViewFormat()
                }
                
            }
            else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
                if n < artistsCount - 1 {
                    if labelTitle.text ==  artistList[n][2] { n = n + 1}
                    bioTextViewFormat()
                    n = n + 1
                }else{
                    n = 0
                    bioTextViewFormat()
                }
            }
            slideShowUIImageView.transform = CGAffineTransform.identity
        }

    }

    // MARK: - Navigation

    @objc func returnToSlideShow() {
        goingForwards = true
        if isFromQuiz {
            performSegue(withIdentifier: "goBackToQuiz", sender: self)
        }else if isFromMenu {
            performSegue(withIdentifier: "goToMenu", sender: self)
        }else if isFromSlideShow{
            performSegue(withIdentifier: "goBackToSlideShow", sender: self)
        }
        
    }


}

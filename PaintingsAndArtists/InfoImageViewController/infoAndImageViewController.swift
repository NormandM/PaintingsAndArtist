//
//  infoAndImageViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-05-23.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class infoAndImageViewController: UIViewController, UIScrollViewDelegate {
    var labelTitle = UILabel()
    @IBOutlet var artMovementDefinitionView: UIView!
    @IBOutlet weak var biotextLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var biotextTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideShowUIImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var artMovementButton: UIButton!
    @IBOutlet weak var OkButtom: RoundButton!
    @IBOutlet weak var artMovementDescriptionTextView: UITextView!
    @IBOutlet weak var thirdArtMovementButton: UIButton!
    @IBOutlet weak var secondArtMovementButton: UIButton!
    @IBOutlet weak var titleArtMovementLabel: UILabel!
    let customFont = FontsAndConstraints()
    var effect: UIVisualEffect!
    var isFromQuiz = Bool()
    var isFromMenu = Bool()
    var isFromSlideShow = Bool()
    var isFromFinalBonusQuiz = Bool()
    var specificArtistInfo: Int?
    var artistList: [[String]] = []
    var artMovementDic = [String: [String]]()
    var artistsCount = 0
    var bioInfoEra = String()
    var bioInfoBio = String()
    var nameOfArtist = String()
    var bioInfoImageName = String()
    var goingForwards = Bool()
    var n = 0
    var trimedArrayMovement = [String]()
    var noWhiteSpaceArrayMovement = [String]()
    var isFromView = IsFromView.infoAndImage
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
        labelTitle = UILabel(frame: CGRect(x:0, y:0, width: 0, height:50))
        labelTitle.backgroundColor = .clear
        labelTitle.numberOfLines = 0
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
        if let plistPath = Bundle.main.path(forResource: "ArtMovements".localized, ofType: "plist"),
            let movement = NSDictionary(contentsOfFile: plistPath){
            artMovementDic = movement as! [String: [String]]
        }
        bioTextViewFormat()
        scrollView.delegate = self
        artistName.font = fontsAndConstraints.size().4
        dateLabel.font = fontsAndConstraints.size().2
        bioTextView.font = fontsAndConstraints.size().1
        artMovementButton.titleLabel?.font =  fontsAndConstraints.size().2
        artMovementButton.titleLabel?.lineBreakMode = .byWordWrapping
        artMovementButton.titleLabel?.numberOfLines = 2
        artMovementButton.titleLabel?.textAlignment = .center
        effect = visualEffect.effect
        artMovementDescriptionTextView.layer.cornerRadius = 5
        artMovementDescriptionTextView.layer.borderWidth = 2
        artMovementDescriptionTextView.layer.borderColor = UIColor.white.cgColor
            titleArtMovementLabel.font = customFont.size().2
        artMovementDescriptionTextView.textContainerInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 20, right: 20)
        artMovementDescriptionTextView.font = customFont.size().3
        visualEffect.effect = nil
        OkButtom.includeArrow()
        
        
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
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        ArtMovementView.showView(view: view, artMovementView: artMovementDefinitionView, visualEffect: visualEffect, effect: effect, button: OkButtom, artMovementDescriptionTextView: artMovementDescriptionTextView)
        OkButtom.includeArrow()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return slideShowUIImageView
    }


    func bioTextViewFormat() {
        trimedArrayMovement = [String]()
        noWhiteSpaceArrayMovement = [String]()
        switch isFromView {
        case .infoAndImage, .slideShow:
            bioTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            artMovementButton.setTitle(artistList[n][10], for: .normal)
            labelTitle.text =  artistList[n][14]
            artistName.text = artistList[n][0]
            dateLabel.text = artistList[n][1]
            trimedArrayMovement = artistList[n][10].components(separatedBy: ",")
            
            for movement in trimedArrayMovement {
               let str =  movement.trimmingCharacters(in: .whitespacesAndNewlines)
                noWhiteSpaceArrayMovement.append(str)
            }
            
            artMovementDescriptionTextView.text = """
                    \(artMovementDic[noWhiteSpaceArrayMovement[0]]![0])
                    Ref: \(artMovementDic[noWhiteSpaceArrayMovement[0]]![1])
                """
            bioTextView.text = """
            \(artistList[n][3])
            Ref: \(artistList[n][4])
            """
            ImageManager.choosImage(imageView: slideShowUIImageView, imageName: artistList[n][2])
            titleArtMovementLabel.text = noWhiteSpaceArrayMovement[0]
            switch trimedArrayMovement.count {
            case 1:
                secondArtMovementButton.isHidden = true
                thirdArtMovementButton.isHidden = true
            case 2:
                secondArtMovementButton.isHidden = false
                thirdArtMovementButton.isHidden = true
                secondArtMovementButton.setTitle(noWhiteSpaceArrayMovement[1], for: .normal)
            default:
                secondArtMovementButton.isHidden = false
                thirdArtMovementButton.isHidden = false
                secondArtMovementButton.setTitle(noWhiteSpaceArrayMovement[1], for: .normal)
                thirdArtMovementButton.setTitle(noWhiteSpaceArrayMovement[2], for: .normal)
            }
        case .quizController:
            artMovementButton.isHidden = true
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
                    if labelTitle.text !=  artistList[n][14] { n = n - 1}
                    n = n - 1
                    bioTextViewFormat()
                }else{
                    n = artistList.count - 1
                    bioTextViewFormat()
                }
                
            }
            else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
                if n < artistsCount - 1 {
                    if labelTitle.text ==  artistList[n][14] { n = n + 1}
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

    @IBAction func arteMovementButtonAction(_ sender: UIButton) {
        ArtMovementView.showView(view: view, artMovementView: artMovementDefinitionView, visualEffect: visualEffect, effect: effect, button: OkButtom, artMovementDescriptionTextView: artMovementDescriptionTextView)
        artMovementButton.isHidden = true
        bioTextView.isHidden = true
    }
    @IBAction func okButtonPressed(_ sender: RoundButton) {
        ArtMovementView.dismissView(artMovementView: artMovementDefinitionView, visualEffect: visualEffect, effect: effect)
        artMovementButton.isHidden = false
        bioTextView.isHidden = false
    }
    @IBAction func secondArtMovementButtonPressed(_ sender: UIButton) {
        
        if trimedArrayMovement.count > 2 {
            thirdArtMovementButton.setTitle(trimedArrayMovement[2], for: .normal)
        }
        if titleArtMovementLabel.text == noWhiteSpaceArrayMovement[1] {
            titleArtMovementLabel.text = noWhiteSpaceArrayMovement[0]
            artMovementDescriptionTextView.text = """
                \(artMovementDic[noWhiteSpaceArrayMovement[0]]![0])
                Ref: \(artMovementDic[noWhiteSpaceArrayMovement[0]]![1])
            """
            secondArtMovementButton.setTitle(trimedArrayMovement[1], for: .normal)
        }else{
            titleArtMovementLabel.text = noWhiteSpaceArrayMovement[1]
            artMovementDescriptionTextView.text = """
                \(artMovementDic[noWhiteSpaceArrayMovement[1]]![0])
                Ref: \(artMovementDic[noWhiteSpaceArrayMovement[1]]![1])
            """
            secondArtMovementButton.setTitle(trimedArrayMovement[0], for: .normal)
        }
    }
    @IBAction func thirdartMovementButtonPressed(_ sender: UIButton) {
        secondArtMovementButton.setTitle(noWhiteSpaceArrayMovement[1], for: .normal)
        if titleArtMovementLabel.text == noWhiteSpaceArrayMovement[2] {
            titleArtMovementLabel.text =  noWhiteSpaceArrayMovement[0]
            artMovementDescriptionTextView.text = """
                \(artMovementDic[noWhiteSpaceArrayMovement[0]]![0])
                Ref: \(artMovementDic[noWhiteSpaceArrayMovement[0]]![1])
            """
            thirdArtMovementButton.setTitle(noWhiteSpaceArrayMovement[2], for: .normal)
        }else{
            titleArtMovementLabel.text =  noWhiteSpaceArrayMovement[2]
            artMovementDescriptionTextView.text = """
                \(artMovementDic[noWhiteSpaceArrayMovement[2]]![0])
                Ref: \(artMovementDic[noWhiteSpaceArrayMovement[2]]![1])
            """
            thirdArtMovementButton.setTitle(noWhiteSpaceArrayMovement[0], for: .normal)
        }
        
        
    }
    
    
}

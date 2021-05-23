//
//  FinalBonusQuizViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-03-23.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit

class FinalBonusQuizViewController: UIViewController {
    let labelTitle = UILabel(frame: CGRect(x:0, y:0, width:1000, height:50))
    
    
    
    @IBOutlet var hintItemButton: [UIButton]!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var placeHolderButton: UIButton!
    
    @IBOutlet weak var paintingImage1: UIImageView!
    @IBOutlet weak var paintingImage2: UIImageView!
    @IBOutlet var artMovementButton: [UIButton]!
    @IBOutlet weak var nextButton: RoundButton!
    @IBOutlet weak var okBuyCreditsButton: RoundButton!
    @IBOutlet var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    weak var movingButton: UIButton?
    @IBOutlet weak var infoPainterInfo: UILabel!
    var soundPlayer: SoundPlayer?
    var errorCounter = 0
    var otherPaintingNameForSameArtist = String()
    let fontsAndConstraints = FontsAndConstraints()
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
    var blurView = UIVisualEffectView()
    var score = UserDefaults.standard.integer(forKey: "score")
    var artistList: [[String]] = []
    var indexPainting: [Int] = UserDefaults.standard.array(forKey: "indexPainting") as! [Int]
    var selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
    var arrayButtonLabels = [String]()
    var successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
    var isFromQuiz = Bool()
    var isFromMenu = Bool()
    var isFromSlideShow = Bool()
    var isFromFinalBonusQuiz = Bool()
    var goingForwards = Bool()
    let formatedString = NSLocalizedString("%lld Coins for Hints", comment: "")
    let formatedString2 = NSLocalizedString("  -  Score = %lld", comment: "")
    var isAnswerGood = Bool()
    var artMovementDic = [String: [String]]()
    var credit = UserDefaults.standard.integer(forKey: "credit"){
        didSet{
            if credit < 1 {
                nextButton.isEnabled = false
                nextButton.isHidden = true
                blurView = UIVisualEffectView(effect: blur)
                blurView.frame = self.view.bounds
                view.addSubview(blurView)
                MessageOutOfCredits2.showMessageView(view: view, messageView: messageView,  messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
                hintButton.isHidden = true
            }
        }
    }
    var soundState = ""{
        didSet{
            if #available(iOS 13.0, *) {
                navigationItem.rightBarButtonItems = [UIBarButtonItem(
                    image: UIImage(systemName: soundState),
                    style: .plain,
                    target: self,
                    action: #selector(soundOnOff)
                )]
            } else {
                // Fallback on earlier versions
            }
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.layer.cornerRadius = 5
        placeHolderButton.isHidden = true
        placeHolderButton.isEnabled = false
        nextButton.isHidden = true
        nextButton.isEnabled = false
        hintButton.layer.cornerRadius = hintButton.frame.height / 2.0
        hintItemButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
            eachButton.isHidden = true
        }
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        credit = UserDefaults.standard.integer(forKey: "credit")
        score = UserDefaults.standard.integer(forKey: "score")
        hintButton.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        let allPaintingInfos = AllPaintingInfo(paintingsInfo: artistList, item: indexPainting[selectedIndex])
        let formatedString = NSLocalizedString("Can you identify the art movement(s) %@ was part of?", comment: "")
        infoPainterInfo.text = String(format: formatedString, allPaintingInfos.artistName)
        
        ImageManager.choosImage(imageView: paintingImage1, imageName: artistList[indexPainting[selectedIndex]][2])
        ImageManager.choosImage(imageView: paintingImage2, imageName: otherPaintingNameForSameArtist)
        arrayButtonLabels = ArtMovementSelection.buttonsNameSelection(artistList: artistList, indexPainting: indexPainting, button: artMovementButton, selectedIndex: selectedIndex)
        if let soundStateTrans = UserDefaults.standard.string(forKey: "soundState"){
            soundState = soundStateTrans
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "What is the Art movement?".localized, attributes:[
                                                    NSAttributedString.Key.foregroundColor: UIColor.white,
                                                    NSAttributedString.Key.font: sizeInfoAndFonts?.fontSize4 ?? UIFont(name: "HelveticaNeue-Bold", size: 12)!])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        infoPainterInfo.font = sizeInfoAndFonts?.fontSize4
        artMovementButton.forEach {(eachButton) in
            eachButton.titleLabel?.numberOfLines = 0
            eachButton.titleLabel?.font = sizeInfoAndFonts?.fontSize1
        }

        Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        nextButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        hintItemButton.forEach {(eachButton) in
            eachButton.titleLabel?.font = sizeInfoAndFonts?.fontSize1
        }
        hintButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        okBuyCreditsButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        messageLabel.font = sizeInfoAndFonts?.fontSize2
        credit = UserDefaults.standard.integer(forKey: "credit")
        if credit < 1 {
            nextButton.isEnabled = false
            nextButton.isHidden = true
            blurView = UIVisualEffectView(effect: blur)
            blurView.frame = self.view.bounds
            view.addSubview(blurView)
            MessageOutOfCredits2.showMessageView(view: view, messageView: messageView,  messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
            hintButton.isHidden = true
        }
        nextButton.includeArrow()
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let theButton = movingButton {
            theButton.transform = CGAffineTransform.identity
            ButtonTranslation.translate(fromButton: theButton, toButton: placeHolderButton, painterName: artistList[indexPainting[selectedIndex]][0])
        }
        if self.messageView.isDescendant(of: self.view) {
            blurView = UIVisualEffectView(effect: blur)
            blurView.frame = self.view.bounds
            view.addSubview(blurView)
            MessageOutOfCredits2.showMessageView(view: view, messageView: messageView,  messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
            hintButton.isHidden = true
        }
        
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.includeArrow()
    }
    
    @IBAction func okButt5onPushed(_ sender: RoundButton) {
        executeSegue()
    }
    
    @IBAction func artmoVementButtonPushed(_ sender: UIButton) {
               soundPlayer = SoundPlayer()
        if let artMovmentButtonTitle = sender.titleLabel?.text {
            let artMovementPerLine = artistList[indexPainting[selectedIndex]][10].replacingOccurrences(of: ",", with: "\n", options: .literal, range: nil)
            if artMovmentButtonTitle == artMovementPerLine{
                for button in artMovementButton {
                    if button.titleLabel?.text != artMovmentButtonTitle{
                        button.isEnabled = false
                        button.isHidden  = true
                    }
                }
                movingButton = sender
                soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
                ButtonTranslation.translate(fromButton: sender, toButton: placeHolderButton, painterName: artMovmentButtonTitle)
                nextButton.isEnabled = true
                nextButton.isHidden = false
                CreditManagment.increaseOneCredit(hintButton: hintButton)
                infoPainterInfo.text = "Great, You are right!".localized
                credit =  UserDefaults.standard.integer(forKey: "credit")
                isAnswerGood = true
            }else{
                let shake = Shake()
                shake.shakeViewHorizontal(vw: sender)
                soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
                CreditManagment.decreaseTwoCredit(hintButton: hintButton)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    sender.isEnabled = false
                    sender.isHidden = true
                    
                    if self.errorCounter > 2 {
                        LabelAndButton.buttonInvisible(painterButton: self.artMovementButton, errorMessage: nil)
                        let formatedString3 = NSLocalizedString("Sorry...\nThe right answer is : %@", comment: "")
                     //   self.errorMessage.isHidden = false
                        self.infoPainterInfo.text = String(format: formatedString3, self.artistList[self.indexPainting[self.selectedIndex]][10])

                        self.successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                        self.successiveRightAnswers = SuccessiveAnswer.afterMistake(successiveRightAnswers: self.successiveRightAnswers)
                        UserDefaults.standard.set(self.successiveRightAnswers, forKey: "successiveRightAnswers")
                        self.selectedIndex = self.selectedIndex + 1
                        UserDefaults.standard.set(self.selectedIndex, forKey: "selectedIndex")
                        if self.credit > 0 {
                            self.nextButton.isEnabled = true
                            self.nextButton.isHidden = false
                        }
                        
                        self.nextButton.includeArrow()
                        LabelAndButton.disableHintButtons(hintItemButton: self.hintItemButton)
                        
                    }
                }
                errorCounter = errorCounter + 1
                isAnswerGood = false
            }
        }
        credit = UserDefaults.standard.integer(forKey: "credit")
        score = UserDefaults.standard.integer(forKey: "score")
        Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
    }
    @IBAction func hintMenuPressed(_ sender: UIButton) {
        hintMenuAction()
    }
    @IBAction func specificHintPressed(_ sender: UIButton) {
        if credit < 1 {
            nextButton.isEnabled = false
            nextButton.isHidden = true
            blurView = UIVisualEffectView(effect: blur)
            blurView.frame = self.view.bounds
            view.addSubview(blurView)
            MessageOutOfCredits2.showMessageView(view: self.view, messageView: messageView, messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
        }else if let buttonLabel = sender.titleLabel?.text {
            if buttonLabel != HintLabel.buyCoins.rawValue.localized {
                let oneMovementPerLine = artistList[indexPainting[selectedIndex]][10].replacingOccurrences(of: ",", with: "\n", options: .literal, range: nil)
            let dropTwoMouvementCount =    Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: arrayButtonLabels, painterName: oneMovementPerLine, painterButton: artMovementButton, placeHolderButton: placeHolderButton, labelTitle: labelTitle, view: self, nextButton: nextButton, titleText: artistList[indexPainting[selectedIndex]][14], hintButton: hintButton, showActionView: showActionView)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                score = UserDefaults.standard.integer(forKey: "score")
                hintButton.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
                Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
                errorCounter = errorCounter + dropTwoMouvementCount
            }else{
                performSegue(withIdentifier: "showBuyCredits", sender: self)
            }
        }
        if let buttonLabel = sender.titleLabel?.text{
            if buttonLabel != HintLabel.buyCoins.rawValue.localized{
                LabelAndButton.disableHintButtons(hintItemButton: hintItemButton)
            }
        }
        hintMenuAction()
        Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
    }
    
    @IBAction func nextButtonPushed(_ sender: RoundButton) {
        if isAnswerGood {
            performSegue(withIdentifier: "showBonusQuiz", sender: self)
        }else{
            performSegue(withIdentifier: "goBackToQuizViwController", sender: self)
        }
        
    }
    
    
    func hintMenuAction() {
        hintItemButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = !eachButton.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    func showActionView() {
        performSegue(withIdentifier: "showArtMovementTable", sender: self)
    }
    func executeSegue () {
        MessageOutOfCredits2.dismissMessageview(messageView: messageView)
        blurView.removeFromSuperview()
        nextButton.isHidden = true
        performSegue(withIdentifier: "showBuyCredits", sender: self)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "showArtMovementTable" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            backItem.tintColor = UIColor.white
            let controller = segue.destination as! ArtMovementTableViewController
            controller.artMovementDic = artMovementDic
            
        }
        if segue.identifier == "showBonusQuiz" {
            selectedIndex = selectedIndex + 1
            UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
            selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
            goingForwards = true
            let controller = segue.destination as! BonusQuizViewController
            controller.artistList = artistList
            let backItem = UIBarButtonItem()
            controller.navigationItem.hidesBackButton = true
            backItem.title = ""
            hintButton.isHidden = true
            
        }
        if segue.identifier == "showBuyCredits" {
            goingForwards = true
            let controller = segue.destination as! BuyCreditViewController
            controller.provenance = "finalBonusQuiz"
            let backItem = UIBarButtonItem()
            controller.navigationItem.hidesBackButton = true
            backItem.title = ""
            
        }
    }
    @IBAction func unwindToFinalBonusQuiz (_ sender: UIStoryboardSegue) {
        
    }
    @objc func soundOnOff() {
        soundState = SoundOption.soundOnOff()
    }

}

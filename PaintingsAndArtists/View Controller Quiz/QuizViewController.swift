//
//  ViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-05-20.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit
import StoreKit

class QuizViewController: UIViewController,  GKGameCenterControllerDelegate {

    @IBOutlet weak var labelForTitle: UILabel!
    var navLabel = UILabel()
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var buyCreditsButton: UIButton!
    @IBOutlet weak var paintingImage: UIImageView!
    @IBOutlet var painterButton: [UIButton]!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet var hintItemButton: [UIButton]!
    @IBOutlet weak var placeHolderButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nextButton: RoundButton!
    @IBOutlet weak var okBuyCreditsButton: RoundButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var messageView: UIView!
    weak var movingButton: UIButton?
    let fontsAndConstraints = FontsAndConstraints()
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    var effect: UIVisualEffect!
    var partThreeOfQuizDone: Bool = false
    var soundPlayer: SoundPlayer?
    var finalArrayOfButtonNames = [String]()
    var artistList: [[String]] = []
    var indexPainting: [Int] = []
    var artMovementDic = [String: [String]]()
    var selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
    var errorCounter = 0
    var isFromQuiz = Bool()
    var isFromMenu = Bool()
    var isFromSlideShow = Bool()
    var isFromFinalBonusQuiz = Bool()
    var goingForwards = Bool()
    var score = UserDefaults.standard.integer(forKey: "score")
    let localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    var successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
    let formatedString = NSLocalizedString("%lld Coins for Hints", comment: "")
    let formatedString2 = NSLocalizedString("  -  Score = %lld", comment: "")
    var isFromView = IsFromView.quizController
    var credit = UserDefaults.standard.integer(forKey: "credit"){
        didSet{
            if credit < 1 {
                nextButton.isEnabled = false
                nextButton.isHidden = true
                MessageOutOfCredits.showMessageView(view: view, messageView: messageView, visualEffect: visualEffect, effect: effect, messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
                hintButton.isHidden = true
            }
        }
    }
    var soundState = ""{
        didSet{
            print("soundState = \(soundState)")
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
        let doesNotWantToLogInGameCanter = UserDefaults.standard.bool(forKey: "doesNotWantToLogInGameCanter")
        let isLogIn = UserDefaults.standard.bool(forKey: "isPlayerLogIn")
        if doesNotWantToLogInGameCanter == false && isLogIn == false{
            showAlertGamecenter()
            
        }else if isLogIn {
            authenticateLocalPlayer()
            
        }
        effect = visualEffect.effect
        messageView.layer.cornerRadius = 5
        visualEffect.effect = nil
        errorMessage.isHidden = false
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
        reinializePaintingsList()
        quizElementSelection()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        
        let navTitle = NSMutableAttributedString(string: "Who painted this?".localized, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: sizeInfoAndFonts?.fontSize4 ?? UIFont(name: "HelveticaNeue-Bold", size: 12)!])
        navLabel.attributedText = navTitle
        navLabel.lineBreakMode = .byWordWrapping
        navLabel.numberOfLines = 0
        self.navigationItem.titleView = navLabel
        credit = UserDefaults.standard.integer(forKey: "credit")
        score = UserDefaults.standard.integer(forKey: "score")
        Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
        if let soundStateTrans = UserDefaults.standard.string(forKey: "soundState"){
            soundState = soundStateTrans
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        goingForwards = false
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        nextButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        painterButton.forEach {(eachButton) in
            eachButton.titleLabel?.font = sizeInfoAndFonts?.fontSize2
        }
        hintItemButton.forEach {(eachButton) in
            eachButton.titleLabel?.font = sizeInfoAndFonts?.fontSize1
        }
        hintButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        okBuyCreditsButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
        errorMessage.font = sizeInfoAndFonts?.fontSize1
        messageLabel.font = sizeInfoAndFonts?.fontSize2
        credit = UserDefaults.standard.integer(forKey: "credit")
       
        if credit < 1 {
            nextButton.isEnabled = false
            nextButton.isHidden = true
            MessageOutOfCredits.showMessageView(view: self.view, messageView: messageView, visualEffect: visualEffect, effect: effect, messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
        }
        AppStoreFeedBack.askForFeedback()
        labelForTitle.lineBreakMode = .byWordWrapping
        labelForTitle.numberOfLines = 0
        labelForTitle.textColor = .white
        labelForTitle.text = ""
        nextButton.includeArrow()

    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let theButton = movingButton {
            theButton.transform = CGAffineTransform.identity
            ButtonTranslation.translate(fromButton: theButton, toButton: placeHolderButton, painterName: artistList[indexPainting[selectedIndex]][0])
        }
        if self.messageView.isDescendant(of: self.view) {
                MessageOutOfCredits.showMessageView(view: view, messageView: messageView, visualEffect: visualEffect, effect: effect, messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
        }

        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.includeArrow()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if goingForwards == false {
            performSegue(withIdentifier: "goToMenu", sender: self)
        }
    }

    func quizElementSelection() {
        reinializePaintingsList()
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        finalArrayOfButtonNames = PainterSelection.buttonsNameSelection(artistList: artistList, indexPainting: indexPainting, painterButton: painterButton, selectedIndex: selectedIndex)
        navLabel.text = ""
        errorCounter = 0
        errorMessage.text = ""
        ImageManager.choosImage(imageView: paintingImage, imageName: artistList[indexPainting[selectedIndex]][2])
    }
    @objc func nextQuizPainting(){
        if partThreeOfQuizDone{
            quizElementSelection()
        }else{
            performSegue(withIdentifier: "showChosePainting", sender: self)
        }
       partThreeOfQuizDone = false
    }

    func indexPaintingAlreadyExist(indexPainting: String) -> Bool {
        return UserDefaults.standard.object(forKey: indexPainting) != nil
    }
    func selectedIndexAlreadyExist(selectedIndex: String) -> Bool {
        return UserDefaults.standard.object(forKey: selectedIndex) != nil
    }
    @IBAction func painterButtonPressed(_ sender: UIButton) {
        soundPlayer = SoundPlayer()
        
        if let painterButtonTitle = sender.titleLabel?.text {
            if painterButtonTitle == artistList[indexPainting[selectedIndex]][0]{
                for button in painterButton {
                    if button.titleLabel?.text != painterButtonTitle{
                        button.isEnabled = false
                        button.isHidden  = true
                    }
                }
                movingButton = sender
                soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
                ButtonTranslation.translate(fromButton: sender, toButton: placeHolderButton, painterName: painterButtonTitle)
                labelForTitle.text = artistList[indexPainting[selectedIndex]][14]
                navLabel.text = ""
                TitleDisplay.show(labelTitle: labelForTitle, titleText: artistList[indexPainting[selectedIndex]][14], nextButton: nextButton, view: self)
                CreditManagment.increaseOneCredit(hintButton: hintButton)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                score = UserDefaults.standard.integer(forKey: "score")
            }else{
                let shake = Shake()
                shake.shakeViewHorizontal(vw: sender)
                soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
                CreditManagment.decreaseTwoCredit(hintButton: hintButton)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sender.isEnabled = false
                    sender.isHidden = true

                    if self.errorCounter > 2 {
                        LabelAndButton.buttonInvisible(painterButton: self.painterButton, errorMessage: self.errorMessage)
                        self.errorMessage.isHidden = false
                        let formatedString3 = NSLocalizedString("Sorry...\nThe right answer is : %@", comment: "")
                        self.errorMessage.text = String(format: formatedString3, self.artistList[self.indexPainting[self.selectedIndex]][0])
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
                        self.partThreeOfQuizDone = true
                        LabelAndButton.disableHintButtons(hintItemButton: self.hintItemButton)
                    }
                }
                errorCounter = errorCounter + 1
                
            }
        }
        Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
    }
    @IBAction func hintSelectionPress(_ sender: UIButton) {
        hintMenuAction()

    }
    @IBAction func specificHintPressed(_ sender: UIButton) {
        if credit < 1 {
            nextButton.isEnabled = false
            nextButton.isHidden = true
            MessageOutOfCredits.showMessageView(view: self.view, messageView: messageView, visualEffect: visualEffect, effect: effect, messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
        }else if let buttonLabel = sender.titleLabel?.text {
            if buttonLabel != HintLabel.buyCoins.rawValue.localized {
                
                let dropTwoPaintersCount = Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: finalArrayOfButtonNames, painterName: artistList[indexPainting[selectedIndex]][0], painterButton: painterButton, placeHolderButton: placeHolderButton, labelTitle: labelForTitle, view: self, nextButton: nextButton, titleText: artistList[indexPainting[selectedIndex]][14], hintButton: hintButton, showActionView: showActionView)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                score = UserDefaults.standard.integer(forKey: "score")
                Prepare.stringForHinLabel(formatedString: formatedString, formatedString2: formatedString2, credit: credit, score: score, hintButton: hintButton)
                errorCounter = errorCounter + dropTwoPaintersCount
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
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        nextQuizPainting()
        nextButton.isEnabled = false
        nextButton.isHidden = true
        LabelAndButton.enableHintButtons(hintItemButton: hintItemButton)
    }
  
    @IBAction func buyCreditsButtonPressed(_ sender: UIButton) {
        executeSegue()
    }
    @IBAction func buyCreditsTapped(_ sender: UITapGestureRecognizer) {
        executeSegue()
    }
    func executeSegue () {
        MessageOutOfCredits.dismissMessageview(messageView: messageView, visualEffect: visualEffect, effect: effect)
        nextButton.isHidden = true
        performSegue(withIdentifier: "showBuyCredits", sender: self)
    }
    
    func hintMenuAction() {
        hintItemButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = !eachButton.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    func reinializePaintingsList() {
        if !(indexPaintingAlreadyExist(indexPainting: "indexPainting")){
            indexPainting = RandomizeOrderOfIndexArray.generateRandomIndex(from: 0, to: artistList.count - 1, quantity: nil)
            UserDefaults.standard.set(indexPainting, forKey: "indexPainting")
            UserDefaults.standard.set(0, forKey: "selectedIndex")
        }
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        indexPainting = UserDefaults.standard.array(forKey: "indexPainting") as! [Int]
        if selectedIndex >= indexPainting.count - 1 {
            indexPainting = RandomizeOrderOfIndexArray.generateRandomIndex(from: 0, to: artistList.count - 1, quantity: nil)
            UserDefaults.standard.set(indexPainting, forKey: "indexPainting")
            UserDefaults.standard.set(0, forKey: "selectedIndex")
        }
    }

// NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBio" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            backItem.tintColor = UIColor.white
            let controller = segue.destination as! infoAndImageViewController
            goingForwards = true
            isFromQuiz = true
            isFromMenu = false
            isFromSlideShow = false
            isFromFinalBonusQuiz = false
            controller.goingForwards = goingForwards
            controller.isFromQuiz = isFromQuiz
            controller.isFromMenu = isFromMenu
            controller.isFromSlideShow = isFromSlideShow
            controller.bioInfoEra = artistList[indexPainting[selectedIndex]][1]
            controller.bioInfoImageName = artistList[indexPainting[selectedIndex]][2]
            
            controller.bioInfoBio = artistList[indexPainting[selectedIndex]][3]
            controller.isFromView = isFromView
        }
        if segue.identifier == "showChosePainting" {
            goingForwards = true
            let controller = segue.destination as! ChosePaintingViewController
            controller.indexPainting = indexPainting
            controller.artistList = artistList
            controller.selectedIndex = selectedIndex
            controller.bioInfoImageName = artistList[indexPainting[selectedIndex]][14]
            LabelAndButton.enableHintButtons(hintItemButton: hintItemButton)
            let backItem = UIBarButtonItem()
            controller.navigationItem.hidesBackButton = true
            controller.artMovementDic = artMovementDic
            backItem.title = ""
            hintButton.isHidden = true
            
        }
        if segue.identifier == "showBuyCredits" {
            goingForwards = true
            let controller = segue.destination as! BuyCreditViewController
            controller.provenance = "quiz"
            let backItem = UIBarButtonItem()
            controller.navigationItem.hidesBackButton = true
            backItem.title = ""

        }

    }
    @IBAction func unwindToViewController(_ sender: UIStoryboardSegue) {
        hintButton.isHidden = false
        CreditManagment.displayCredit(hintButton: hintButton)
        partThreeOfQuizDone = true
        nextQuizPainting()
    }
    func showActionView() {
        performSegue(withIdentifier: "showBio", sender: self)
    }
    func showAlertGamecenter() {
        let alert = UIAlertController(title:  "Are you logged in Game Center?".localized, message:"To compare scores with other players you have to be logged in.".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok, Make sure I am logged in".localized, style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.authenticateLocalPlayer()}))
        let okAction = UIAlertAction(title: "Just Start the Game".localized, style: .cancel, handler: dismissAlert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func dismissAlert(_ sender: UIAlertAction) {
         UserDefaults.standard.set(true, forKey: "doesNotWantToLogInGameCanter")
    }

    func authenticateLocalPlayer() {
       
        localPlayer.authenticateHandler = {(QuizViewController, error) -> Void in
            if((QuizViewController) != nil) {
                //self.showAlertGamecenter()
                self.present(QuizViewController!, animated: true, completion: self.showAlertGamecenter)
            } else if (self.localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                UserDefaults.standard.set(true, forKey: "isPlayerLogIn")
                // Get the default leaderboard ID
                self.localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                        self.retrieveBestScore()
                    }
                })
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
            
        }
        
        UserDefaults.standard.set(true, forKey: "isAuthentificated")
    }
    func retrieveBestScore() {
        if GKLocalPlayer.local.isAuthenticated {
                // Initialize the leaderboard for the current local player
            let gkLeaderboard = GKLeaderboard(players: [GKLocalPlayer.local])
                gkLeaderboard.identifier = self.gcDefaultLeaderBoard
            gkLeaderboard.timeScope = GKLeaderboard.TimeScope.allTime

                // Load the scores
                gkLeaderboard.loadScores(completionHandler: { (scores, error) -> Void in

                    // Get current score
                    var currentScore: Int64 = 0
                    if error == nil, let scores = scores {
                        if scores.count > 0 {
                            currentScore = (scores[0] ).value
                            UserDefaults.standard.setValue(Int(currentScore), forKey: "score")
                            Prepare.stringForHinLabel(formatedString: self.formatedString, formatedString2: self.formatedString2, credit: self.credit, score: Int(currentScore), hintButton: self.hintButton)
                        }
                    }
                })
            }
        }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
         gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    @objc func soundOnOff() {
        soundState = SoundOption.soundOnOff()
    }
}


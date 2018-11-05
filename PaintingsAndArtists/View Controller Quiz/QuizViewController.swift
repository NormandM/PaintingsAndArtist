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

    
    let labelTitle = UILabel(frame: CGRect(x:0, y:0, width:1000, height:50))
    
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
    var partTwoOfQuizDone: Bool = false
    var soundPlayer: SoundPlayer?
    var finalArrayOfButtonNames = [String]()
    var artistList: [[String]] = []
    var indexPainting: [Int] = []
    var selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
    var errorCounter = 0
    var isFromQuiz = Bool()
    var isFromMenu = Bool()
    var isFromSlideShow = Bool()
    var goingForwards = Bool()
    var score = UserDefaults.standard.integer(forKey: "score")
    var credit = UserDefaults.standard.integer(forKey: "credit")
    let localPlayer: GKLocalPlayer = GKLocalPlayer.local
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    var successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
    {
        didSet{
            if credit < 1 {
                nextButton.isEnabled = false
                nextButton.isHidden = true
                MessageOutOfCredits.showMessageView(view: view, messageView: messageView, visualEffect: visualEffect, effect: effect, messageLabel: messageLabel, okBuyCreditsButton: okBuyCreditsButton)
                hintButton.isHidden = true
            }
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
        credit = UserDefaults.standard.integer(forKey: "credit")
        score = UserDefaults.standard.integer(forKey: "score")
        hintButton.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        reinializePaintingsList()
        quizElementSelection()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        goingForwards = false
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Who painted this?", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: sizeInfoAndFonts?.fontSize4 ?? UIFont(name: "HelveticaNeue-Bold", size: 12)!])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
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

        labelTitle.text = ""
        errorCounter = 0
        errorMessage.text = ""
        
        ImageManager.choosImage(imageView: paintingImage, imageName: artistList[indexPainting[selectedIndex]][2])
    }
    @objc func nextQuizPainting(){
        if partTwoOfQuizDone{
            quizElementSelection()
        }else{
            performSegue(withIdentifier: "showChosePainting", sender: self)
        }
       partTwoOfQuizDone = false
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
                soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3")
                ButtonTranslation.translate(fromButton: sender, toButton: placeHolderButton, painterName: painterButtonTitle)
                TitleDisplay.show(labelTitle: labelTitle, titleText: artistList[indexPainting[selectedIndex]][2], nextButton: nextButton, view: self)
                CreditManagment.increaseOneCredit(hintButton: hintButton)
                credit =  UserDefaults.standard.integer(forKey: "credit")
            }else{
                let shake = Shake()
                shake.shakeViewHorizontal(vw: sender)
                soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3")
                CreditManagment.decreaseTwoCredit(hintButton: hintButton)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sender.isEnabled = false
                    sender.isHidden = true

                    if self.errorCounter > 2 {
                        LabelAndButton.buttonInvisible(painterButton: self.painterButton, errorMessage: self.errorMessage)
                        self.errorMessage.isHidden = false
                        self.errorMessage.text = """
                        Sorry...
                        The right answer is : \(self.artistList[self.indexPainting[self.selectedIndex]][0])
                        """
                        self.successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                        self.successiveRightAnswers = SuccessiveAnswer.afterMistake(successiveRightAnswers: self.successiveRightAnswers)
                        UserDefaults.standard.set(self.successiveRightAnswers, forKey: "successiveRightAnswers")
                        self.selectedIndex = self.selectedIndex + 1
                        UserDefaults.standard.set(self.selectedIndex, forKey: "selectedIndex")
                        if self.credit > 0 {
                            self.nextButton.isEnabled = true
                            self.nextButton.isHidden = false
                        }

                        self.nextButton.setTitle("Next", for: .normal)
                        self.partTwoOfQuizDone = true
                        LabelAndButton.disableHintButtons(hintItemButton: self.hintItemButton)
                    }
                }
                errorCounter = errorCounter + 1
                
            }
        }
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
            if buttonLabel != HintLabel.buyCoins.rawValue {
                Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: finalArrayOfButtonNames, painterName: artistList[indexPainting[selectedIndex]][0], painterButton: painterButton, placeHolderButton: placeHolderButton, labelTitle: labelTitle, view: self, nextButton: nextButton, titleText: artistList[indexPainting[selectedIndex]][2], hintButton: hintButton, showActionView: showActionView)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                score = UserDefaults.standard.integer(forKey: "score")
                hintButton.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
                
            }else{
                performSegue(withIdentifier: "showBuyCredits", sender: self)
            }
        }
        if let buttonLabel = sender.titleLabel?.text{
            if buttonLabel != HintLabel.buyCoins.rawValue{
                LabelAndButton.disableHintButtons(hintItemButton: hintItemButton)
            }
        }
        
        hintMenuAction()

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
            let randomizeOrderOfPaintings = RandomizeOrderOfIndexArray(artistList: artistList)
            indexPainting = randomizeOrderOfPaintings.generateRandomIndex(from: 0, to: artistList.count - 1, quantity: nil)
            UserDefaults.standard.set(indexPainting, forKey: "indexPainting")
            UserDefaults.standard.set(0, forKey: "selectedIndex")
        }
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        indexPainting = UserDefaults.standard.array(forKey: "indexPainting") as! [Int]
        if selectedIndex >= indexPainting.count {
            let randomizeOrderOfPaintings = RandomizeOrderOfIndexArray(artistList: artistList)
            indexPainting = randomizeOrderOfPaintings.generateRandomIndex(from: 0, to: artistList.count - 1, quantity: nil)
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
            controller.goingForwards = goingForwards
            controller.isFromQuiz = isFromQuiz
            controller.isFromMenu = isFromMenu
            controller.isFromSlideShow = isFromSlideShow
            controller.bioInfoEra = artistList[indexPainting[selectedIndex]][1]
            controller.bioInfoImageName = artistList[indexPainting[selectedIndex]][2]
            controller.bioInfoBio = artistList[indexPainting[selectedIndex]][3]
        }
        if segue.identifier == "showChosePainting" {
            goingForwards = true
            let controller = segue.destination as! ChosePaintingViewController
            controller.indexPainting = indexPainting
            controller.artistList = artistList
            controller.selectedIndex = selectedIndex
            controller.bioInfoImageName = artistList[indexPainting[selectedIndex]][2]
            LabelAndButton.enableHintButtons(hintItemButton: hintItemButton)
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
        partTwoOfQuizDone = true
        nextQuizPainting()
    }

    
    func showActionView() {
        performSegue(withIdentifier: "showBio", sender: self)
    }
    func showAlertGamecenter() {
        let alert = UIAlertController(title:  "Are you logged in Game Center?", message:"To compare scores with other players you have to be logged in.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok, Make sure I am logged in", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.authenticateLocalPlayer()}))
        let okAction = UIAlertAction(title: "Just Start the Game", style: .cancel, handler: dismissAlert)
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
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
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

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
         gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
}


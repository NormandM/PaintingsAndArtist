//
//  ViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-05-20.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController {
    let labelTitle = UILabel(frame: CGRect(x:0, y:0, width:1000, height:50))
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var buyCreditsButton: UIButton!
    @IBOutlet weak var paintingImage: UIImageView!
    @IBOutlet var painterButton: [UIButton]!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet var hintItemButton: [UIButton]!
    @IBOutlet weak var placeHolderButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var messageView: UIView!
    var effect: UIVisualEffect!
    var partTwoOfQuizDone: Bool = false
    var soundPlayer: SoundPlayer?
    var finalArrayOfButtonNames = [String]()
    var artistList: [[String]] = []
    var indexPainting: [Int] = []
    var selectedIndex =  Int()
    var artistsCount: Int = 0
    var errorCounter = 0
    
        
    var credit = UserDefaults.standard.integer(forKey: "credit"){
        didSet{
            if credit < 1 {
                nextButton.isEnabled = false
                nextButton.isHidden = true
                MessageView.showMessageView(view: view, messageView: messageView, button: buyCreditsButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, totalPaintings: nil)
                hintButton.isHidden = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffect.effect
        messageView.layer.cornerRadius = 5
        visualEffect.effect = nil
        errorMessage.isHidden = true
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
 //       UserDefaults.standard.set(10, forKey: "credit")
//        UserDefaults.standard.set(0, forKey: "successiveRightAnswers")

        if !(userAlreadyExist(credit: "credit")){
            credit = 10
            UserDefaults.standard.set(credit, forKey: "credit")
        }
        credit =  UserDefaults.standard.integer(forKey: "credit")
        hintButton.setTitle("\(credit) Coins available for Hints", for: .normal)
        print(indexPaintingAlreadyExist(indexPainting: "indexPainting"))
        if !(indexPaintingAlreadyExist(indexPainting: "indexPainting")){
            print("is in")
            let randomizeOrderOfPaintings = RandomizeOrderOfIndexArray(artistList: artistList)
            indexPainting = randomizeOrderOfPaintings.generateRandomIndex(from: 0, to: artistList.count - 1, quantity: nil)
            UserDefaults.standard.set(indexPainting, forKey: "indexPainting")
        }
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        indexPainting = UserDefaults.standard.array(forKey: "indexPainting") as! [Int]
        print("selectedIndex: \(selectedIndex)")
        quizElementSelection()
    }
    override func viewDidAppear(_ animated: Bool) {
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
    }
    func quizElementSelection() {
        //UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        if !(selectedIndexAlreadyExist(selectedIndex: "selectedIndex")) || selectedIndex >= indexPainting.count{
            print("is in 2")
            selectedIndex = 0
            UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        }
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        finalArrayOfButtonNames = PainterSelection.buttonsNameSelection(artistList: artistList, indexPainting: indexPainting, painterButton: painterButton, selectedIndex: selectedIndex)

        labelTitle.text = ""
        errorCounter = 0
        errorMessage.text = ""
        ImageManager.choosImage(imageView: paintingImage, imageName: artistList[indexPainting[selectedIndex]][2])
    }
    @objc func nextQuizPainting(){
        print("partTwoOfQuizDone: \(partTwoOfQuizDone)")
        if partTwoOfQuizDone{

            quizElementSelection()
        }else{

            performSegue(withIdentifier: "showChosePainting", sender: self)
        }
       partTwoOfQuizDone = false
    }
    func userAlreadyExist(credit: String) -> Bool {
        return UserDefaults.standard.object(forKey: credit) != nil
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
                soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3")
                ButtonTranslation.translate(fromButton: sender, toButton: placeHolderButton)
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
                        The right answer is :
                        \(self.artistList[self.indexPainting[self.selectedIndex]][0])
                        """
                        UserDefaults.standard.set(0, forKey: "successiveRightAnswers")
                        self.selectedIndex = self.selectedIndex + 1
                        UserDefaults.standard.set(self.selectedIndex, forKey: "selectedIndex")
                        print("slectedIndex: \(self.selectedIndex)")
                        print(UserDefaults.standard.integer(forKey: "selectedIndex"))
                        self.nextButton.isEnabled = true
                        self.nextButton.isHidden = false
                        self.nextButton.setTitle("Next", for: .normal)
                        self.partTwoOfQuizDone = true
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
        if let buttonLabel = sender.titleLabel?.text {
            if buttonLabel != HintLabel.buyCoins.rawValue {
                Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: finalArrayOfButtonNames, painterName: artistList[indexPainting[selectedIndex]][0], painterButton: painterButton, placeHolderButton: placeHolderButton, labelTitle: labelTitle, view: self, nextButton: nextButton, titleText: artistList[indexPainting[selectedIndex]][2], hintButton: hintButton, showActionView: showActionView)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                hintButton.setTitle("\(credit) Coins available for Hints", for: .normal)

            }else{
                performSegue(withIdentifier: "showBio", sender: self)
            }
        }
        LabelAndButton.disableHintButtons(hintItemButton: hintItemButton)
        hintMenuAction()

    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        nextQuizPainting()
        nextButton.isEnabled = false
        nextButton.isHidden = true
    }
    @IBAction func buyCreditsButtonPressed(_ sender: UIButton) {
        MessageView.dismissMessageview(messageView: messageView, visualEffect: visualEffect, effect: effect)
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

// NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBio" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            backItem.tintColor = UIColor.white
            let controller = segue.destination as! infoAndImageViewController
            controller.isFromQuiz = true
            controller.bioInfoEra = artistList[indexPainting[selectedIndex]][1]
            controller.bioInfoImageName = artistList[indexPainting[selectedIndex]][2]
            controller.bioInfoBio = artistList[indexPainting[selectedIndex]][3]
        }
        if segue.identifier == "showChosePainting" {
            let controller = segue.destination as! ChosePaintingViewController
            controller.indexPainting = indexPainting
            controller.artistList = artistList
            controller.selectedIndex = selectedIndex
            controller.bioInfoImageName = artistList[indexPainting[selectedIndex]][2]
            LabelAndButton.enableHintButtons(hintItemButton: hintItemButton)
        }
    }
    @IBAction func unwindToViewController(_ sender: UIStoryboardSegue) {
        CreditManagment.displayCredit(hintButton: hintButton)
        partTwoOfQuizDone = true
        nextQuizPainting()
    }

    
    func showActionView() {
        performSegue(withIdentifier: "showBio", sender: self)
    }
    
    
}


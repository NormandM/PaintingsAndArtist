//
//  BonusQuizViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-26.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import GameKit
class BonusQuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,   UICollectionViewDelegateFlowLayout, GKGameCenterControllerDelegate{

    
    @IBOutlet var messageView: UIView!
    @IBOutlet var specialMessageView: UIView!
    @IBOutlet weak var diplomaImageView: UIImageView!
    @IBOutlet weak var quizProgressBar: UIProgressView!
    @IBOutlet weak var commentAfterResponse: SpecialLabel?
    @IBOutlet weak var specialCommentAfterResponse: SpecialLabel!
    @IBOutlet weak var creditLabel: SpecialLabel!
    @IBOutlet weak var finalCommentAfterResponse: SpecialLabel!
    @IBOutlet weak var leaderBoardButton: UIButton!
    @IBOutlet var finalView: UIView!
    @IBOutlet weak var specialViewOkButton: RoundButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet var hintItemButton: [UIButton]!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var bioDateLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var firstPaintingLabel: SpecialLabel!
    @IBOutlet weak var secondPaintingLabel: SpecialLabel!
    @IBOutlet weak var responseRatio: UILabel!
    @IBOutlet weak var titlePaintings: UILabel!
    @IBOutlet weak var titleForAnagramme: UILabel!
    @IBOutlet weak var nextLevelLabel: UILabel!
    @IBOutlet weak var okButton: RoundButton!
    @IBOutlet weak var finalOkButton: RoundButton!
    
    
    var spaceBetweenCells = CGFloat()
    var totalQuestion = Int()
    var soundPlayer: SoundPlayer?
    var painterName = String()
    var credit = UserDefaults.standard.integer(forKey: "credit")
    var score = UserDefaults.standard.integer(forKey: "score")
    var successiveRightAnswers =  UserDefaults.standard.integer(forKey: "successiveRightAnswers")
    var effect: UIVisualEffect!
    var totalNameArray = [[String]]()
    var artistList = [[String]]()
    var shuffledNameArray = [String]()
    var indexShuffledName = [(Int, String)]()
    var indexResponse = [(Int, String)]()
    var nameArray = [String]()
    var gaveUp: Bool = false
    var n = 0
    var isLanscape = Bool()
    let fontsAndConstraints = FontsAndConstraints()
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    var cellsAcross = CGFloat()
    var traitIsCompactHorizontal = Bool()
    var left = CGFloat()
    var right = CGFloat()
    var hintLetterCounter = Int()
    var artAmateurIsDone = UserDefaults.standard.bool(forKey: "artAmateurIsDone")
    var artConoisseurIsDone = UserDefaults.standard.bool(forKey: "artConoisseurIsDone")
    var artExpertIsDone =  UserDefaults.standard.bool(forKey: "artExpertIsDone")
    var artScholarIsDone = UserDefaults.standard.bool(forKey: "artScholarIsDone")
    var artMasterIsDone = UserDefaults.standard.bool(forKey: "artMasterIsDone")
    let leaderboardID = "LearnArtLeaderboard"
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let localPlayer: GKLocalPlayer = GKLocalPlayer.local
    override func viewDidLoad() {
        super.viewDidLoad()
        if localPlayer.isAuthenticated {
            gcEnabled = true
        }
        effect = visualEffect.effect
        messageView.layer.cornerRadius = 5
        visualEffect.effect = nil
        titleLable.text = "Painter Biography Quiz"
        hintButton.layer.cornerRadius = hintButton.frame.height / 2.0
        hintItemButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
            eachButton.isHidden = true
        }
        credit =  UserDefaults.standard.integer(forKey: "credit")
        score = UserDefaults.standard.integer(forKey: "score")
        hintButton.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
        let allInfo = ArrayManagement.manageArray(artistList: artistList)
        firstPaintingLabel.leftInset = 20
        firstPaintingLabel.rightInset = 20
        secondPaintingLabel.leftInset = 20
        secondPaintingLabel.rightInset = 20
        bioDateLabel.text = allInfo.1
        bioTextView.text = allInfo.3
        firstPaintingLabel.text = allInfo.2
        secondPaintingLabel.text = allInfo.4
        totalNameArray = allInfo.5
        nameArray = totalNameArray[0]
        painterName = nameArray.compactMap {$0}.joined()
        shuffledNameArray = totalNameArray[1]
        let indexNames = LetterChoice.indexLetter(painterName: nameArray, shuffledPainterName: shuffledNameArray)
        indexResponse = indexNames.0
        indexShuffledName = indexNames.1
        bioTextView.layer.borderWidth = 2

        
    }
    override func viewWillAppear(_ animated: Bool) {
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        let horizontalCompact = UITraitCollection(horizontalSizeClass: .compact)
        if self.traitCollection.containsTraits(in: horizontalCompact) {traitIsCompactHorizontal = true}
        firstPaintingLabel.font = sizeInfoAndFonts?.fontSize1
        secondPaintingLabel.font = sizeInfoAndFonts?.fontSize1
        titlePaintings.font = sizeInfoAndFonts?.fontSize4
        titleForAnagramme.font = sizeInfoAndFonts?.fontSize4
        titleLable.font = sizeInfoAndFonts?.fontSize4
        bioDateLabel.font = sizeInfoAndFonts?.fontSize2
        hintItemButton.forEach {(eachButton) in
            eachButton.titleLabel?.font = sizeInfoAndFonts?.fontSize1
        }
        hintButton.titleLabel?.font = sizeInfoAndFonts?.fontSize2
        bioTextView.layer.borderColor = UIColor.white.cgColor
        bioTextView.textContainerInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 20, right: 20)
        bioTextView.font = sizeInfoAndFonts?.fontSize1
        commentAfterResponse?.font = sizeInfoAndFonts?.fontSize2
        specialCommentAfterResponse.font = sizeInfoAndFonts?.fontSize2
        responseRatio.font = sizeInfoAndFonts?.fontSize7

        creditLabel.textColor = UIColor.white
        creditLabel.layer.borderColor = UIColor.white.cgColor
        creditLabel.layer.borderWidth = 2
        creditLabel.font = sizeInfoAndFonts?.fontSize4
        leaderBoardButton.titleLabel?.font = sizeInfoAndFonts?.fontSize2
        cellsAcross = CGFloat(totalNameArray[0].count)
        if UIDevice.current.orientation.isLandscape {isLanscape = true}
        
        
        setUpLayout()
    }

    @IBOutlet weak var answerCollectioView: UICollectionView!{
        didSet{
            answerCollectioView.dataSource = self
            answerCollectioView.delegate = self

        }
    }
    @IBAction func okButtonPressed(_ sender: RoundButton) {
        MessageView.dismissMessageview(messageView: messageView, visualEffect: visualEffect, effect: effect)
        performSegue(withIdentifier: "backToViewController", sender: self)
    }
    
    @IBAction func hintSelectionPress(_ sender: UIButton) {
        hintMenuAction()
        
    }

    @IBAction func specificHintPressed(_ sender: UIButton) {
        n = 0
        if let buttonLabel = sender.titleLabel?.text {
            let countLetter = nameArray.count
            if buttonLabel != HintLabel.buyCoins.rawValue {
                if buttonLabel == HintLabel.showLetter.rawValue {
                    var cell =  answerCollectioView.cellForItem(at: [0, 0]) as! AnswerCollectionViewCell
                        for i in 0 ..< countLetter{
                        cell = answerCollectioView.cellForItem(at: [0, i]) as! AnswerCollectionViewCell
                        if cell.answerLetter.text == "__"  || cell.answerLetter.text != nameArray[i]{
                            n = i
                            break
                        }
                    }
                    let goodLetter = nameArray[n]
                    let badLetter = cell.answerLetter.text
                    let indexShuffled = indexResponse[n].0
                    cell = answerCollectioView.cellForItem(at: [0, n]) as! AnswerCollectionViewCell
                    cell.answerLetter.text = goodLetter
                    cell.answerLetter.textColor = UIColor.red
                    cell.isUserInteractionEnabled = false
                    var cell2 = answerCollectioView.cellForItem(at: [1, 0]) as! AnswerCollectionViewCell
                    var j = 0
                    for i in 0 ..< countLetter{
                        cell2 = answerCollectioView.cellForItem(at: [1, i]) as! AnswerCollectionViewCell
                        if cell2.answerLetter.text == goodLetter{
                            j = i
                            break
                        }
                    }
                    indexResponse[n] = (j, goodLetter)
                    indexShuffledName[j] = (j, "__")
                    cell2 = answerCollectioView.cellForItem(at: [1, j]) as! AnswerCollectionViewCell
                    cell2.answerLetter.text = " "
                    if badLetter != "__"{
                        indexShuffledName[indexShuffled] = (indexShuffled, badLetter!)
                        cell2 = answerCollectioView.cellForItem(at: [1, indexShuffled]) as! AnswerCollectionViewCell
                        cell2.answerLetter.text = badLetter
                        cell2.answerLetter.isEnabled = true
                    }else{
                        cell2.answerLetter.text = " "
                        indexShuffledName[j] = (j, "__")
                    }
                    for  single in 0 ..< shuffledNameArray.count {
                        let cell = answerCollectioView.cellForItem(at: [1, single]) as! AnswerCollectionViewCell
                        if cell.answerLetter.text != "" || cell.answerLetter.text != " "{
                            cell.isUserInteractionEnabled = true
                        }else{cell.isUserInteractionEnabled = false}
                    }
                    hintLetterCounter = hintLetterCounter + 1
                    if hintLetterCounter == 2 {
                        hintItemButton[1].isEnabled = false
                        hintItemButton[1].setTitleColor(UIColor.lightGray, for:UIControl.State.normal)
                    }
                    Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: nil, painterName: nil, painterButton: nil, placeHolderButton: nil, labelTitle: nil, view: nil, nextButton: nil, titleText: nil, hintButton: hintButton, showActionView: showActionView)

                }else if buttonLabel == HintLabel.showPainterName.rawValue{
                    gaveUp = true
                    Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: nil, painterName: nil, painterButton: nil, placeHolderButton: nil, labelTitle: nil, view: nil, nextButton: nil, titleText: nil, hintButton: hintButton, showActionView: showActionView)
                    var i = 0
                    var j = 0
                    for letter in nameArray {
                        
                        let cell = answerCollectioView.cellForItem(at: [0, i]) as! AnswerCollectionViewCell
                        let cell2 = answerCollectioView.cellForItem(at: [1, j]) as! AnswerCollectionViewCell
                        indexResponse[i] = (i, letter)
                        cell.answerLetter.text = letter
                        cell2.answerLetter.text = " "
                        if letter != " "{
                            j = j + 1
                        }
                        i = i + 1
                    }
                    messageAfterResponse()
                }
                
                if n == (countLetter - 1){
                    messageAfterResponse()
                }
                credit =  UserDefaults.standard.integer(forKey: "credit")
                score = UserDefaults.standard.integer(forKey: "score")
                hintButton.setTitle("\(credit) Coins for Hints - Score = \(score)", for: .normal)
                hintMenuAction()
            }
        }
    }
    func showActionView () {
        
    }

    
////////////////// Collection View ////////////////////////////////////////
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return totalNameArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return totalNameArray[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath as IndexPath) as! AnswerCollectionViewCell
        cell2.answerLetter.text = totalNameArray[indexPath.section][indexPath.item]
        cell2.answerLetter.font = sizeInfoAndFonts?.fontSize2
        if indexPath.section == 1{
            cell2.layer.borderColor = UIColor.white.cgColor
            cell2.layer.borderWidth = 2
            cell2.answerLetter.textColor = UIColor.white
            
        }else if indexPath.section == 0{
            cell2.layer.borderColor = UIColor.clear.cgColor
            cell2.answerLetter.textColor = UIColor.white
            if cell2.answerLetter.text != " " {
                cell2.answerLetter.text = "__"
                cell2.isUserInteractionEnabled = false
            }
        }
        cell2.answerLetter.font = sizeInfoAndFonts?.fontSize2
        cell2.layoutIfNeeded()
        return cell2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath) as! AnswerCollectionViewCell
        let letter = cell.answerLetter.text

        if indexPath.section == 1 {
            var i = 0
            n = 0
            for response in indexResponse {
                if response.1 == "__"{
                    n = i
                    break
                }
                i = i + 1
            }
            let cell2 = collectionView.cellForItem(at: [0, n]) as! AnswerCollectionViewCell
            cell2.answerLetter.text = letter
            cell2.isUserInteractionEnabled = true
            cell.answerLetter.text = ""
            cell.isUserInteractionEnabled = false
            indexResponse[n] = indexShuffledName[indexPath.item]
            indexShuffledName[indexPath.item] = (indexPath.item, "__")
            n = n + 1
        }else if indexPath.section == 0 {
            cell.answerLetter.text = "__"
            cell.isUserInteractionEnabled = false
            let letterTouched = indexResponse[indexPath.item]
            let path = letterTouched.0
            let letter = letterTouched.1
            let cell2 = collectionView.cellForItem(at: [1, path]) as! AnswerCollectionViewCell
            cell2.answerLetter.text = letter
            cell2.isUserInteractionEnabled = true
            indexShuffledName[path] = indexResponse[indexPath.item]
            indexResponse[indexPath.item] = (indexPath.item, "__")
        }
        
        if n == indexResponse.count {
            messageAfterResponse()
        }
        
    }
    func messageAfterResponse(){
            soundPlayer = SoundPlayer()
            let isResponseGood = CheckingReponse.goodOrBad(indexResponse: indexResponse, painterName: nameArray)
            if isResponseGood{
                if gaveUp {
                    successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                    UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
                    print("successiveRightAnswers1: \(successiveRightAnswers)")
                }else{
                    CreditManagment.increaseOneCredit(hintButton: nil)
                    soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3")
                    successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers") + 1
                     UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
                    if successiveRightAnswers == 100 {
                        quizProgressBar.isHidden = true
                        responseRatio.isHidden = true
                        nextLevelLabel.isHidden = true
                    }
                }
                let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: commentAfterResponse!, creditLabel: creditLabel, painterName: painterName, gaveUp: gaveUp)
                totalQuestion = tuppleResponse.1
               UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
                successiveRightAnswers =  UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                print("successiveRightAnswers2: \(successiveRightAnswers)")
                let achievementArtAmateur = GKAchievement(identifier: "ASeriesOf5")
                let achievementArtConoisseur = GKAchievement(identifier: "ASeriesOf10")
                let achievementArtExpert = GKAchievement(identifier: "ASeriesOf15")
                let achievementArtScholar = GKAchievement(identifier: "aSeriesOf20")
                let achievementArtMaster = GKAchievement(identifier: "ASeriesOf50")
                
                switch successiveRightAnswers {
                case 5, 15, 30, 50:
                    artAmateurIsDone = UserDefaults.standard.bool(forKey: "artAmateurIsDone")
                    artConoisseurIsDone = UserDefaults.standard.bool(forKey: "artConoisseurIsDone")
                    artExpertIsDone = UserDefaults.standard.bool(forKey: "artExpertIsDone")
                    artScholarIsDone = UserDefaults.standard.bool(forKey: "artScholarIsDone")
                    artMasterIsDone = UserDefaults.standard.bool(forKey: "artMasterIsDone")
                    if (successiveRightAnswers == 5 && artAmateurIsDone) || (successiveRightAnswers == 15 && artConoisseurIsDone)  || (successiveRightAnswers == 30 && artExpertIsDone)  || (successiveRightAnswers == 50 && artScholarIsDone) ||  (successiveRightAnswers == 100 && artMasterIsDone){
                        callDefault()
                    }else{
                        let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: specialCommentAfterResponse!, creditLabel: creditLabel, painterName: painterName, gaveUp: gaveUp)
                        totalQuestion = tuppleResponse.1
                        specialCommentAfterResponse = tuppleResponse.0
                        specialViewOkButton.x = view.frame.width * 0.7/2 - specialViewOkButton.buttonHeight/2
                        specialViewOkButton.y =  view.frame.height * 0.7 * 0.8
                        print("sound")
                        soundPlayer?.playSound(soundName: "music_harp_gliss_up", type: "wav")
                        MessageView.showMessageView(view: view, messageView: specialMessageView, button: specialViewOkButton, visualEffect: visualEffect, effect: effect, diplomaImageView: diplomaImageView, commentAfterResponse: commentAfterResponse!, nextLevel: nextLevelLabel, responseRatio: responseRatio)
                    }
                    
                    
                case 100:
                    let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: finalCommentAfterResponse, creditLabel: creditLabel, painterName: painterName, gaveUp: gaveUp)
                    finalCommentAfterResponse = tuppleResponse.0
                    finalOkButton.x = view.frame.width * 0.7/2 - finalOkButton.buttonHeight/2
                    finalOkButton.y =   view.frame.height * 0.7 * 0.8
                    MessageView.showMessageView(view: view, messageView: finalView, button: finalOkButton, visualEffect: visualEffect, effect: effect, diplomaImageView: diplomaImageView, commentAfterResponse: finalCommentAfterResponse, nextLevel: nextLevelLabel, responseRatio: responseRatio)
                    soundPlayer?.playSound(soundName: "music_harp_gliss_up", type: "wav")
                default:
                    callDefault()
                }
                if successiveRightAnswers <= 5 {
                    achievementArtAmateur.percentComplete = Double(successiveRightAnswers) * 20
                    if achievementArtAmateur.percentComplete == 100 {
                        artAmateurIsDone = true
                        UserDefaults.standard.set(artAmateurIsDone, forKey: "artAmateurIsDone")
                    }
                    
                }else if successiveRightAnswers <= 15{
                    achievementArtConoisseur.percentComplete = (Double(successiveRightAnswers) - 5) * 10
                    if achievementArtConoisseur.percentComplete == 100 {
                        artConoisseurIsDone = true
                        UserDefaults.standard.set(artConoisseurIsDone, forKey: "artConoisseurIsDone")
                    }
                    
                }else if successiveRightAnswers <= 30{
                    achievementArtExpert.percentComplete = (Double(successiveRightAnswers) - 15) * (100/15)
                    if achievementArtExpert.percentComplete == 100 {
                        artExpertIsDone = true
                        UserDefaults.standard.set(artExpertIsDone, forKey: "artExpertIsDone")
                    }
                    
                }else if successiveRightAnswers <= 50{
                    achievementArtScholar.percentComplete =  (Double(successiveRightAnswers) - 30) * 5
                    if achievementArtScholar.percentComplete == 100 {
                        artScholarIsDone = true
                        UserDefaults.standard.set(artScholarIsDone, forKey: "artScholarIsDone")
                    }
                }else if successiveRightAnswers <= 100{
                    achievementArtMaster.percentComplete =  (Double(successiveRightAnswers) - 50) * 2
                    if achievementArtMaster.percentComplete == 100 {
                        artMasterIsDone = true
                        UserDefaults.standard.set(artMasterIsDone, forKey: "artMasterIsDone")
                    }
                }
                
                GKAchievement.report([achievementArtAmateur, achievementArtConoisseur, achievementArtExpert, achievementArtScholar, achievementArtMaster]) { (error) in
                }

                okButton.setNeedsDisplay()
            }else{
                CreditManagment.decreaseFourCredit(hintButton: hintButton)
                gaveUp = true
                print("successiveRightAnswers3: \(successiveRightAnswers)")
                successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                print("successiveRightAnswers4: \(successiveRightAnswers)")
                let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: commentAfterResponse!, creditLabel: creditLabel, painterName: painterName, gaveUp: gaveUp)
                totalQuestion = tuppleResponse.1
                soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3")
                credit =  UserDefaults.standard.integer(forKey: "credit")
                score = UserDefaults.standard.integer(forKey: "score")
                commentAfterResponse?.text = "Sorry! It is not the right answer\nThe painter's name is \n\(painterName)"
                creditLabel.text = """
                Credits: \(credit)
                
                Score: \(score)
                """
                successiveRightAnswers =  UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                successiveRightAnswers = SuccessiveAnswer.afterMistake(successiveRightAnswers: successiveRightAnswers)
                UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
                successiveResponseAdjustement(totalQuestion: totalQuestion)

            }
    }
    func successiveResponseAdjustement(totalQuestion: Int) {
        print("successiveRightAnswers5: \(successiveRightAnswers)")
        successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
        print("successiveRightAnswers6: \(successiveRightAnswers)")
        print("totalQuestion: \(totalQuestion)")
        var numerateur = Int()
        var denominateur = Int()
        if totalQuestion == 5 {
            numerateur = successiveRightAnswers
            denominateur = 5
            if artAmateurIsDone {
                numerateur = successiveRightAnswers
                denominateur = 10
            }
        }
        if totalQuestion == 10 {
            numerateur = successiveRightAnswers - 5
            denominateur = 10
            if artConoisseurIsDone {
                numerateur = successiveRightAnswers
                denominateur = 15
            }
        }
        if totalQuestion == 15 {
            numerateur = successiveRightAnswers - 15
            denominateur = 15
            if artExpertIsDone {
                numerateur = successiveRightAnswers
                denominateur = 30
            }
        }
        if totalQuestion == 20 {
            numerateur = successiveRightAnswers - 30
            denominateur = totalQuestion
            if artScholarIsDone {
                numerateur = successiveRightAnswers
                denominateur = 50
            }
        }
        if totalQuestion == 50 {
            numerateur = successiveRightAnswers - 50
            denominateur = 50
            if artMasterIsDone {
                numerateur = successiveRightAnswers
                denominateur = 100
            }
        }
        if totalQuestion > 50 {
            responseRatio.isHidden = true
            quizProgressBar.isHidden = true
            nextLevelLabel.isHidden = true
        }
        responseRatio.text = "\(numerateur)/\(denominateur)"
        QuizProgressionBar.barDisplay(successiveRightAnswers: numerateur, quizProgressionBar: quizProgressBar, totalQuestion: denominateur)
        MessageView.showMessageView(view: view, messageView: messageView, button: okButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, commentAfterResponse: commentAfterResponse!, nextLevel: nextLevelLabel, responseRatio: responseRatio)
        return

    }
    func callDefault() {
        let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: commentAfterResponse!, creditLabel: creditLabel, painterName: painterName, gaveUp: gaveUp)
        print("successiveRightAnswers8: \(successiveRightAnswers)")
        if gaveUp {
            successiveRightAnswers = SuccessiveAnswer.afterMistake(successiveRightAnswers: successiveRightAnswers)
            UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
        }
        print("successiveRightAnswers9: \(successiveRightAnswers)")
        credit =  UserDefaults.standard.integer(forKey: "credit")
        score = UserDefaults.standard.integer(forKey: "score")
        totalQuestion = tuppleResponse.1
        print("totalQuestion: \(totalQuestion)")
        commentAfterResponse = tuppleResponse.0
        creditLabel.text = """
        Credits: \(credit)
        
        Score: \(score)
        """

        successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
        successiveResponseAdjustement(totalQuestion: totalQuestion)
        
    }
    func hintMenuAction() {
        hintItemButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = !eachButton.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Compute the dimension of a cell for an NxN layout with space S between
    // cells.  Take the collection view's width, subtract (N-1)*S points for
    // the spaces between the cells, and then divide by N to find the final
    // dimension for the cell's width and height.
    /////////////////////////////////////////////////////////////////////////
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation.isLandscape {
            isLanscape = false
        }else{isLanscape = true}
        answerCollectioView.setNeedsDisplay()
        
        if self.messageView.isDescendant(of: self.view) {
            MessageView.showMessageView(view: view, messageView: messageView, button: okButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, commentAfterResponse: commentAfterResponse!, nextLevel: nextLevelLabel, responseRatio: responseRatio)

        }
        if self.specialMessageView.isDescendant(of: self.view) {
            specialViewOkButton.x = view.frame.width * 0.7/2 - specialViewOkButton.buttonHeight/2
            specialViewOkButton.y =  view.frame.height * 0.7 * 0.8
            MessageView.showMessageView(view: view, messageView: specialMessageView, button: okButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, commentAfterResponse: commentAfterResponse!, nextLevel: nextLevelLabel, responseRatio: responseRatio)
        }
        if self.finalView.isDescendant(of: self.view){
            finalOkButton.x = view.frame.width * 0.7/2 - finalOkButton.buttonHeight/2
            finalOkButton.y =   view.frame.height * 0.7 * 0.8
            MessageView.showMessageView(view: view, messageView: finalView, button: finalOkButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, commentAfterResponse: commentAfterResponse!, nextLevel: nextLevelLabel, responseRatio: responseRatio)
        }
        okButton.setNeedsDisplay()
    }

    func setUpLayout(){
        var top = CGFloat()
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        if traitIsCompactHorizontal == false{
            layout.minimumInteritemSpacing = 2
            spaceBetweenCells = layout.minimumInteritemSpacing
            switch cellsAcross {
            case 4:
            if isLanscape {
                top = answerCollectioView.bounds.height * 0.1
                left = 0.293 * view.bounds.width
                right = left
            }else{
                top = answerCollectioView.bounds.height * 0.2
                left = 0.244 * view.bounds.width
                right = left
            }
            case 5:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.256 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.2
                    left = 0.244 * view.bounds.width
                    right = left
                }
            case 6:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.220 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.2
                    left = 0.195 * view.bounds.width
                    right = left
                }
            case 7:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.183 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.2
                    left = 0.148 * view.bounds.width
                    right = left
                }
            case 8:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.146 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.2
                    left = 0.1 * view.bounds.width
                    right = left
                }
            case 9:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.11 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.2
                    left = 0.049 * view.bounds.width
                    right = left
                }
            case 10:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.073 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.2
                    left = 0.049 * view.bounds.width
                    right = left
                }
            default:
                if isLanscape {
                    top = answerCollectioView.bounds.height * 0.1
                    left = 0.036 * view.bounds.width
                    right = left
                }else{
                    top = answerCollectioView.bounds.height * 0.22
                    left = 0.049 * view.bounds.width
                    right = left
                }
            }

        }else{
            left = 10
            right = left
            layout.minimumInteritemSpacing = 2
            spaceBetweenCells = layout.minimumInteritemSpacing
            switch cellsAcross {

            case 4, 5:
                top = answerCollectioView.bounds.height * 0.05
            case 6:
                top = answerCollectioView.bounds.height * 0.08
            case 7, 8:
                top = answerCollectioView.bounds.height * 0.1
            case 9:
                top = answerCollectioView.bounds.height * 0.12
            case 10:
                top = answerCollectioView.bounds.height * 0.15
            default:
                top = answerCollectioView.bounds.height * 0.15
                
            }
        }
        layout.sectionInset = UIEdgeInsets(top: top,left:left,bottom: 0,right:right)
        answerCollectioView.collectionViewLayout = layout
       
 
   }
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var dim = CGFloat()
        let spaceAccross = CGFloat(totalNameArray[0].count)
        spaceBetweenCells = 2
        dim = ((collectionView.bounds.width - (left + right)) - spaceAccross * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    
////////////// Game Center Code ////////////////


    
    @IBAction func leadeBoardButtonPushed(_ sender: UIButton) {
        if gcEnabled {
            addScoreAndSubmitToGC()
            let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self
            vc.viewState = .achievements
            vc.leaderboardIdentifier = leaderboardID
            present(vc, animated: true, completion: nil)
        }else{
            authenticateLocalPlayer()
        }
    }
    func authenticateLocalPlayer() {
        localPlayer.authenticateHandler = {(BonusQuizViewController, error) -> Void in
            if((BonusQuizViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(BonusQuizViewController!, animated: true, completion: nil)
            } else if (self.localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
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
        UserDefaults.standard.set(false, forKey: "doesNotWantToLogInGameCanter")
        UserDefaults.standard.set(true, forKey: "isPlayerLogIn")
    }
    
    func addScoreAndSubmitToGC() {
        score = UserDefaults.standard.integer(forKey: "score")
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
        successiveRightAnswers =  UserDefaults.standard.integer(forKey: "successiveRightAnswers")
        if successiveRightAnswers <= 5 {
            let achievementArtAmateur = GKAchievement(identifier: "ASeriesOf5")
            achievementArtAmateur.percentComplete = Double(successiveRightAnswers) * 20
            achievementArtAmateur.showsCompletionBanner = false
            GKAchievement.report([achievementArtAmateur]) { (error) in
                print(error as Any)
            }
        }
        
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}




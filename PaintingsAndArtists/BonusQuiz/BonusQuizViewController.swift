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
class BonusQuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,   UICollectionViewDelegateFlowLayout{
    @IBOutlet var messageView: UIView!
    @IBOutlet var specialMessageView: UIView!
    @IBOutlet weak var diplomaImageView: UIImageView!
    @IBOutlet weak var quizProgressBar: UIProgressView!
    
    @IBOutlet weak var commentAfterResponse: SpecialLabel?
    @IBOutlet weak var specialCommentAfterResponse: SpecialLabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var specialViewOkButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet var hintItemButton: [UIButton]!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var bioDateLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var firstPaintingLabel: SpecialLabel!
    @IBOutlet weak var secondPaintingLabel: SpecialLabel!
    @IBOutlet weak var responseRatio: UILabel!
    var totalQuestion = Int()
    var soundPlayer: SoundPlayer?
    var painterName = String()
    var credit = UserDefaults.standard.integer(forKey: "credit")
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
    override func viewDidLoad() {
        effect = visualEffect.effect
        messageView.layer.cornerRadius = 5
        visualEffect.effect = nil
        titleLable.text = "Painter Biography Quiz"
        hintButton.layer.cornerRadius = hintButton.frame.height / 2.0
        hintItemButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
            eachButton.isHidden = true
        }
        hintButton.setTitle("\(credit) Coins available for Hints", for: .normal)
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
 ////////////////////////////////////////////////////////////
        do {
            let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
            let url = dir.appendingPathComponent("Debug.txt")
            try "\(painterName) \(Date())".appendLineToURL(fileURL: url as URL)
            let result = try String(contentsOf: url as URL, encoding: String.Encoding.utf8)
            print(url)
            do {
                let contents = try String(contentsOf: url)
                print(contents)
            } catch {
                // contents could not be loaded
            }

        }
        catch {
            print("Could not write to file")
        }


//////////////////////////////////////////////////////////////////
        shuffledNameArray = totalNameArray[1]
        let indexNames = LetterChoice.indexLetter(painterName: nameArray, shuffledPainterName: shuffledNameArray)
        indexResponse = indexNames.0
        indexShuffledName = indexNames.1
        bioTextView.layer.borderWidth = 2
        bioTextView.layer.borderColor = UIColor.white.cgColor
        bioTextView.textContainerInset = UIEdgeInsetsMake(10, 20, 20, 20)
    }

    @IBOutlet weak var answerCollectioView: UICollectionView!{
        didSet{
            answerCollectioView.dataSource = self
            answerCollectioView.delegate = self
        }
    }
    @IBAction func okButtonPressed(_ sender: UIButton) {
        MessageView.dismissMessageview(messageView: messageView, visualEffect: visualEffect, effect: effect)
        performSegue(withIdentifier: "backToViewController", sender: self)
    }
    @IBAction func hintSelectionPress(_ sender: UIButton) {
        hintMenuAction()
        
    }

    @IBAction func specificHintPressed(_ sender: UIButton) {
        if let buttonLabel = sender.titleLabel?.text {
            let countLetter = nameArray.count
            if buttonLabel != HintLabel.buyCoins.rawValue {
                if buttonLabel == HintLabel.showLetter.rawValue {
                    var cell =  answerCollectioView.cellForItem(at: [0, 0]) as! AnswerCollectionViewCell
                        for i in 0 ... countLetter{
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
                    var cell2 = answerCollectioView.cellForItem(at: [1, 0]) as! AnswerCollectionViewCell
                    var j = 0
                    for i in 0 ... countLetter{
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
                }else if buttonLabel == HintLabel.showPainterName.rawValue{
                    

                    
                    gaveUp = true
                    var i = 0
                    var j = 0
                    print(nameArray)
                    
                    for letter in nameArray {
                        
                        let cell = answerCollectioView.cellForItem(at: [0, i]) as! AnswerCollectionViewCell
                        let cell2 = answerCollectioView.cellForItem(at: [1, j]) as! AnswerCollectionViewCell
                        indexResponse[i] = (i, letter)
                        print(indexResponse[i])
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
                Hint.manageHints(buttonLabel: buttonLabel, finalArrayOfButtonNames: nil, painterName: nil, painterButton: nil, placeHolderButton: nil, labelTitle: nil, view: nil, nextButton: nil, titleText: nil, hintButton: hintButton, showActionView: showActionView)
                credit =  UserDefaults.standard.integer(forKey: "credit")
                hintButton.setTitle("\(credit) Coins available for Hints", for: .normal)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: CGFloat(0), height: CGFloat(0))
        }else{
            let height = answerCollectioView.frame.height/4
            return CGSize(width: CGFloat(10), height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath as IndexPath) as! AnswerCollectionViewCell
            cell2.answerLetter.text = totalNameArray[indexPath.section][indexPath.item]
        if indexPath.section == 1{
            cell2.layer.borderColor = UIColor.white.cgColor
            cell2.layer.borderWidth = 2
            cell2.answerLetter.textColor = UIColor.white
        }else if indexPath.section == 0{
            cell2.layer.borderColor = UIColor.clear.cgColor
            cell2.answerLetter.textColor = UIColor.white
            if cell2.answerLetter.text != " " {
                cell2.answerLetter.text = "__"
            }
        }
        return cell2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath) as! AnswerCollectionViewCell
        let letter = cell.answerLetter.text
        if indexPath.section == 1 {
            var i = 0
            for response in indexResponse {
                if response.1 == "__"{
                    n = i
                    break
                }
                i = i + 1
            }
            let cell2 = collectionView.cellForItem(at: [0, n]) as! AnswerCollectionViewCell
            cell2.answerLetter.text = letter
            cell.answerLetter.text = ""
            cell.isUserInteractionEnabled = false
            indexResponse[n] = indexShuffledName[indexPath.item]
            indexShuffledName[indexPath.item] = (indexPath.item, "__")
            n = n + 1
        }else if indexPath.section == 0 {
            cell.answerLetter.text = "__"
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
            let totalPaintings = artistList.count
            let isResponseGood = CheckingReponse.goodOrBad(indexResponse: indexResponse, painterName: nameArray)
            if isResponseGood{
                print(gaveUp)
                if gaveUp {
                    successiveRightAnswers = 0
                }else{
                    CreditManagment.increaseOneCredit(hintButton: nil)
                    soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3")
                    successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers") + 1
                }
                let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: commentAfterResponse!, painterName: painterName, totalPaintings: totalPaintings, gaveUp: gaveUp)
                totalQuestion = tuppleResponse.1
                UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
                
                switch successiveRightAnswers {
                case 5, 15, 30, 50:
                    let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: specialCommentAfterResponse!, painterName: painterName, totalPaintings: totalPaintings, gaveUp: gaveUp)
                    specialCommentAfterResponse = tuppleResponse.0
                    totalQuestion = tuppleResponse.1
                    MessageView.showMessageView(view: view, messageView: specialMessageView, button: specialViewOkButton, visualEffect: visualEffect, effect: effect, diplomaImageView: diplomaImageView, totalPaintings: totalPaintings)
                    
                default:
                    let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: commentAfterResponse!, painterName: painterName, totalPaintings: totalPaintings, gaveUp: gaveUp)
                    commentAfterResponse = tuppleResponse.0
                    totalQuestion = tuppleResponse.1
                    MessageView.showMessageView(view: view, messageView: messageView, button: okButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, totalPaintings: totalPaintings)
                    QuizProgressionBar.barDisplay(successiveRightAnswers: successiveRightAnswers, quizProgressionBar: quizProgressBar, totalQuestion: totalQuestion)
                    responseRatio.text = "\(successiveRightAnswers)/\(totalQuestion)"
                    
                }
            }else{
                let tuppleResponse = SuccessiveAnswer.progression(commentAfterResponse: commentAfterResponse!, painterName: painterName, totalPaintings: totalPaintings, gaveUp: gaveUp)
                totalQuestion = tuppleResponse.1
                soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3")
                commentAfterResponse?.text = "Sorry! It is not the right answer\nThe painter's name is \(painterName)"
                MessageView.showMessageView(view: view, messageView: messageView, button: okButton, visualEffect: visualEffect, effect: effect, diplomaImageView: nil, totalPaintings: totalPaintings)
                UserDefaults.standard.set(0, forKey: "successiveRightAnswers")
                
                successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
                QuizProgressionBar.barDisplay(successiveRightAnswers: successiveRightAnswers, quizProgressionBar: quizProgressBar, totalQuestion: totalQuestion)
                responseRatio.text = "\(successiveRightAnswers)/\(totalQuestion)"
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
    
    /////////////////////////////////////////////////////////////////////////
    //Compute the dimension of a cell for an NxN layout with space S between
    // cells.  Take the collection view's width, subtract (N-1)*S points for
    // the spaces between the cells, and then divide by N to find the final
    // dimension for the cell's width and height.
    /////////////////////////////////////////////////////////////////////////
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 11
        let spaceBetweenCells: CGFloat = 2
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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



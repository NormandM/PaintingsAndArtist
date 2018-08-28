//
//  ChosePaintingViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-07.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation
class ChosePaintingViewController: UIViewController {
   
    @IBOutlet weak var paintingImage1: UIImageView!
    @IBOutlet weak var paintingImage2: UIImageView!
    @IBOutlet weak var paintingImage3: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var commentOnResponse: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var bioInfoImageName = String()
    var indexPainting = [Int]()
    var artistList = [[String]]()
    var selectedIndex =  UserDefaults.standard.integer(forKey: "selectedIndex")
    var partTwoOfQuizDone: Bool = false
    var randomImageNameindex = [Int]()
    var otherPaintingNameForSameArtist = String()
    var imageNameOtherPaintings = [String]()
    var totalQuestion = Int()
    var soundPlayer: SoundPlayer?
    var painterName = String()
    var isAnswerGood = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        soundPlayer = SoundPlayer()
        commentOnResponse.isHidden = true
        let paintingImage: [UIImageView] = [paintingImage1, paintingImage2, paintingImage3]
        infoLabel.textColor = UIColor.white
        infoLabel.text = "Identify another \(artistList[indexPainting[selectedIndex]][0]) painting"
        painterName = artistList[indexPainting[selectedIndex]][0]
        var i = Int()
        for artistName in artistList {
            if artistName[0] == painterName && i != indexPainting[selectedIndex] {
                otherPaintingNameForSameArtist = artistName[2]
            }
            i = i + 1
        }
        i = 0
        imageNameOtherPaintings = OtherPaintings.choose(artistList: artistList, otherPaintingNameForSameArtist: otherPaintingNameForSameArtist, bioInfoImageName: bioInfoImageName)
        imageNameOtherPaintings.append(otherPaintingNameForSameArtist)
        let randomizeOrderOfButtonNames = RandomizeOrderOfArray(listNames: imageNameOtherPaintings)
        randomImageNameindex = randomizeOrderOfButtonNames.generateRandomIndex(from: 0, to: 2, quantity: nil)
        imageNameOtherPaintings = [imageNameOtherPaintings[randomImageNameindex[0]], imageNameOtherPaintings[randomImageNameindex[1]], imageNameOtherPaintings[randomImageNameindex[2]]]
        for imageName in imageNameOtherPaintings{
            ImageManager.choosImage(imageView: paintingImage[i], imageName: imageName)
            i = i + 1
        }
        nextButton.isHidden = true
        selectedIndex = selectedIndex + 1
        UserDefaults.standard.set(selectedIndex, forKey: "selectedIndex")
        selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
    }
    override func viewDidAppear(_ animated: Bool) {
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.width/2
        nextButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
    }

    

    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        if isAnswerGood{
            performSegue(withIdentifier: "showBonusQuiz", sender: self)
        }else{
            performSegue(withIdentifier: "backToViewController", sender: self)
        }
    }
    
    @IBAction func imageOneTapped(_ sender: UITapGestureRecognizer) {
        rightImageTapped(imageName: imageNameOtherPaintings[0])
    }
    @IBAction func imageTwoTapped(_ sender: UITapGestureRecognizer) {
         rightImageTapped(imageName: imageNameOtherPaintings[1])
    }
    @IBAction func imageThreeTapped(_ sender: UITapGestureRecognizer) {
         rightImageTapped(imageName: imageNameOtherPaintings[2])
    }
    func rightImageTapped(imageName: String) {
        soundPlayer = SoundPlayer()
        if imageNameOtherPaintings[0] != otherPaintingNameForSameArtist {paintingImage1.isHidden = true}
        if imageNameOtherPaintings[1] != otherPaintingNameForSameArtist {paintingImage2.isHidden = true}
        if imageNameOtherPaintings[2] != otherPaintingNameForSameArtist {paintingImage3.isHidden = true}
        commentOnResponse.isHidden = false
        nextButton.isHidden = false
        if imageName == otherPaintingNameForSameArtist {
            CreditManagment.increaseOneCredit(hintButton: nil)
            commentOnResponse.text = """
            Great!
            You recognized
            \(painterName)'s style.
            
            1 coin was added
            """
            infoLabel.text = otherPaintingNameForSameArtist
            isAnswerGood = true
            soundPlayer?.playSound(soundName: "chime_clickbell_octave_up", type: "mp3")
        }else{
            
            commentOnResponse.text = """
            Sorry ... Your choice was not the right one.
            This is another
            \(painterName) painting.
            """
            isAnswerGood = false
            infoLabel.text = otherPaintingNameForSameArtist
            soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3")
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBonusQuiz" {
            let controller = segue.destination as! BonusQuizViewController
            controller.artistList = artistList
        }
    }


}

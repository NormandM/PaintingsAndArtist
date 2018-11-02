//
//  MenuViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-05-23.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var learnArtLabel: UILabel!
    @IBOutlet weak var slideShowButton: UIButton!
    @IBOutlet weak var starHereLabel: UILabel!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var testYourKnowledgeLabel: UILabel!
    @IBOutlet weak var allTheDataButton: UIButton!
    @IBOutlet weak var consultAndLearnLabel: UILabel!
    @IBOutlet weak var manageYourCreditsButton: UIButton!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var grandeJatte: UIImageView!
    let provenance = "menu"
    var artistList: [[String]] = []
    var artistsCount = 0
    var isFromMenu = Bool()
    var isFromQuiz = Bool()
    var isFromSlideShow = Bool()
    var effect: UIVisualEffect!
    let fontsAndConstraints = FontsAndConstraints()
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    var credit = UserDefaults.standard.integer(forKey: "credit")
    var score = UserDefaults.standard.integer(forKey: "score")
    var successiveRightAnswers = UserDefaults.standard.integer(forKey: "successiveRightAnswers")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        effect = visualEffect.effect
        menuView.layer.cornerRadius = 5
        visualEffect.effect = nil
        UserDefaults.standard.set(0, forKey: "cycleCount")
        if let plistPath = Bundle.main.path(forResource: "ArtistesAndPaintings", ofType: "plist"),
            let artistListNSArray = NSArray(contentsOfFile: plistPath){
            artistList = artistListNSArray as! [[String]]
            artistsCount = artistList.count
        }
        ///////// Sorting Array by Surname //////////////////
        var listOfArtistName: [String] = []
        var listOfArtistSurname: [String] = []
        var sortedArtistList: [[String]] = []
        for artist in artistList{
            listOfArtistName.append(artist[0])

        }

        for surname in listOfArtistName{
            listOfArtistSurname.append(surname.wordList.last!)
        }
        func alpha (_ s1: String, s2: String) -> Bool {
            return s1 < s2
        }
        listOfArtistSurname = listOfArtistSurname.sorted(by: alpha)
        
        for surname in listOfArtistSurname {
            for artist in artistList {
                if artist[0].contains(surname) && !sortedArtistList.contains(artist){
                    sortedArtistList.append(artist)
                }
            }
        }
        artistList = sortedArtistList
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            IntroductionMessage.showMessageView(view: self.view, messageView: self.menuView, visualEffect: self.visualEffect, effect: self.effect, learnArtLabel: self.learnArtLabel, slideShowButton: self.slideShowButton, starHereLabel: self.starHereLabel, quizButton: self.quizButton, testYourKnowledgeLabel: self.testYourKnowledgeLabel, allTheDataButton: self.allTheDataButton, consultAndLearnLabel: self.consultAndLearnLabel, manageYourCreditsButton: self.manageYourCreditsButton)
        }
        //UserDefaults.standard.set(35, forKey: "successiveRightAnswers")
        if !(userAlreadyExist(credit: "credit")){
            credit = 40
            UserDefaults.standard.set(credit, forKey: "credit")
            score = 0
            UserDefaults.standard.set(score, forKey: "score")
            successiveRightAnswers = 0
            UserDefaults.standard.set(successiveRightAnswers, forKey: "successiveRightAnswers")
            UserDefaults.standard.set(false, forKey: "artAmateurIsDone")
            UserDefaults.standard.set(false, forKey: "artConoisseurIsDone")
            UserDefaults.standard.set(false, forKey: "artExpertIsDone")
            UserDefaults.standard.set(false, forKey: "artScholarIsDone")
            UserDefaults.standard.set(false, forKey: "artMasterIsDone")
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if UIDevice.current.orientation.isLandscape{
            ImageManager.choosImage(imageView: grandeJatte, imageName: "Un dimanche après-midi à l'île de la Grande Jatte")
        }else{
            ImageManager.choosImage(imageView: grandeJatte, imageName: "detailDeaGrandeJatte")
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        IntroductionMessage.showMessageView(view: view, messageView: menuView, visualEffect: visualEffect, effect:effect, learnArtLabel: learnArtLabel, slideShowButton: slideShowButton, starHereLabel: starHereLabel, quizButton: quizButton, testYourKnowledgeLabel: testYourKnowledgeLabel, allTheDataButton: allTheDataButton, consultAndLearnLabel: consultAndLearnLabel, manageYourCreditsButton: manageYourCreditsButton)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSlideShowViewController" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            backItem.tintColor = UIColor.white
            let controller = segue.destination as! SlideShowViewController
            controller.artistList = artistList
            controller.artistsCount = artistsCount
        }
        if segue.identifier == "showInfoAndImageViewController"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            backItem.tintColor = UIColor.white
            isFromQuiz = false
            isFromMenu = true
            isFromSlideShow = false
            let controller = segue.destination as! infoAndImageViewController
            controller.isFromMenu = isFromMenu
            controller.isFromQuiz = isFromQuiz
            controller.isFromSlideShow = isFromSlideShow
            controller.artistList = artistList
            controller.artistsCount = artistsCount
        }
        if segue.identifier == "showViewController"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            backItem.tintColor = UIColor.white
            let controller = segue.destination as! QuizViewController
            controller.artistList = artistList
            //controller.artistsCount = artistsCount
        }
        if segue.identifier == "showBuyCredits"{
            let controller = segue.destination as! BuyCreditViewController
            controller.provenance = provenance
            let backItem = UIBarButtonItem()
            controller.navigationItem.hidesBackButton = true
            backItem.title = ""
        }

    }
    @IBAction func unwindToMainMenu (_ sender: UIStoryboardSegue) {
        IntroductionMessage.showMessageView(view: view, messageView: menuView, visualEffect: visualEffect, effect:effect, learnArtLabel: learnArtLabel, slideShowButton: slideShowButton, starHereLabel: starHereLabel, quizButton: quizButton, testYourKnowledgeLabel: testYourKnowledgeLabel, allTheDataButton: allTheDataButton, consultAndLearnLabel: consultAndLearnLabel, manageYourCreditsButton: manageYourCreditsButton)
    }
    func userAlreadyExist(credit: String) -> Bool {
        return UserDefaults.standard.object(forKey: credit) != nil
    }
}



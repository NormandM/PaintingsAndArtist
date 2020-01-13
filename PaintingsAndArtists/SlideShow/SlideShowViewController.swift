//
//  SlideShowViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-05-23.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation

class SlideShowViewController: UIViewController {
    @IBOutlet weak var slideShowUIImageView: UIImageView!
    var audioPlayer: AVAudioPlayer?
    var artistList: [[String]] = []
    var artistsCount = 0
    var vueTimer = Timer()
    var counterAnimation = 0
    var n = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
    var indexPainting: [Int] = []
    var isFromSlideShow = Bool()
    var isFromMenu = Bool()
    var isFromQuiz = Bool()
    var goingForwards = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        UIApplication.shared.isIdleTimerDisabled = true
        let path = Bundle.main.path(forResource: "Gymnopédie_no.3", ofType:"mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
            
        } catch {
            // couldn't load file :(
        }
        let randomizeOrderOfPaintings = RandomizeOrderOfIndexArray(artistList: artistList)
        indexPainting = randomizeOrderOfPaintings.generateRandomIndex(from: 0, to: artistList.count - 1, quantity: nil)
        ImageManager.choosImage(imageView: slideShowUIImageView, imageName: artistList[indexPainting[n]][2])
        vueTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SlideShowViewController.zoomAnimation), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        vueTimer.invalidate()
        UIApplication.shared.isIdleTimerDisabled = false
        if goingForwards == false{
            performSegue(withIdentifier: "goToMenu", sender: self)
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        goingForwards = false
    }


    @objc func changePainting () {
        if  counterAnimation > 80{
            x = 0
            y = 0
            counterAnimation = 0
            if n < artistsCount - 1{
                n = n + 1
            }else {
                n = 0
            }
            print("finished")
             UIView.animate(withDuration: 1, animations: {
            self.slideShowUIImageView.transform = CGAffineTransform.identity
             })
            ImageManager.choosImage(imageView: slideShowUIImageView, imageName: artistList[indexPainting[n]][2])
        }
 
    }
    @objc func zoomAnimation () {
        counterAnimation = counterAnimation + 1
        UIView.animate(withDuration: TimeInterval(5.0), delay: 3.0, options: .allowUserInteraction, animations: {
            self.slideShowUIImageView.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3) // Scale your image
        }, completion: {finished in
            self.changePainting()
        })
    }
    
    @IBAction func tapToIdentify(_ sender: UITapGestureRecognizer) {
        print("tapped")
       // slideShowUIImageView.stopAnimating()
        isFromSlideShow = true
        vueTimer.invalidate()
        performSegue(withIdentifier: "showPaintingInfo", sender: self)
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showPaintingInfo" {
            let controller = segue.destination as! infoAndImageViewController
            isFromSlideShow = true
            isFromMenu = false
            isFromQuiz = false
            goingForwards = true
            controller.isFromQuiz = isFromQuiz
            controller.isFromSlideShow = isFromSlideShow
            controller.isFromMenu = isFromMenu
            controller.specificArtistInfo = indexPainting[n]
            controller.artistList = artistList
        }
    }
    @IBAction func unwindToSlideShow(_ sender: UIStoryboardSegue) {
        vueTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SlideShowViewController.zoomAnimation), userInfo: nil, repeats: true)

    }


}

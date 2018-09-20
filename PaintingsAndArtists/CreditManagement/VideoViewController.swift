//
//  VideoViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-09-18.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class VideoViewController: UIViewController, GADRewardBasedVideoAdDelegate  {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var messageAfterTransaction: UILabel!
    
    @IBOutlet weak var OKButton: RoundButton!
    
    var rewardBasedAd: GADRewardBasedVideoAd!
    var isConnected = false
    var activityIndicatorView: ActivityIndicatorView!
    var activityIndicatorViewAsStop = false
    let fontsAndConstraints = FontsAndConstraints()
    var credit = 0
    var completedPlaying = false
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationItem.setHidesBackButton(true, animated:true);
        let reachability = Reachability()
        isConnected = reachability.isConnectedToNetwork()
        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-1437510869244180/7971005239")
        messageAfterTransaction.isHidden = true
        coinImage.isHidden = true
        if isConnected {
            self.activityIndicatorView = ActivityIndicatorView(title: "Loading Video...", center: self.view.center)
            self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
            self.activityIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // change 2 to desired number of seco
                if self.activityIndicatorViewAsStop == false{
                    self.activityIndicatorView.stopAnimating()
                    self.noConnectNoReason ()
                    self.OKButton.isHidden = true
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)
        messageAfterTransaction.font = sizeInfoAndFonts?.fontSize2
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageAfterTransaction.font = sizeInfoAndFonts?.fontSize2
        if !isConnected {
            self.showAlertNoInternetForPublicity()
        }
            OKButton.layer.masksToBounds = true
            OKButton.layer.cornerRadius = OKButton.frame.width/2
            OKButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
            OKButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
    }
    
        
        
    func showAlertNoInternetForPublicity() {
        OKButton.isHidden = true
        let alert = UIAlertController(title: "There is no internet connection", message: "You can only see a video if you are connected to the internet", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.Ok((Any).self)}))
        self.present(alert, animated: true, completion: nil)
    }
    func noConnectNoReason (){
        let alert = UIAlertController(title: "Cannot load  videos", message: "Please try later", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.Ok((Any).self)}))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func Ok(_ sender: Any) {
        performSegue(withIdentifier: "backToBuyCreditView", sender: self)
    }

    @IBAction func okButtonWasPressed(_ sender: RoundButton) {
        performSegue(withIdentifier: "backToBuyCreditView", sender: self)
    }
    
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("received add")
        completedPlaying = true
        rewardBasedAd.present(fromRootViewController: self)
        credit = UserDefaults.standard.integer(forKey: "credit")
        credit = credit + 20
        print(credit)
        UserDefaults.standard.set(credit, forKey: "credit")
        messageAfterTransaction.isHidden = false
        coinImage.isHidden = false
        OKButton.isHidden = false
    }
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("did receive ad")
        if rewardBasedAd.isReady {
            rewardBasedAd.present(fromRootViewController: self)
            activityIndicatorViewAsStop = true
            self.activityIndicatorView.stopAnimating()
        }

    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        messageAfterTransaction.isHidden = false
        if completedPlaying {
            messageAfterTransaction.text = """
            20 coins were added to your credits
            """
            
        }else{
            messageAfterTransaction.text = """
            The video was closed before
            getting the reward.
            """
        }

        OKButton.isHidden = false
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        var credit = UserDefaults.standard.integer(forKey: "credit")
        credit = credit + 20
        UserDefaults.standard.set(credit, forKey: "credit")

        
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        self.activityIndicatorView.stopAnimating()
        print(error)
        messageAfterTransaction.isHidden = false
        messageAfterTransaction.text = """
            Sorry, there is no Video Add at the moment.
            Please try later
        """
        OKButton.isHidden = false

        
    }

}

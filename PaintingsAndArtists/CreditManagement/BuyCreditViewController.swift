//
//  BuyCreditViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-07-17.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import StoreKit


class BuyCreditViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var buyCreditViewTitle: SpecialLabel!
    @IBOutlet weak var buy200CoinsLabel: UILabel!
    @IBOutlet weak var doneButton: RoundButton!
    @IBOutlet weak var coinsButton: UIButton!

    var provenance = String()
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var isNotConnectedNoReason = false
    let fontsAndConstraints = FontsAndConstraints()
    lazy var sizeInfo = fontsAndConstraints.size()
    var sizeInfoAndFonts: (screenDimension: String, fontSize1: UIFont, fontSize2: UIFont, fontSize3: UIFont, fontSize4: UIFont, fontSize5: UIFont, fontSize6: UIFont, fontSize7: UIFont, bioTextConstraint: CGFloat, collectionViewTopConstraintConstant: CGFloat)?
    var credit = UserDefaults.standard.integer(forKey: "credit"){
        didSet {
            buyCreditViewTitle.text = """
            CREDIT AVAILABLE: \(credit)
            To preserve the visual integrity of the App,
            except for this page, there are no adds in
            LEARN ART.
            """
        }
    }
    var priceCoins = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        let reachability = Reachability()
        let isConnected = reachability.isConnectedToNetwork()
        fetchAvailableProducts()
        isNotConnectedNoReason = false
        if !isConnected{
            self.showAlertNoInternet()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 2 to desired number of seconds
            if self.coinsButton.isEnabled == false{
                self.showNoConnection()
            }
        }
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black

        credit = UserDefaults.standard.integer(forKey: "credit")
        
    }



    override func viewWillAppear(_ animated: Bool) {
        sizeInfoAndFonts = (screenDimension: sizeInfo.0, fontSize1: sizeInfo.1, fontSize2: sizeInfo.2, fontSize3: sizeInfo.3, fontSize4: sizeInfo.4, fontSize5: sizeInfo.5, fontSize6: sizeInfo.6, fontSize7: sizeInfo.7, bioTextConstraint: sizeInfo.8,        collectionViewTopConstraintConstant: sizeInfo.9)

        buyCreditViewTitle.font = sizeInfoAndFonts?.fontSize2
        buyCreditViewTitle.layer.borderColor = UIColor.white.cgColor
        buyCreditViewTitle.layer.borderWidth = 3.0
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Buy Coins", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: sizeInfoAndFonts?.fontSize4 ?? UIFont(name: "HelveticaNeue-Bold", size: 12)!])
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
    }
    override func viewDidAppear(_ animated: Bool) {
        credit = UserDefaults.standard.integer(forKey: "credit")
        buyCreditViewTitle.text = """
        CREDIT AVAILABLE: \(credit)
        To preserve the visual integrity
        of the App, there are no adds in
        LEARN ART.
        """
        buy200CoinsLabel.text = """
        Do you enjoy LEARN ART?
        Buy 200 coins for \(priceCoins),
        It will last you for ever!
        """
        buy200CoinsLabel.font = sizeInfoAndFonts?.fontSize2
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.width/2
        doneButton.backgroundColor = UIColor(displayP3Red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        doneButton.titleLabel?.font = sizeInfoAndFonts?.fontSize6
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = doneButton.frame.width/2
    }

    @IBAction func doneHasBeenPressed(_ sender: RoundButton) {
        if provenance == "menu"{
            performSegue(withIdentifier: "menu", sender: self)
        }else if provenance == "quiz"{
            performSegue(withIdentifier: "quiz", sender: self)
        }
    }

    
    @IBAction func watchVideoHasBeenpressed(_ sender: UIButton) {

    }
    
    func showAlertNoInternet() {
        let alert = UIAlertController(title: "There is no internet connection", message: "You can only purchase credits if you are connected to the internet", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Go Back to Quiz", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.goBackToQuizMenus()}))
        self.present(alert, animated: true, completion: nil)
    }
    func showNoConnection() {
        let alert = UIAlertController(title: "Cannot connect to the App Store", message: "Please try later", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Go Back to Quiz", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.goBackToQuizMenus()}))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func goBackToQuizMenus() {
        performSegue(withIdentifier: "menu", sender: self)
    }
    func fetchAvailableProducts()  {
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: IAPProduct.coins.rawValue)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        iapProducts = response.products
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        let myCoins: SKProduct = response.products[0]  as SKProduct
        if let price = numberFormatter.string(from: myCoins.price) {
            priceCoins = price
        }
    }

    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        } else {
            let alert = UIAlertController(title: "Learn Art", message: "The purchase option is disabled on your device", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if productID ==  IAPProduct.coins.rawValue{
                        credit = UserDefaults.standard.integer(forKey: "credit")
                        credit = credit + 200
                        UserDefaults.standard.set(credit, forKey: "credit")
                        credit = UserDefaults.standard.integer(forKey: "credit")
                    }
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }

    
    @IBAction func buy200Coins(_ sender: UIButton) {
        purchaseMyProduct(product: iapProducts[0])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "quiz" {
            
        }
    }
}

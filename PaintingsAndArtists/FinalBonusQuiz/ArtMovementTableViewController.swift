//
//  ArtMovementTableViewController.swift
//  PaintingsAndArtists
//
//  Created by NORMAND MARTIN on 2021-04-09.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit

class ArtMovementTableViewController: UITableViewController {
    @IBOutlet var artMovementDefinitionView: UIView!
    @IBOutlet weak var artMovementDescriptionTextView: UITextView!
    @IBOutlet weak var titleArtMovementLabel: UILabel!
    @IBOutlet weak var OkButtom: RoundButton!
    var artMovementDic = [String: [String]]()
    var artMovementArray = [String]()
    let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
    var blurView = UIVisualEffectView()
    let customFont = FontsAndConstraints()
    override func viewDidLoad() {
        super.viewDidLoad()
        artMovementArray = Array(artMovementDic.keys)
        artMovementArray.sort()
        artMovementDescriptionTextView.layer.cornerRadius = 5
        artMovementDescriptionTextView.layer.borderWidth = 2
        artMovementDescriptionTextView.layer.borderColor = UIColor.white.cgColor
        titleArtMovementLabel.font = customFont.size().2
        artMovementDescriptionTextView.textContainerInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 20, right: 20)
        artMovementDescriptionTextView.font = customFont.size().3
        OkButtom.includeArrow()
        configureNavigation()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artMovementArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = artMovementArray[indexPath.row]
        cell.backgroundColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        cell.textLabel?.textColor = .white
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        if let cellUnWrapped =  cell, let key = cellUnWrapped.textLabel?.text, let array = artMovementDic[key] {
            artMovementDescriptionTextView.text = array[0]
            titleArtMovementLabel.text = key
        }
        view.addSubview(blurView)
        self.navigationItem.setHidesBackButton(true, animated: true)
        ArtMoveDefView.showView(view: view, artMovementView: artMovementDefinitionView, button: OkButtom, artMovementDescriptionTextView: artMovementDescriptionTextView, titleArtMovementLabel: titleArtMovementLabel)
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        blurView.removeFromSuperview()
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        view.addSubview(blurView)
        ArtMoveDefView.showView(view: view, artMovementView: artMovementDefinitionView, button: OkButtom, artMovementDescriptionTextView: artMovementDescriptionTextView, titleArtMovementLabel: titleArtMovementLabel)

    }
    

    // MARK: - Navigation

    func configureNavigation()  {
        self.navigationItem.title = "Select Art Movement"
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .black
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
    }
    
    @IBAction func okButtonPushed(_ sender: RoundButton) {
        ArtMoveDefView.dismissView(artMovementView: artMovementDefinitionView)
        blurView.removeFromSuperview()
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        
    }
    
}

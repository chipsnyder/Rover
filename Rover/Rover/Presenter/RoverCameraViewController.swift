//
//  RoverCameraViewController.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

class RoverCameraViewController: UIViewController {

    @IBOutlet weak var marsBackground: UIView!
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    var roverType:Rovers = Rovers.opportunity
    
    override func viewDidLoad() {
        super.viewDidLoad()

        marsBackground.curveTopEdge(magnitude: 0.2)
        marsBackground.addLinearGradient(bottom: Constants.Colors.marsBottomTone, top: Constants.Colors.marsTopTone)
        view.addLinearGradient(bottom: Constants.Colors.spaceBottomTone, top: Constants.Colors.spaceTopTone, start:CGPoint(x: 0.9, y: 0.0))
        cameraButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let roverImage = roverImageView.image {
            roverImageView.image = roverImage.withRenderingMode(.alwaysTemplate)
            roverImageView.tintColor = UIColor.groupTableViewBackground
        }
        
        title = roverType.rawValue.capitalized
    }
    
    @IBAction func cameraButtonSelected(_ sender: UIButton) {
    }
}

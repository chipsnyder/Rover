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
    var roverImageMetaData = [RoverImageMetaData]()
    var roverType = Rovers.opportunity
    var interactor = APINetworkInteractor.shared
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        marsBackground.curveTopEdge(magnitude: 0.2)
        marsBackground.addLinearGradient(bottom: Constants.Colors.marsBottomTone, top: Constants.Colors.marsTopTone)
        view.addLinearGradient(bottom: Constants.Colors.spaceBottomTone, top: Constants.Colors.spaceTopTone, start:CGPoint(x: 0.9, y: 0.0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let roverImage = roverImageView.image {
            roverImageView.image = roverImage.withRenderingMode(.alwaysTemplate)
            roverImageView.tintColor = UIColor.groupTableViewBackground
        }
        title = roverType.rawValue.capitalized
        fetchImageMetaData()
    }
    
    func fetchImageMetaData() {
        interactor.getImageMetaData(rover: roverType, page: page) { (imageMetaData:[RoverImageMetaData]?, error:Error?) in
            DispatchQueue.main.async {
                if error != nil {
                    self.showErrorAlert()
                } else if let imageMetaData = imageMetaData {
                    self.roverImageMetaData.append(contentsOf: imageMetaData)
                }
            }
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Houston We have a problem", message: "Something went wrong when getting the data", preferredStyle: .alert)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel)
        let retry = UIAlertAction(title: "Retry", style: .default) { (_) in
            self.fetchImageMetaData()
        }
        
        alert.addAction(cancel)
        alert.addAction(retry)
        present(alert, animated: true)
    }
}

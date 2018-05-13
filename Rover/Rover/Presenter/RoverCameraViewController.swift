//
//  RoverCameraViewController.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

class RoverCameraViewController: UIViewController {

    static let RoverCameraCellReuseIdentifier = "cameraImageCell"
    @IBOutlet weak var marsBackground: UIView!
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var roverImageMetaData = [RoverImageMetaData]()
    var roverType = Rovers.opportunity
    var interactor = APINetworkInteractor.shared
    var page = 1
    var canFetchMore = true
    
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
        
        if !canFetchMore {
            return
        }
        
        interactor.getImageMetaData(rover: roverType, page: page) { (imageMetaData:[RoverImageMetaData]?, error:Error?) in
            DispatchQueue.main.async {
                if error != nil {
                    self.showErrorAlert()
                } else if let imageMetaData = imageMetaData {
                    
                    self.canFetchMore = (imageMetaData.count >= 25) // 25 is the API limit on paging
                    
                    self.roverImageMetaData.append(contentsOf: imageMetaData)
                    self.collectionView.reloadData()
                    self.page = self.page + 1
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

extension RoverCameraViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roverImageMetaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverCameraViewController.RoverCameraCellReuseIdentifier, for: indexPath) as! CameraImageCollectionViewCell
        
        cell.imageMetaData = roverImageMetaData[indexPath.row]
        
        if(indexPath.row >= roverImageMetaData.count - 3) {
            fetchImageMetaData()
        }
        
        return cell
    }
    

}


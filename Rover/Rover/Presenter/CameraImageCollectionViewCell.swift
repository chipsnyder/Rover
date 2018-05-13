//
//  CameraImageCollectionViewCell.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

class CameraImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var earthDateLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    var imageTask:URLSessionDataTask?
    
    var imageMetaData : RoverImageMetaData? {
        didSet {
            earthDateLabel.text = imageMetaData?.earthDate ?? ""
            cameraLabel.text = imageMetaData?.camera ?? ""
            fetchImage(urlString: imageMetaData?.imageSrc ?? "")
        }
    }
    
    func fetchImage(urlString:String) {
        if let imageTask = imageTask {
            imageTask.cancel()
        }
        
        imageTask = APINetworkInteractor.shared.getImageData(imageURLString: urlString) { (data:Data?, error:Error?) in
            
            DispatchQueue.main.async {
                self.imageTask = nil
                
                guard error == nil else {
                    self.imageView.image = UIImage(named: "deathStar")
                    return
                }
                
                if let data = data {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

//
//  ViewController.swift
//  Rover
//
//  Created by Chip Snyder on 5/10/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

class MarsViewController: UIViewController {
    
    @IBOutlet weak var marsBackground: UIView!
    @IBOutlet weak var deathStarImageView: UIImageView!
    
    let marsBottomTone = UIColor(red: 234.0/255.0, green: 67.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    let marsTopTone = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0, alpha: 1.0)
    
    let spaceBottomTone = UIColor(red: 5.0/255.0, green: 55.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    let spaceTopTone = UIColor(red: 3.0/255.0, green: 33.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let marsBackground = marsBackground {
            marsBackground.curveTopEdge(magnitude: 0.5)
            marsBackground.addLinearGradient(bottom: marsBottomTone, top: marsTopTone)
        }
        
        view.addLinearGradient(bottom: spaceBottomTone, top: spaceTopTone, start:CGPoint(x: 0.9, y: 0.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let deathStarImageView = deathStarImageView,
            let deathStarImage = deathStarImageView.image {
            
            deathStarImageView.image = deathStarImage.withRenderingMode(.alwaysTemplate)
            deathStarImageView.tintColor = UIColor.groupTableViewBackground
        }
    }
}

extension UIView {
    // This implementation was modified from https://stackoverflow.com/a/28075863/1350218
    func curveTopEdge(magnitude:CGFloat){
        let offset = frame.size.height/magnitude
        let screenBounds = UIScreen.main.bounds
        let rectBounds = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y + screenBounds.size.height/2  , width:  screenBounds.size.width, height: screenBounds.size.height / 2)
        let rectPath = UIBezierPath(rect: rectBounds)
        let ovalBounds = CGRect(x: screenBounds.origin.x - offset / 2, y: screenBounds.origin.y, width: screenBounds.size.width + offset, height: screenBounds.size.height)
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        layer.mask = maskLayer
    }
    
    func addLinearGradient(bottom: UIColor, top:UIColor){
        addLinearGradient(bottom: bottom, top: top, start: CGPoint(x: 0.5, y: 0.05))
    }
    
    func addLinearGradient(bottom: UIColor, top:UIColor, start:CGPoint){
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [bottom.cgColor, top.cgColor]
        gradient.startPoint = start
        
        layer.insertSublayer(gradient, at: 0)
    }
    
}


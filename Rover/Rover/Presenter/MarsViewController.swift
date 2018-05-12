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
    @IBOutlet weak var opportunityRover: RoverView!
    @IBOutlet weak var curiousityRover: RoverView!
    @IBOutlet weak var spiritRover: RoverView!
    var rotationTimer:Timer?
    
    let marsBottomTone = UIColor(red: 234.0/255.0, green: 67.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    let marsTopTone = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0, alpha: 1.0)
    let spaceBottomTone = UIColor(red: 5.0/255.0, green: 55.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    let spaceTopTone = UIColor(red: 3.0/255.0, green: 33.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marsBackground.curveTopEdge(magnitude: 0.5)
        marsBackground.addLinearGradient(bottom: marsBottomTone, top: marsTopTone)
        
        view.addLinearGradient(bottom: spaceBottomTone, top: spaceTopTone, start:CGPoint(x: 0.9, y: 0.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let deathStarImage = deathStarImageView.image {
            deathStarImageView.image = deathStarImage.withRenderingMode(.alwaysTemplate)
            deathStarImageView.tintColor = UIColor.groupTableViewBackground
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rotationTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.rotateRovers), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rotationTimer?.invalidate()
    }
    
    @objc func rotateRovers() {
    
        let curiousityRoverPoint = curiousityRover.center
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveLinear, animations: {
            
            self.animateRover(source: self.curiousityRover, destination: self.spiritRover.center)
            self.animateRover(source: self.spiritRover, destination: self.opportunityRover.center)
            self.animateRover(source: self.opportunityRover, destination: curiousityRoverPoint)
            
        }, completion: { _ in
            self.curiousityRover.animateMoving(animate: false)
            self.spiritRover.animateMoving(animate: false)
            self.opportunityRover.animateMoving(animate: false)
        })
    }
    
    func animateRover(source: RoverView, destination:CGPoint) {
        source.animateMoving(animate: true)
        source.center = destination
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marsBackground.curveTopEdge(magnitude: 0.5)
        marsBackground.addLinearGradient(bottom: Constants.Colors.marsBottomTone, top: Constants.Colors.marsTopTone)
        view.addLinearGradient(bottom: Constants.Colors.spaceBottomTone, top: Constants.Colors.spaceTopTone, start:CGPoint(x: 0.9, y: 0.0))
        opportunityRover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(opportunityRoverSelected)))
        
        curiousityRover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(curiousityRoverSelected)))
        
        spiritRover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spiritRoverSelected)))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if let roverCamera = segue.destination as? RoverCameraViewController,
            let roverType = sender as? Rovers  {
            roverCamera.roverType = roverType
        }
    }
    
    func animateRover(source: RoverView, destination:CGPoint) {
        source.animateMoving(animate: true)
        source.center = destination
    }
    
    @objc func opportunityRoverSelected() {
        performSegue(withIdentifier: "pushRover", sender: Rovers.opportunity)
    }
    
    @objc func curiousityRoverSelected() {
        performSegue(withIdentifier: "pushRover", sender: Rovers.curiousity)
    }
    
    @objc func spiritRoverSelected() {
        performSegue(withIdentifier: "pushRover", sender: Rovers.spirit)
    }
}

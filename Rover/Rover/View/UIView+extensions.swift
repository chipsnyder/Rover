//
//  UIView+extensions.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

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

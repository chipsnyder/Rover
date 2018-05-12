//
//  RoverView.swift
//  Rover
//
//  Created by Chip Snyder on 5/11/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

@IBDesignable class RoverView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var roverName: UILabel!
    @IBOutlet weak var exhaust: UIImageView!
    
    @IBInspectable var name: String? {
        didSet { roverName.text = name }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "RoverView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func animateMoving(animate: Bool) {
        exhaust.isHidden = !animate
    }
}

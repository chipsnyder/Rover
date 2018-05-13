//
//  Constants.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

struct Constants {
    static let photosAPIFormat = "https://api.nasa.gov/mars-photos/api/v1/rovers/%@/photos?sol=1000&page=%d&api_key=%@"
    static let apiLookupKey = "nasaAPIKey"
    static let apiDemoKey = "DEMO_KEY"
    
    struct Colors {
        static let marsBottomTone = UIColor(red: 234.0/255.0, green: 67.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        static let marsTopTone = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0, alpha: 1.0)
        static let spaceBottomTone = UIColor(red: 5.0/255.0, green: 55.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        static let spaceTopTone = UIColor(red: 3.0/255.0, green: 33.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
}

enum Rovers : String {
    case curiosity
    case opportunity
    case spirit
}

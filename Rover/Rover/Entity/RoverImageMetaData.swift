//
//  RoverImageMetaData.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit

class RoverImageMetaData: NSObject {
    let earthDate:String
    let imageSrc:String
    let camera:String
    
    init(json: [String: Any]) {
        
        earthDate = json["earth_date"] as? String ?? ""
        imageSrc = json["img_src"] as? String ?? ""
        
        if let cameraJson = json["camera"] as? [String:Any] {
            camera = cameraJson["full_name"] as? String ?? ""
        } else {
            camera = ""
        }
        
        super.init()
    }
}

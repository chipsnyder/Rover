//
//  FirebaseInteractor.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit
import Firebase

class FirebaseInteractor: NSObject {
    
    static func configure() {
        FirebaseApp.configure()
        let config = RemoteConfig.remoteConfig()
        config.setDefaults([Constants.apiLookupKey:Constants.apiDemoKey as NSObject])
        config.fetch() {(status, error) in
            guard error == nil else {
                return
            }
            config.activateFetched()
        }
    }
}

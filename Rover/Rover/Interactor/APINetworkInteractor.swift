//
//  APINetworkInteractor.swift
//  Rover
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import UIKit
import Firebase

class APINetworkInteractor: NSObject {
    static let shared = APINetworkInteractor(session: URLSession.shared,
                                             apiKey: RemoteConfig.remoteConfig().configValue(forKey:Constants.apiLookupKey).stringValue)
    private let session : URLSession
    private let apiKey : String
    
    init(session:URLSession, apiKey:String?) {
        self.session = session
        self.apiKey = apiKey ?? Constants.apiDemoKey
        super.init()
    }
    
    func getImageData(imageURLString:String, completion:@escaping (_ result:Data?, _ error:Error?) -> Void) -> URLSessionDataTask? {
        
        if let url = URL(string: imageURLString) {
            let task = session.dataTask(with: url) { (data:Data?, _ , error:Error?) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(data, nil)
                }
            }
            
            task.resume()
            return task
        } else {
            completion(nil, NSError(domain:"Bad Parameters", code: 400, userInfo: nil))
        }
        
        return nil
    }
    
    func getImageMetaData(rover:Rovers, page:Int, completion:@escaping (_ result: [RoverImageMetaData]?, _ error:Error?) -> Void) {
        
        if let url = metaDataURL(rover: rover, page: page) {
            let task = session.dataTask(with: url) { (data:Data?, _ , error:Error?) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let imageMetaData = self.imageMetaData(withData: data) {
                    completion(imageMetaData, nil)
                } else {
                    completion(nil, NSError(domain:"Unknown Error", code: 500, userInfo: nil))
                }
            }
            
            task.resume()
        } else {
            completion(nil, NSError(domain:"Bad Parameters", code: 400, userInfo: nil))
        }
    }
    
    func metaDataURL(rover:Rovers, page:Int) -> URL? {
        let urlString = String(format: Constants.photosAPIFormat, rover.rawValue, page, apiKey)
        
        return URL(string: urlString)
    }
    
    func imageMetaData(withData data:Data) -> [RoverImageMetaData]? {
        
        var imageMetaData = [RoverImageMetaData]()
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? Dictionary<String,Any>
            if let photosMetaData = json?["photos"] as? [[String: Any]] {
                for item in photosMetaData {
                    imageMetaData.append(RoverImageMetaData(json: item))
                }
            }
            
        } catch _ {
            return nil
        }
        return imageMetaData
    }
}

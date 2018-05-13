//
//  APINetworkInteractorTests.swift
//  RoverTests
//
//  Created by Chip Snyder on 5/12/18.
//  Copyright © 2018 EisbarDev. All rights reserved.
//

import XCTest
import Nimble
@testable import Rover

class PartialMockURLSession: URLSession {
    var url:URL!
    var partialMockURLSessionDataTask = PartialMockURLSessionDataTask()
    
    var mockData:Data?
    var mockError:Error?
    
    init(mockData:Data?, mockError:Error?) {
        self.mockData = mockData
        self.mockError = mockError
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        completionHandler(mockData, nil, mockError)
        return partialMockURLSessionDataTask
    }
}

class PartialMockURLSessionDataTask: URLSessionDataTask {
    var resumeCalled = false
    
    override func resume() {
        resumeCalled = true
    }
}

class APINetworkInteractorTests: XCTestCase {
    var partialMockURLSession:PartialMockURLSession!
    var testInstance:APINetworkInteractor!
    
    override func setUp() {
        super.setUp()
        partialMockURLSession = PartialMockURLSession(mockData: nil, mockError: nil)
        testInstance = APINetworkInteractor(session: partialMockURLSession, apiKey: "TEST_KEY")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_getImageMetaData_badURL_itShouldCallCompletionWithError() {
        testInstance = APINetworkInteractor(session: partialMockURLSession, apiKey: "Bad KEY")
        
        testInstance.getImageMetaData(rover:.curiosity, page: 1) { (_, error:Error?) in
            expect(error).toNot(beNil())
        }
    }
    
    func test_getImageMetaData_itShouldStartTheDataTask() {
        testInstance.getImageMetaData(rover:.curiosity, page: 1){_,_ in }
        let partialMockURLSessionDataTask = self.partialMockURLSession.partialMockURLSessionDataTask
        expect(self.partialMockURLSession.url.absoluteString).to(equal("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=1&api_key=TEST_KEY"))
        expect(partialMockURLSessionDataTask.resumeCalled).to(beTrue())
    }
    
    func test_getImageMetaData_taskFailed_itShouldCallCompletionWithError() {
        
        partialMockURLSession = PartialMockURLSession(mockData: nil, mockError: NSError(domain: "test", code: 404, userInfo: nil))
        testInstance = APINetworkInteractor(session: partialMockURLSession, apiKey: "TEST_KEY")
        
        testInstance.getImageMetaData(rover:.curiosity, page: 1) { (_, error:Error?) in
            expect(error).toNot(beNil())
        }
    }
    
    func test_getImageMetaData_badData_itShouldCallCompletionWithError() {

        let text = "{\"photos\":[{\"id\":102693,\"sol\":1000,"
        let testData = text.data(using: .utf8)
        
        partialMockURLSession = PartialMockURLSession(mockData: testData, mockError: nil)
        testInstance = APINetworkInteractor(session: partialMockURLSession, apiKey: "TEST_KEY")
        
        testInstance.getImageMetaData(rover:.curiosity, page: 1) { (_, error:Error?) in
            expect(error).toNot(beNil())
        }
    }
    
    func test_getImageMetaData_goodData_itShouldCallCompletionWithObject() {

        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "goodData", ofType: "json")!
        var text = ""
        do {
            text = try String(contentsOfFile: path)
        } catch {
            fail()
        }
        
        let testData = text.data(using: .utf8)

        partialMockURLSession = PartialMockURLSession(mockData: testData, mockError: nil)
        testInstance = APINetworkInteractor(session: partialMockURLSession, apiKey: "TEST_KEY")

        testInstance.getImageMetaData(rover:.curiosity, page: 1) { (response:[RoverImageMetaData]?, _) in
            expect(response?.count).to(equal(25))
        }
    }
    
    func test_imageMetaData_goodData_itShouldConvertTheDataToObjects() {
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "goodData", ofType: "json")!
        var text = ""
        do {
            text = try String(contentsOfFile: path)
        } catch {
            fail()
        }
        
        let testData = text.data(using: .utf8)
        
        let response = testInstance.imageMetaData(withData: testData!)
        expect(response?.count).to(equal(25))
    }
    
    func test_metaDataURL_itShouldConstructTheProperURLForCuriosity() {
        let url = testInstance.metaDataURL(rover: .curiosity, page: 5)!
        expect(url.absoluteString).to(equal("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=5&api_key=TEST_KEY"))
    }
    
    func test_metaDataURL_itShouldConstructTheProperURLForSpirit() {
        let url = testInstance.metaDataURL(rover: .spirit, page: 1)!
        expect(url.absoluteString).to(equal("https://api.nasa.gov/mars-photos/api/v1/rovers/spirit/photos?sol=1000&page=1&api_key=TEST_KEY"))
    }
    
    func test_metaDataURL_itShouldConstructTheProperURLForOpportunity() {
        let url = testInstance.metaDataURL(rover: .opportunity, page: 2)!
        expect(url.absoluteString).to(equal("https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?sol=1000&page=2&api_key=TEST_KEY"))
    }
}

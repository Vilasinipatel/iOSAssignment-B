//
//  MainCollectionViewControllerTest.swift
//  iOSAssignment-BTests
//
//  Created by Villasini Patel on 16/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import XCTest
import Alamofire
import iOSAssignment_B
import Foundation

class MainCollectionViewControllerTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    func test_FetchTheContentDetail() {
        let promise = expectation(description: "Content data received successfully")
        Services.fetchContentDetail(){ response,error in
            if(response != nil){
                promise.fulfill()
            }else{
                XCTFail("Response error: \(String(describing: error?.localizedDescription))")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    func  test_DownloadImage() {
        let promise = expectation(description: "Image data received successfully")
        getImageData(parameters: Constants.imageUrl) { responseObject, error in
            if((responseObject) != nil){
                promise.fulfill()
            }else
            {
                XCTFail("Unable to download image due to response error: \(String(describing: error?.localizedDescription))")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    func getImageData(parameters: String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        Services.getImagesDownloaded(parameters,completionHandler:completionHandler)
    }
    
    func test_isValidURL_Success() {
        let promise = expectation(description: "Url validation done successfully")
        let urlCheckResult = Services.isValidUrl(urlString: Constants.jsonUrl)
        if(urlCheckResult){
             promise.fulfill()
        }else{
            XCTFail("Url validation got failed.")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    func test_isValidURL_Failure() {
        let promise = expectation(description: "Url is invalid")
        let urlCheckResult = Services.isValidUrl(urlString: Constants.invalidUrlTest)
        if(!urlCheckResult){
            promise.fulfill()
        }else{
            XCTFail("Url validation got failed.")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

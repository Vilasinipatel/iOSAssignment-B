//
//  MainCollectionViewControllerTest.swift
//  iOSAssignment-BTests
//
//  Created by Villasini Patel on 16/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
class MainCollectionViewControllerTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func FetchTheContentDetail_Test() {
        let promise = expectation(description: "Response received successfully")
            Alamofire.request(Constants.jsonUrl).responseString(completionHandler: {(response) in
                switch response.result{
                case.success(let contentValue):
                    self.CollectionJsonContentFakeBundleParse(contentValue: contentValue)
                     promise.fulfill()
                case.failure(let error):
                XCTFail("Response error: \(error.localizedDescription)")
                    
                }
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
  
    func CollectionJsonContentFakeBundleParse(contentValue: String){
        var ContentData = [JsonContentModel]();
        let jsonContent = JSON.init(parseJSON: contentValue)
        for array in jsonContent[Constants.rowsContentKey].arrayValue{
            ContentData.append(JsonContentModel.init(json: array))
        }
        XCTAssertEqual(ContentData.count, 0, "Didn't parse items from  response")
            }
    func GetImagesDownloaded(_ imageUrl: String){
        let promise = expectation(description: "Image data received successfully")
        Alamofire.request(imageUrl)
            .validate().responseData(completionHandler:{data in
                switch data.result {
                case .success:
                    promise.fulfill()
                    break
                case .failure(let error):
                    XCTFail("Unable to download image due to response error: \(error.localizedDescription)")
                    break
                }
            })
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

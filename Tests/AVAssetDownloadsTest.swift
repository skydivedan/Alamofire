//
//  AVAssetDownloadTests.swift
//  Alamofire
//
//  Created by Dan Morrow on 12/1/16.
//  Copyright © 2016 Alamofire. All rights reserved.
//

import Alamofire
import Foundation
import AVFoundation
import XCTest

class AVAssetDownloadTests: XCTestCase {
    
    var manager: AVAssetDownloadSessionManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        manager = AVAssetDownloadSessionManager(backgroundIdentifier: "alamo-tests-background")
    }
    
    override func tearDown() {
        manager.session.finishTasksAndInvalidate()
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testExample() {
        
        let expectation = self.expectation(description: "response received")
        
        var response : AVAssetDownloadResponse?
        
        let asset = AVURLAsset(url: URL(string: "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")!)
        manager.downloadAVAsset(asset: asset, title: "basic stream", data: nil, options: nil, location: { url in
            
            XCTAssertNotNil(url)
            
            print("the local file URL for the downloadable asset is \(url)")
        }).response { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20, handler: nil)
        
        XCTAssertNotNil(response?.avURLAsset)
        XCTAssertNotNil(response?.resolvedMediaSelection)
        XCTAssertNotNil(response?.response)
        XCTAssertNil(response?.error)
        
        if #available(iOS 10.0, macOS 10.12, tvOS 10.0, *) {
            XCTAssertNotNil(response?.metrics)
        }
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

//
//  BarracksClientTest.swift
//  BarracksClient
//
//  Created by Simon Guerout on 16-04-17.
//  Copyright © 2016 Barracks. All rights reserved.
//
//

import XCTest
import OHHTTPStubs
@testable import Barracks

class OSXExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        OHHTTPStubs.setEnabled(true)
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testUpdateUnavailable() {
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:UpdateCheckCallback = TestCallbackUnavailable(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
         _ in
         return OHHTTPStubsResponse(
         data: NSData(),
         statusCode:204,
         headers:["Content-Type":"application/json","Cache-Control":"no-cache"]
         )
         }.name = "Unavailable Response"
        
        
        client.checkUpdate(callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
            }
        )
    }
    
    func testUpdateAvailable() {
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:UpdateCheckCallback = TestCallbackAvailable(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
            _ in
            return OHHTTPStubsResponse(
                JSONObject: ["versionId" : "42"],
                statusCode:200,
                headers:["Content-Type":"application/json","Cache-Control":"no-cache"]
            )
            }.name = "Available Response"
        
        
        client.checkUpdate(callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
            }
        )
    }

    class TestCallbackUnavailable:UpdateCheckCallback {
        let expectation:XCTestExpectation
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onUpdateAvailable() {
        }
        func onUpdateUnavailable(){
            print("UNAVAILABLE")
            expectation.fulfill()
        }
        func onError(){
        }
    }
    
    class TestCallbackAvailable:UpdateCheckCallback {
        let expectation:XCTestExpectation
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onUpdateAvailable() {
            print("AVAILABLE")
            expectation.fulfill()
        }
        func onUpdateUnavailable(){
        }
        func onError(){
        }
    }
    
    class TestCallbackEror:UpdateCheckCallback {
        let expectation:XCTestExpectation
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onUpdateAvailable() {
        }
        func onUpdateUnavailable(){
        }
        func onError(){
            print("ERROR")
            expectation.fulfill()
        }
    }
    
}
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
        let callback:TestCallback = TestCallback(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
         _ in
         return OHHTTPStubsResponse(
         data: NSData(),
         statusCode:204,
         headers:["Content-Type":"application/json","Cache-Control":"no-cache"]
         )
         }.name = "Basic Response"
        
        
        client.checkUpdate(callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.called)
            }
        )
        XCTAssert(callback.called)
    }

    class TestCallback:UpdateCheckCallback {
        var called: Bool = false
        let expectation:XCTestExpectation
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onUpdateAvailable() {
            called = true
            expectation.fulfill()
        }
        func onUpdateUnavailable(){
            called = true
            expectation.fulfill()
        }
        func onError(){
            called = true
            expectation.fulfill()
        }
    }
    
}
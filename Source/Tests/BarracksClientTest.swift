/*
 *    Copyright 2016 Barracks Solutions Inc.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

import XCTest
import OHHTTPStubs
@testable import Barracks

class OSXExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        OHHTTPStubs.setEnabled(true)
        OHHTTPStubs.onStubActivation() { request, stub, response in
            print("\(request.URL!) stubbed by \(stub.name).")
        }
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
                JSONObject: [
                    "versionId" : "42",
                    "url" : "someUrl",
                    "hash" : "someHash",
                    "size" : 0
                ],
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
    
    func testUpdateError() {
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:UpdateCheckCallback = TestCallbackEror(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
            _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
            }.name = "Error Response"
        
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
        
        func onUpdateUnavailable(){
            print("UNAVAILABLE")
            expectation.fulfill()
        }
        func onUpdateAvailable(update: UpdateCheckResponse) {
        }
        func onError(_:NSError?){
        }
    }
    
    class TestCallbackAvailable:UpdateCheckCallback {
        let expectation:XCTestExpectation
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onUpdateAvailable(_:UpdateCheckResponse) {
            print("AVAILABLE")
            expectation.fulfill()
        }
        func onUpdateUnavailable(){
        }
        func onError(_:NSError?){
        }
    }
    
    class TestCallbackEror:UpdateCheckCallback {
        let expectation:XCTestExpectation
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onUpdateAvailable(_:UpdateCheckResponse) {
        }
        func onUpdateUnavailable(){
        }
        func onError(_:NSError?){
            print("ERROR")
            expectation.fulfill()
        }
    }
    
}
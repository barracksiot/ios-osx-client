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
        let callback:ExpectedCallback = TestCallbackUnavailable(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
            _ in
            return OHHTTPStubsResponse(
                data: NSData(),
                statusCode:204,
                headers:["Content-Type":"application/json","Cache-Control":"no-cache"]
            )
            }.name = "Unavailable Response"
        
        let request = UpdateCheckRequest(unitId:"deadbeef", versionId: "42")
        
        client.checkUpdate(request, callback:callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testUpdateAvailable() {
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedCallback = TestCallbackAvailable(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
            _ in
            let stubPath = OHPathForFile("update_check_response_success.json", self.dynamicType)
            return fixture(stubPath!, status:200, headers: ["Content-Type":"application/json"])
            }.name = "Available Response"
        
        let request = UpdateCheckRequest(unitId:"deadbeef", versionId: "42")
        
        client.checkUpdate(request, callback: callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testUpdateError() {
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedCallback = TestCallbackEror(expectation: expectationWithDescription("callbackCaled"))
        
        stub(isHost("barracks.io")) {
            _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
            }.name = "Error Response"
        
        let request = UpdateCheckRequest(unitId:"deadbeef", versionId: "42")
        client.checkUpdate(request, callback: callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    class ExpectedCallback: UpdateCheckCallback {
        let expectation:XCTestExpectation
        var success = false
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        @objc func onUpdateUnavailable(){
            expectation.fulfill()
        }
        @objc func onUpdateAvailable(update: UpdateCheckResponse) {
            expectation.fulfill()
        }
        @objc func onError(_:NSError?){
            expectation.fulfill()
        }
    }
    
    
    class TestCallbackUnavailable:ExpectedCallback {
        override func onUpdateUnavailable(){
            success = true
            super.onUpdateUnavailable()
        }
    }
    
    class TestCallbackAvailable:ExpectedCallback {
        override func onUpdateAvailable(r:UpdateCheckResponse) {
            success = true
            super.onUpdateAvailable(r)
        }
    }
    
    class TestCallbackEror:ExpectedCallback {
        override func onError(e:NSError?){
            success = true
            super.onError(e)
        }
    }
    
}

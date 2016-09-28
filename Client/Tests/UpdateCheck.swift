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

class UpdateCheckTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        OHHTTPStubs.setEnabled(true)
        OHHTTPStubs.onStubActivation { (request, stubDescriptor, stubResponse) in
            print("\(request.url!) stubbed by \(stubDescriptor.name).")
        }
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testUpdateUnavailable() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedUpdateCallback = TestCallbackUnavailable(expectation: expectation(description: "testUpdateUnavailable"))
        
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            return OHHTTPStubsResponse(
                data: Data(),
                statusCode:204,
                headers:["Content-Type":"application/json", "Cache-Control":"no-cache"]
            )
            }.name = "Unavailable Response"
        
        let request = UpdateCheckRequest(unitId:"deadbeef", versionId: "42")
        
        client.checkUpdate(request, callback:callback)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testUpdateAvailable() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedUpdateCallback = TestCallbackAvailable(expectation: expectation(description: "testUpdateAvailable"))
        
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            let stubPath = OHPathForFile("update_check_response_success.json", type(of: self))
            return fixture(filePath: stubPath!, status:200, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
            }.name = "Available Response"
        
        let request = UpdateCheckRequest(unitId:"deadbeef", versionId: "42")
        
        client.checkUpdate(request, callback: callback)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testUpdateError() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedUpdateCallback = TestCallbackError(expectation: expectation(description: "testUpdateError"))
        
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
            }.name = "Error Response"
        
        let request = UpdateCheckRequest(unitId:"deadbeef", versionId: "42")
        client.checkUpdate(request, callback: callback)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    class ExpectedUpdateCallback: UpdateCheckCallback {
        let expectation:XCTestExpectation
        var success = false
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        @objc func onUpdateUnavailable(_ request:UpdateCheckRequest){
            expectation.fulfill()
        }
        @objc func onUpdateAvailable(_ request:UpdateCheckRequest, update: UpdateCheckResponse) {
            expectation.fulfill()
        }
        @objc func onError(_ request:UpdateCheckRequest, error:NSError?){
            expectation.fulfill()
        }
    }
    
    
    class TestCallbackUnavailable:ExpectedUpdateCallback {
        override func onUpdateUnavailable(_ request:UpdateCheckRequest){
            success = true
            super.onUpdateUnavailable(request)
        }
    }
    
    class TestCallbackAvailable:ExpectedUpdateCallback {
        override func onUpdateAvailable(_ request:UpdateCheckRequest, update:UpdateCheckResponse) {
            success = true
            super.onUpdateAvailable(request, update:update)
        }
    }
    
    class TestCallbackError:ExpectedUpdateCallback {
        override func onError(_ request:UpdateCheckRequest, error:NSError?){
            success = true
            super.onError(request, error: error)
        }
    }
    
    
}

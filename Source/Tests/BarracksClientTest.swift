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
        let callback:ExpectedUpdateCallback = TestCallbackUnavailable(expectation: expectationWithDescription("testUpdateUnavailable"))
        
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
        let callback:ExpectedUpdateCallback = TestCallbackAvailable(expectation: expectationWithDescription("testUpdateAvailable"))
        
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
        let callback:ExpectedUpdateCallback = TestCallbackError(expectation: expectationWithDescription("testUpdateError"))
        
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
    
    func testDownloadProgress() {
        stub(isHost("barracks.io")) {
            _ in
            let stubPath = OHPathForFile("firmware.jpg", self.dynamicType)
            return fixture(stubPath!, status:200, headers: ["Content-Type":"application/octet-stream"])
            }.name = "Firmware response"
        
        let response = UpdateCheckResponse(
            versionId:"v0.2",
            packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
            properties:nil
        )
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadProgress(expectation: expectationWithDescription("testDownloadProgress"))
        client.downloadPackage(response, callback: callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadSuccess() {
        stub(isHost("barracks.io")) {
            _ in
            let stubPath = OHPathForFile("firmware.jpg", self.dynamicType)
            return fixture(stubPath!, status:200, headers: ["Content-Type":"application/octet-stream"])
            }.name = "Firmware response"
        
        let response = UpdateCheckResponse(
            versionId:"v0.2",
            packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
            properties:nil
        )
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadSuccess(expectation: expectationWithDescription("testDownloadSuccess"))
        client.downloadPackage(response, callback: callback)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
        
    }
    
    func testDownloadSpecificLocation() {
        stub(isHost("barracks.io")) {
            _ in
            let stubPath = OHPathForFile("firmware.jpg", self.dynamicType)
            return fixture(stubPath!, status:200, headers: ["Content-Type":"application/octet-stream"])
            }.name = "Firmware response"
        
        let response = UpdateCheckResponse(
            versionId:"v0.2",
            packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
            properties:nil
        )
        
        let manager = NSFileManager.defaultManager()
        let destination = manager
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            .URLByAppendingPathComponent("BarracksTests", isDirectory:true)
            .URLByAppendingPathComponent("firmware.bin")
        
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadSuccess(expectation: expectationWithDescription("testDownloadSpecificLocation"))
        
        client.downloadPackage(response, callback: callback, destination:destination.path)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadFileExists() {
        stub(isHost("barracks.io")) {
            _ in
            let stubPath = OHPathForFile("firmware.jpg", self.dynamicType)
            return fixture(stubPath!, status:200, headers: ["Content-Type":"application/octet-stream"])
            }.name = "Firmware response"
        
        let response = UpdateCheckResponse(
            versionId:"v0.2",
            packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
            properties:nil
        )
        
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectationWithDescription("testDownloadSpecificLocation"))
        
        client.downloadPackage(response, callback: callback, destination:"/private")
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadDirectoryFailure() {
        stub(isHost("barracks.io")) {
            _ in
            let stubPath = OHPathForFile("firmware.jpg", self.dynamicType)
            return fixture(stubPath!, status:200, headers: ["Content-Type":"application/octet-stream"])
            }.name = "Firmware response"
        
        let response = UpdateCheckResponse(
            versionId:"v0.2",
            packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
            properties:nil
        )
        
        let client:BarracksClient = BarracksClient(apiKey: "deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectationWithDescription("testDownloadSpecificLocation"))
        
        client.downloadPackage(response, callback: callback, destination:"/private/directory/subdirectory/destination.bin")
        waitForExpectationsWithTimeout(
            5,
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
    
    
    class TestCallbackUnavailable:ExpectedUpdateCallback {
        override func onUpdateUnavailable(){
            success = true
            super.onUpdateUnavailable()
        }
    }
    
    class TestCallbackAvailable:ExpectedUpdateCallback {
        override func onUpdateAvailable(r:UpdateCheckResponse) {
            success = true
            super.onUpdateAvailable(r)
        }
    }
    
    class TestCallbackError:ExpectedUpdateCallback {
        override func onError(e:NSError?){
            success = true
            super.onError(e)
        }
    }
    
    class ExpectedDownloadCallback:PackageDownloadCallback {
        let expectation:XCTestExpectation
        var success = false
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        @objc func onProgress(response:UpdateCheckResponse, progress:UInt){
        }
        @objc func onSuccess(response:UpdateCheckResponse, path:String) {
        }
        @objc func onError(response:UpdateCheckResponse, error: NSError?){
            expectation.fulfill()
        }
    }
    
    class TestDownloadProgress:ExpectedDownloadCallback {
        override func onProgress(response: UpdateCheckResponse, progress: UInt) {
            if(progress >= 0 && progress < 100) {
                print(progress)
            } else {
                if(progress == 100) {
                    success = true
                }
                expectation.fulfill()
            }
        }
    }
    
    class TestDownloadSuccess:ExpectedDownloadCallback {
        override func onSuccess(response: UpdateCheckResponse, path: String) {
            success = true
            expectation.fulfill()
        }
    }
    
    class TestDownloadError:ExpectedDownloadCallback {
        override func onError(response:UpdateCheckResponse, error: NSError?) {
            success = true
            expectation.fulfill()
        }
    }
    
}

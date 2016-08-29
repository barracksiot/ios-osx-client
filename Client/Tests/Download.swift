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

class DownloadTests: XCTestCase {
    let validResponse = UpdateCheckResponse(
        versionId:"v0.2",
        packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
        properties:nil
    )
    
    let invalidResponse = UpdateCheckResponse(
        versionId:"v0.2",
        packageInfo:PackageInfo(url:"http://barracks.io/devices/update/download/v0.2", md5:"dummycrapfortestpurpose", size:101236),
        properties:nil
    )
    
    let validFirmwareResponse:OHHTTPStubsResponseBlock = {
        _ in
        let stubPath = OHPathForFile("firmware.jpg", DownloadTests.self)
        return fixture(stubPath!, status:200, headers: ["Content-Type":"application/octet-stream"])
    }
    
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
    
    func testDownloadProgress() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadProgress(expectation: expectationWithDescription("testDownloadProgress"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback)
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
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadSuccess(expectation: expectationWithDescription("testDownloadSuccess"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback)
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
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadSuccess(expectation: expectationWithDescription("testDownloadSpecificLocation"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        let manager = NSFileManager.defaultManager()
        let destination = manager
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            .URLByAppendingPathComponent("BarracksTests", isDirectory:true)
            .URLByAppendingPathComponent("firmware.bin")
        
        client.downloadPackage(validResponse, callback: callback, destination:destination.path)
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
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectationWithDescription("testDownloadFileExists"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback, destination:"/private")
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
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectationWithDescription("testDownloadDirectoryFailure"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback, destination:"/private/directory/subdirectory/destination.bin")
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadFailure() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectationWithDescription("testDownloadFailure"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
            }.name = "Error Response"
        
        client.downloadPackage(validResponse, callback: callback, destination:"/private/directory/subdirectory/destination.bin")
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testHashFailure() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectationWithDescription("testHashFailure"))
        stub(isHost("barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        let manager = NSFileManager.defaultManager()
        let destination = manager
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            .URLByAppendingPathComponent("BarracksTests", isDirectory:true)
            .URLByAppendingPathComponent("firmware.bin")
        
        client.downloadPackage(invalidResponse, callback: callback, destination:destination.path)
        waitForExpectationsWithTimeout(
            5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
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
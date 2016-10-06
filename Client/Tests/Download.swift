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
        packageInfo:PackageInfo(url:"https://app.barracks.io/api/devices/update/download/v0.2", md5:"09928956275ef9e22ac2c0208bbc2928", size:101236),
        customUpdateData:nil
    )
    
    let invalidResponse = UpdateCheckResponse(
        versionId:"v0.2",
        packageInfo:PackageInfo(url:"https://app.barracks.io/api/devices/update/download/v0.2", md5:"dummycrapfortestpurpose", size:101236),
        customUpdateData:nil
    )
    
    let validFirmwareResponse:OHHTTPStubsResponseBlock = {
        _ in
        let stubPath = OHPathForFile("firmware.jpg", DownloadTests.self)
        return fixture(filePath: stubPath!, status:200, headers: ["Content-Type" as NSObject:"application/octet-stream" as AnyObject])
    }
    
    override func setUp() {
        super.setUp()
        OHHTTPStubs.setEnabled(true)
        OHHTTPStubs.onStubActivation() { (request, stubDescriptor, stubResponse) in
            print("\(request.url!) stubbed by \(stubDescriptor.name).")
        }
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testDownloadProgress() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadProgress(expectation: expectation(description: "testDownloadProgress"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback)

        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                print(" ERROR LA : \(error.debugDescription)")
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadSuccess() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadSuccess(expectation: expectation(description: "testDownloadSuccess"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
        
    }
    
    func testDownloadSpecificLocation() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadSuccess(expectation: expectation(description: "testDownloadSpecificLocation"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        let manager = FileManager.default
        let destination = manager
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("BarracksTests", isDirectory:true)
            .appendingPathComponent("firmware.bin")
        
        client.downloadPackage(validResponse, callback: callback, destination:destination.path)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadFileExists() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectation(description: "testDownloadFileExists"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback, destination:"/private")
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadDirectoryFailure() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectation(description: "testDownloadDirectoryFailure"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        client.downloadPackage(validResponse, callback: callback, destination:"/private/directory/subdirectory/destination.bin")
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testDownloadFailure() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectation(description: "testDownloadFailure"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
            }.name = "Error Response"
        
        client.downloadPackage(validResponse, callback: callback, destination:"/private/directory/subdirectory/destination.bin")
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testHashFailure() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedDownloadCallback = TestDownloadError(expectation: expectation(description: "testHashFailure"))
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey), response: validFirmwareResponse).name = "Firmware response"
        
        let manager = FileManager.default
        let destination = manager
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("BarracksTests", isDirectory:true)
            .appendingPathComponent("firmware.bin")
        
        client.downloadPackage(invalidResponse, callback: callback, destination:destination.path)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    class ExpectedDownloadCallback:PackageDownloadCallback {
        weak var expectation:XCTestExpectation?
        var success = false
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onProgress(_ response:UpdateCheckResponse, progress:UInt){
        }
        func onSuccess(_ response:UpdateCheckResponse, path:String) {
        }
        func onError(_ response:UpdateCheckResponse, error: Error?){
            expectation?.fulfill()
        }
    }
    
    class TestDownloadProgress:ExpectedDownloadCallback {
        override func onProgress(_ response: UpdateCheckResponse, progress: UInt) {
            if(progress >= 0 && progress < 100) {
                print(progress)
            } else {
                if(progress == 100) {
                    success = true
                }
                expectation?.fulfill()
            }
        }
    }
    
    class TestDownloadSuccess:ExpectedDownloadCallback {
        override func onSuccess(_ response: UpdateCheckResponse, path: String) {
            success = true
            expectation?.fulfill()
        }
    }
    
    class TestDownloadError:ExpectedDownloadCallback {
        override func onError(_ response:UpdateCheckResponse, error: Error?) {
            success = true
            expectation?.fulfill()
        }
    }
}

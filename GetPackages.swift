//
//  GetPackages.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation
import XCTest
import OHHTTPStubs
@testable import Barracks

class GetPackagesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        OHHTTPStubs.setEnabled(true)
        OHHTTPStubs.onStubActivation { (request, stubDescriptor, stubResponse) in
            print("\(request.url!) stubbed by \(String(describing: stubDescriptor.name)).")
        }
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    
    func testGetDevicePackagesError() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedGetDevicePackagesCallback = TestCallbackError(expectation: expectation(description: "testGetDevicePackagesError"))
        
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
            }.name = "Error Response"
        
        let request = GetDevicePackagesRequest(unitId: "deadbeef", packages: [], customClientData: [:])
        client.getDevicePackages(request: request, callback: callback)
        waitForExpectations(
            timeout: 5,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )
    }
    
    func testGetDevicePackagesResponse() {
        let client:BarracksClient = BarracksClient("deadbeef")
        let callback:ExpectedGetDevicePackagesCallback = TestCallbackResponse(expectation: expectation(description: "testGetDevicePackagesResponse"))
        
        stub(condition: isHost("app.barracks.io") && hasHeaderNamed("Authorization", value:client.apiKey)) {
            _ in
            let stubPath = OHPathForFile("get_device_packages_response.json", type(of: self))
            return fixture(filePath: stubPath!, status:200, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
            }.name = "Available Response"
        
        let request = GetDevicePackagesRequest(unitId: "deadbeef", packages: [], customClientData: [:])
        client.getDevicePackages(request: request, callback: callback)
        waitForExpectations(
            timeout: 50,
            handler: {
                error in
                XCTAssertNil(error, "Error")
                XCTAssert(callback.success)
            }
        )

    }
    
    class ExpectedGetDevicePackagesCallback: GetDevicePackagesCallback {
        let expectation:XCTestExpectation
        var success = false
        
        init(expectation:XCTestExpectation) {
            self.expectation = expectation
        }
        
        func onResponse(request: GetDevicePackagesRequest, response: GetDevicePackagesResponse) {
            expectation.fulfill()
        }
        
        func onError(_ request: GetDevicePackagesRequest, error: Error?) {
            expectation.fulfill()
        }
    }
    
    class TestCallbackError:ExpectedGetDevicePackagesCallback {
        override func onError(_ request: GetDevicePackagesRequest, error: Error?) {
            success = true
            super.onError(request, error: error)
        }
    }
    
    class TestCallbackResponse:ExpectedGetDevicePackagesCallback {
        override func onResponse(request: GetDevicePackagesRequest, response: GetDevicePackagesResponse) {
            success = response.available.count == 1
                && response.changed.count == 1
                && response.unavailable.count == 1
                && response.unchanged.count == 1
            
            super.onResponse(request: request, response: response)
        }
    }
}

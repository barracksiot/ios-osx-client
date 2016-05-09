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

/**
 The main entry point for using Barracks' SDK.
 This class provides methods to help you getting information about the available updates
 for a specific configuration.
 */
@objc public class BarracksClient : NSObject {
    /// Your account's API key
    public let apiKey:String
    /// The base URL for contacting the Barracks service
    public let baseUrl:String
    
    /**
     Create a client using the parameters provided by the Barracks platform.
     
     - parameter apiKey:    Your account's API key
     - parameter baseUrl:   The base URL for Barracks, if you have set one up
     */
    public init(_ apiKey:String, baseUrl:String = "https://barracks.io/device/update/check") {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
}
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
 This protocol is used when requesting details about an update using `BarracksClient.checkUpdate(_:callback:)`.
 */
@objc public protocol UpdateCheckCallback: class {
    /**
     This method is called when the Barracks service identifies an eligible update.
     
     - parameter request:   The `UpdateCheckRequest` request used to check for an update
     - parameter update:    The `UpdateCheckResponse` containing the details of the eligible update
     */
    optional func onUpdateAvailable(request: UpdateCheckRequest, update: UpdateCheckResponse)
    
    /**
     This method is called when the Barracks service identifies that there is no eligible update
     
     - parameter request:   The `UpdateCheckRequest` request used to check for an update
     */
    optional func onUpdateUnavailable(request: UpdateCheckRequest)
    
    /**
     This method is called when an error occurs during the request to the Barracks service.
     
     - parameter request:   The `UpdateCheckRequest` request used to check for an update
     - parameter error:     The error which happened during the request
     */
    optional func onError(request: UpdateCheckRequest, error: NSError?)
}
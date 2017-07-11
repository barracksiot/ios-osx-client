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
 This protocol is used when requesting device's packages status using `BarracksClient.getDevicePackages(_:callback:)`.
 */
public protocol GetDevicePackagesCallback : class {

    /**
     This method is called when the Barracks service return the device's packages status.
     
     - parameter request:   The `GetDevicePackagesRequest` request used to check for an update
     - parameter update:    The `GetDevicePackagesResponse` containing the details of the packages
     */
    func onResponse(request:GetDevicePackagesRequest, response:GetDevicePackagesResponse)
    
    /**
     This method is called when an error occurs during the request to the Barracks service.
     
     - parameter request:   The `GetDevicePackagesRequest` request used to check for an update
     - parameter error:     The error which happened during the request
     */
    func onError(_ request:GetDevicePackagesRequest, error:Error?)

}

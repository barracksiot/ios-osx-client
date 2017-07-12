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
 This class is used when performing a request for an update using `BarracksClient.getDevicePackages(_:callback:)`
 */
public class GetDevicePackagesRequest {
    
    /// The unique identifier for the unit being used
    public let unitId:String
    
    /// User defined customClientData which will be sent to the Barracks service
    public let customClientData:[String: AnyObject]
    
    /// The list of the references and versions of the packages installed on the device
    public let packages:[InstalledPackage]
    
    /**
     Creates a request which can be sent to the Barracks service.
     
     - parameter unitId:            The unique identifier for the unit being used
     - parameter packages:          The list of the references and versions of the packages installed on the device, wrapped in `InstalledPackage` objects
     - parameter customClientData:  User defined customClientData which will be sent to the Barracks service
     */
    public init(unitId:String, packages:[InstalledPackage], customClientData:[String: AnyObject]) {
        self.unitId = unitId
        self.packages = packages
        self.customClientData = customClientData
    }
}

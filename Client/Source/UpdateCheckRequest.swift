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
 This class is used when performing a request for an update using `BarracksClient.checkUpdate(_:callback:)`
 */
public class UpdateCheckRequest {
    /// The unique identifier for the unit being used
    let unitId:String
    /// The version identifier of the current package used by the unit
    let versionId:String
    /// User defined customClientData which will be sent to the Barracks service
    let customClientData:[String: AnyObject]
    
    /**
     Creates a request which can be sent to the Barracks service.
     
     - parameter unitId:        The unique identifier for the unit being used
     - parameter versionId:     The version identifier of the current package used by the unit
     - parameter customClientData:    User defined customClientData which will be sent to the Barracks service
     */
    public init(unitId:String, versionId:String, customClientData:[String: AnyObject]=[String:AnyObject]()) {
        self.unitId = unitId
        self.versionId = versionId
        self.customClientData = customClientData
    }
}

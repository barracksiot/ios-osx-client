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
 This class is a container for a response provided by the Barracks service.
 The instance of this class is retrieved in the `UpdateCheckCallback.onUpdateAvailable(update:)` when the call to `BarracksClient.checkUpdate(_:callback:)` is successful.
 You can then use it to download the update package using `BarracksClient.downloadPackage(response:, callback:, destination:)`.
 */
@objc public class UpdateCheckResponse : NSObject {
    /// The version ID of the update.
    public let versionId: String
    /// The package information, useful for downloading and checking the package.
    public let packageInfo: PackageInfo
    /// The user-defined properties of the update.
    public let properties: [String: AnyObject?]?
    
    init(versionId:String, packageInfo:PackageInfo, properties: [String: AnyObject?]?) {
        self.versionId = versionId
        self.packageInfo = packageInfo
        self.properties = properties
    }
}
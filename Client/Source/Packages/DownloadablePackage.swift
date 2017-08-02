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

import Foundation

/**
 This class is the container for newly available package returned by the Barracks service.
 You can then use it to download the package using `BarracksClient.downloadPackage(package:, callback:, destination:)`.
 */
public class DownloadablePackage: DevicePackage {
    
    /// The url at which the file is available
    public let url: String
    /// The MD5 hash which will be used to verify the file integrity
    public let md5: String
    /// The expected size of the file
    public let size: UInt64
    /// The name of the package file
    public let filename:String
    
    init(reference:String, version:String, url:String, md5:String, size:UInt64, filename:String) {
        self.url = url
        self.md5 = md5
        self.size = size
        self.filename = filename
        super.init(reference:reference, version:version)
    }
}

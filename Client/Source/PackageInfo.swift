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
 This class is a container for the package informations useful for downloading and checking the udpate package.
 */
@objc public class PackageInfo : NSObject {
    /// The url at which the file is available
    public let url: String
    /// The MD5 hash which will be used to verify the file integrity
    public let md5: String
    /// The expected size of the file
    public let size: UInt64
    
    init(url:String, md5:String, size:UInt64) {
        self.url = url
        self.md5 = md5
        self.size = size
    }
}
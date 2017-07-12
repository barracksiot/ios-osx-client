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
 This protocol is used when downloading an update using `BarracksClient.downloadPackage(package:, callback:, destination:)`
 */
public protocol DownloadPackageCallback {
    /**
     This method is called during the download, to inform of the progress of the download.
     
     - parameter package:   The `AvailablePackage or ChangedPackage` to download.
     - parameter progress:  The download progress in percent.
     */
    func onProgress(_ package:AvailablePackage, progress:UInt)
    
    /**
     This method is called when an error occurs during the download.
     
     - parameter package:   The `AvailablePackage or ChangedPackage` to download.
     - parameter error:     The error raised during the download.
     */
    func onError(_ package:AvailablePackage, error: Error?)
    
    /**
     This method is used when an download is successfully completed.
     
     - parameter package:   The `AvailablePackage or ChangedPackage` to download.
     - parameter path:      The path of the downloaded file.
     */
    func onSuccess(_ package:AvailablePackage, path:String)
}

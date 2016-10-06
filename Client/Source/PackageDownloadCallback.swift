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
 This protocol is used when downloading an update using `BarracksClient.downloadPackage(response:, callback:, destination:)`
 */
public protocol PackageDownloadCallback {
    /**
     This method is called during the download, to inform of the progress of the download.
     
     - parameter response:  The `UpdateCheckResponse` used to trigger the download.
     - parameter progress:  The download progress in percent.
     */
    func onProgress(_ response:UpdateCheckResponse, progress:UInt)
    
    /**
     This method is called when an error occurs during the download.
     
     - parameter response:  The `UpdateCheckResponse` used to trigger the download.
     - parameter error:     The error raised during the download.
     */
    func onError(_ response:UpdateCheckResponse, error: Error?)
    
    /**
     This method is used when an download is successfully completed.
     
     - parameter response:  The `UpdateCheckResponse` used to trigger the download.
     - parameter path:      The path of the downloaded file.
     */
    func onSuccess(_ response:UpdateCheckResponse, path:String)
}

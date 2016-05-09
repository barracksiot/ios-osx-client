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

import Alamofire

extension BarracksClient {
    
    /**
     This method is used to download an update package from the Barracks service.
     
     - parameter response:      The `UpdateCheckResponse` retrieved using `BarracksClient.checkUpdate(_:callback:)`
     - parameter callback:      The `PackageDownloadCallback` which will be called during the process
     - parameter destination:   The optional destination for the update package on the filesystem
     */
    public func downloadPackage(response:UpdateCheckResponse, callback:PackageDownloadCallback, destination:String? = nil) {
        var localPath: NSURL?
        Alamofire
            .download(
                .GET,
                response.packageInfo.url,
                destination:{
                    (temporaryURL, response) in
                    let manager = NSFileManager.defaultManager()
                    if destination != nil {
                        localPath = NSURL(fileURLWithPath:destination!)
                    } else {
                        let directoryURL = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        let pathComponent = response.suggestedFilename
                        localPath = directoryURL.URLByAppendingPathComponent(NSBundle.mainBundle().bundleIdentifier ?? "Barracks", isDirectory:true).URLByAppendingPathComponent(pathComponent!)
                    }
                    
                    if (manager.fileExistsAtPath(localPath!.path!)) {
                        do {
                            try manager.removeItemAtURL(localPath!)
                        } catch let error {
                            print(error)
                            //throw error
                        }
                    }
                    let parent = localPath?.URLByDeletingLastPathComponent
                    if (!manager.fileExistsAtPath(parent!.path!)) {
                        do {
                            try manager.createDirectoryAtURL(parent!, withIntermediateDirectories:true, attributes:nil)
                        } catch let error {
                            print(error)
                            //throw error
                        }
                    }
                    return localPath!
                }
            )
            .validate(statusCode: 200..<300)
            .progress {
                (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                callback.onProgress?(response, progress:UInt(100 * totalBytesRead / totalBytesExpectedToRead))
                return
            }
            .response {
                (request, httpResponse, data, error) in
                if (error != nil) {
                    callback.onError?(response, error:error)
                    return
                }
                print(httpResponse)
                print("Downloaded file to \(localPath!.path)")
                callback.onSuccess?(response, path:localPath!.path!)
        };
    }
}
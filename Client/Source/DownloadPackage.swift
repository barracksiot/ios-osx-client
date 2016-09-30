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
import IDZSwiftCommonCrypto

extension BarracksClient {
    
    /**
     This method is used to download an update package from the Barracks service.
     
     - parameter response:      The `UpdateCheckResponse` retrieved using `BarracksClient.checkUpdate(_:callback:)`
     - parameter callback:      The `PackageDownloadCallback` which will be called during the process
     - parameter destination:   The optional destination for the update package on the filesystem
     */
    public func downloadPackage(_ response:UpdateCheckResponse, callback:PackageDownloadCallback, destination:String? = nil) {
        var localPath: URL?
        
        networkSessionManager
            .download(
                response.packageInfo.url,
                method: .get,
                headers:["Authorization" : apiKey],
                to:{
                    (temporaryURL, response) in
                    let manager = FileManager.default
                    if destination != nil {
                        localPath = URL(fileURLWithPath:destination!)
                    } else {
                        let directoryURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let pathComponent = response.suggestedFilename
                        localPath = directoryURL.appendingPathComponent(Bundle.main.bundleIdentifier ?? "Barracks", isDirectory:true).appendingPathComponent(pathComponent!)
                    }
                    
                    if (manager.fileExists(atPath: localPath!.path)) {
                        do {
                            try manager.removeItem(at: localPath!)
                        } catch let error {
                            print(error)
                            //throw error
                        }
                    }
                    let parent = localPath?.deletingLastPathComponent
                    if (!manager.fileExists(atPath: parent!().path)) {
                        do {
                            try manager.createDirectory(at: parent!(), withIntermediateDirectories:true, attributes:nil)
                        } catch let error {
                            print(error)
                            //throw error
                        }
                    }
                    return (localPath!, DownloadRequest.DownloadOptions())
                }
            )
            .validate(statusCode: 200..<300)
            .downloadProgress{
                progress in
        
                //callback.onProgress?(response, progress:UInt(100 * progress.completedUnitCount / progress.totalUnitCount))
                
                callback.onProgress?(response, progress:UInt(100 * progress.fractionCompleted))
                return
            }
            .response {
                 downloadResponse in
                
                if (downloadResponse.error != nil) {
                    callback.onError?(response, error:downloadResponse.error as NSError?)
                    return
                }
                print(downloadResponse.response)
                print("Downloaded file to \(localPath!.path)")
                if(self.checkMD5(localPath!, hash:response.packageInfo.md5)) {
                    callback.onSuccess?(response, path:localPath!.path)
                } else {
                    let failureReason = "MD5 hash did not match."
                    let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey as NSObject: failureReason as AnyObject]
                    callback.onError?(response, error:NSError(domain: Barracks.Error.Domain, code: Barracks.Error.Code.hashVerificationFailed.rawValue, userInfo:userInfo))
                }
        };
    }
    
    fileprivate func checkMD5(_ path:URL, hash:String) -> Bool {
        let inputStream = InputStream(url:path)
        if let input = inputStream {
            input.open()
            let hashObject : Digest = Digest(algorithm:.md5)
            let buffer:[UInt8] = [UInt8](repeating: 0, count: 4096)
            while(input.hasBytesAvailable) {
                let size = input.read(UnsafeMutablePointer(mutating: buffer), maxLength:4096)
                hashObject.update(buffer: UnsafePointer(buffer), byteCount: size);
            }
            let MD5 = hexString(fromArray: hashObject.final(), uppercase: false)
            input.close()
            return MD5 == hash
        }
        return false
    }
}

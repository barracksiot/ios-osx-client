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
import CryptoSwift

extension BarracksClient {
    
    /**
     This method is used to download an update package from the Barracks service.
     
     - parameter response:      The `GetDevicePackagesResponse` retrieved using `BarracksClient.getDevicePackages(_:callback:)`
     - parameter callback:      The `DownloadPackageCallback` which will be called during the process
     - parameter destination:   The optional destination for the update package on the filesystem
     */
    public func downloadPackage(package:DownloadablePackage, callback:DownloadPackageCallback, destination:String? = nil) {
        var localPath: URL?
        
        networkSessionManager
            .download(
                package.url,
                method: .get,
                headers:["Authorization" : apiKey],
                to:{
                    (temporaryURL, response) in
                    let manager = FileManager.default
                    if destination != nil {
                        localPath = URL(fileURLWithPath:destination!)
                    } else {
                        let directoryURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let pathComponent = "\(UUID().uuidString)-\(package.filename)"
                        localPath = directoryURL.appendingPathComponent(Bundle.main.bundleIdentifier ?? "Barracks", isDirectory:true).appendingPathComponent(pathComponent)
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
                
                callback.onProgress(package, progress:UInt(100 * progress.fractionCompleted))
                return
            }
            .response {
                downloadResponse in
                
                if (downloadResponse.error != nil) {
                    callback.onError(package, error:downloadResponse.error)
                    return
                }
                
                print("Downloaded file to \(localPath!.path)")
                do {
                    let isHashCorrect = try self.checkMD5(localPath!, hash:package.md5)
                    if(isHashCorrect) {
                        callback.onSuccess(package, path:localPath!.path)
                    } else {
                        callback.onError(package, error:DownloadPackageError.hashVerificationFailed)
                    }
                } catch let error {
                    callback.onError(package, error: error)
                }
        };
    }
    
    fileprivate func checkMD5(_ path:URL, hash:String) throws -> Bool {
        let inputStream = InputStream(url:path)
        if let input = inputStream {
            input.open()
            var hashObject : MD5 = MD5()
            let buffer:[UInt8] = [UInt8](repeating: 0, count: 4096)
            while(input.hasBytesAvailable) {
                let size = input.read(UnsafeMutablePointer(mutating: buffer), maxLength:4096)
                if(size > 0){
                    try hashObject.update(withBytes: buffer[0...(size-1)]);
                }
            }
            let MD5hash = try hashObject.finish().map() { String(format:"%02x", $0) }.reduce("", +)
            input.close()
            return MD5hash == hash
        }
        return false
    }
}

public enum DownloadPackageError : Error {
    case hashVerificationFailed
}

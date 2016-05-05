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

@objc public class BarracksClient : NSObject {
    let apiKey:String
    let baseUrl:String
    
    public init(apiKey:String, baseUrl:String = "https://barracks.io/device/update/check") {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    public func checkUpdate(request:UpdateCheckRequest, callback:UpdateCheckCallback) {
        let parameters:[String:AnyObject] = [
            "unitId": request.unitId,
            "versionId": request.versionId,
            "properties": request.properties
        ]
        Alamofire.request(.POST, baseUrl, parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback.onError?(response.result.error)
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject],
                    let versionId:String = responseJSON["versionId"] as? String,
                    let package = responseJSON["packageInfo"] as? [String: AnyObject],
                    let url:String = package["url"] as? String,
                    let hash:String = package["md5"] as? String,
                    let size:NSNumber = package["size"] as? NSNumber
                    else {
                        callback.onUpdateUnavailable?()
                        return
                }
                
                let updateCheckResponse = UpdateCheckResponse(
                    versionId: versionId,
                    packageInfo:PackageInfo(
                        url: url,
                        md5: hash,
                        size: size.unsignedLongLongValue
                    ),
                    properties: responseJSON["properties"] as? [String:AnyObject?]
                )
                callback.onUpdateAvailable?(updateCheckResponse)
        }
    }
    
    public func downloadPackage(response:UpdateCheckResponse, callback:PackageDownloadCallback) {
        var localPath: NSURL?
        Alamofire
            .download(
                .GET,
                response.packageInfo.url,
                destination:{
                    (temporaryURL, response) in
                    let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                    let pathComponent = response.suggestedFilename
                    localPath = directoryURL.URLByAppendingPathComponent(NSBundle.mainBundle().bundleIdentifier ?? "Barracks", isDirectory:true).URLByAppendingPathComponent(pathComponent!)

                    do {
                        try NSFileManager.defaultManager().removeItemAtURL(localPath!)
                    } catch {}
                    print("Saving file to \(localPath)")
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
                print("Downloaded file to \(localPath!)")
                callback.onSuccess?(response, path:localPath!.absoluteString)
        };
    }
}
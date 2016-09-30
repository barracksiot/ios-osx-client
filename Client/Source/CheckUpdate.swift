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
     This method is used to check wether an update is available on the Barracks service.
     
     - parameter request:   The `UpdateCheckRequest` used to perform the check
     - parameter callback:  The `UpdateCheckCallback` called during the process
     */
    public func checkUpdate(_ request:UpdateCheckRequest, callback:UpdateCheckCallback) {
        
       
        let parameters: Parameters = [
            "unitId": request.unitId as AnyObject,
            "versionId": request.versionId as AnyObject,
            "customClientData": request.customClientData as AnyObject
        ]
        
    
        networkSessionManager.request(baseUrl, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers:["Authorization" : apiKey])
         .validate(statusCode: 200..<300)
         .responseJSON { response in
         guard response.result.isSuccess else {
            callback.onError?(request, error:response.result.error as NSError?)
            return
         }
         
         guard let responseJSON = response.result.value as? [String: AnyObject],
         let versionId:String = responseJSON["versionId"] as? String,
         let package = responseJSON["packageInfo"] as? [String: AnyObject],
         let url:String = package["url"] as? String,
         let hash:String = package["md5"] as? String,
         let size:NSNumber = package["size"] as? NSNumber
         else {
         callback.onUpdateUnavailable?(request)
         return
         }
         
         let updateCheckResponse = UpdateCheckResponse(
         versionId: versionId,
         packageInfo:PackageInfo(
         url: url,
         md5: hash,
         size: size.uint64Value
         ),
         customUpdateData: responseJSON["customUpdateData"] as? [String:AnyObject?]
         )
         callback.onUpdateAvailable?(request, update:updateCheckResponse)
         }
    }
}

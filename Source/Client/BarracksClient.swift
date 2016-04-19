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
import Alamofire

@objc public class BarracksClient : NSObject {
    let apiKey:String
    let baseUrl:String
    
    public init(apiKey:String, baseUrl:String = "https://barracks.io/device/update/check") {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }
    
    public func checkUpdate(callback:UpdateCheckCallback) {
        let parameters = [
            "unitId": "deadbeef",
            "versionId": "v0.1"
        ]
        Alamofire.request(.POST, baseUrl, parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback.onError(response.result.error)
                    return
                }
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    callback.onUpdateUnavailable()
                    return
                }
                debugPrint(responseJSON)
                callback.onUpdateAvailable(responseJSON)
        }
    }
}
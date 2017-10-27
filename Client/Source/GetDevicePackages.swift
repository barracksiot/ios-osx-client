//
//  GetDevicePackages.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation
import Alamofire

extension BarracksClient {

    /**
     This method is used to get device's packages status or update from the Barracks service.
     
     - parameter request:   The `GetDevicePackagesRequest` used to perform the request
     - parameter callback:  The `GetDevicePackagesCallback` called during the process
     */
    public func getDevicePackages(request:GetDevicePackagesRequest, callback:GetDevicePackagesCallback) {
        
        let packagesParam:[[String:String]] = request.packages.map { (package) -> [String:String] in
            var aPackage:[String:String] = [:]
            aPackage["version"] = package.version
            aPackage["reference"] = package.reference
            
            return aPackage
        }
        
        let parameters: Parameters = [
            "unitId": request.unitId as AnyObject,
            "customClientData": request.customClientData as AnyObject,
            "packages" : packagesParam as AnyObject
        ]
        
        networkSessionManager.request(baseUrl, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers:["Authorization" : apiKey])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    callback.onError(request, error:response.result.error as NSError?)
                    print("Error : \(response.result.error.debugDescription)")
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    callback.onResponse(request: request, response: GetDevicePackagesResponse(available: [], changed: [], unchanged: [], unavailable: []))
                    return
                }
                
                /// Available pacakges
                var available:[DownloadablePackage] = []
                if let availableJSON = responseJSON["available"] as? [[String: AnyObject]] {
                    for jsonPackage in availableJSON {
                    
                        guard let reference:String = jsonPackage["reference"] as? String,
                            let version:String = jsonPackage["version"] as? String,
                            let url:String = jsonPackage["url"] as? String,
                            let md5:String = jsonPackage["md5"] as? String,
                            let size:NSNumber = jsonPackage["size"] as? NSNumber,
                            let filename:String = jsonPackage["filename"] as? String else {
                                continue
                        }
                        
                        available.append(DownloadablePackage(reference: reference,
                                                          version: version,
                                                          url: url,
                                                          md5: md5,
                                                          size: size.uint64Value,
                                                          filename: filename))
                    }
                }
                
                /// Changed packages
                var changed:[DownloadablePackage] = []
                if let changedJSON = responseJSON["changed"] as? [[String: AnyObject]] {
                    for jsonPackage in changedJSON {
                        
                        guard let reference:String = jsonPackage["reference"] as? String,
                            let version:String = jsonPackage["version"] as? String,
                            let url:String = jsonPackage["url"] as? String,
                            let md5:String = jsonPackage["md5"] as? String,
                            let size:NSNumber = jsonPackage["size"] as? NSNumber,
                            let filename:String = jsonPackage["filename"] as? String else {
                                continue
                        }
                        
                        changed.append(DownloadablePackage(reference: reference,
                                                      version: version,
                                                      url: url,
                                                      md5: md5,
                                                      size: size.uint64Value,
                                                      filename: filename))
                    }
                }
                
                /// Unchanged packages
                var unchanged:[DevicePackage] = []
                if let unchangedJSON = responseJSON["unchanged"] as? [[String: AnyObject]] {
                    for jsonPackage in unchangedJSON {
                        
                        guard let reference:String = jsonPackage["reference"] as? String,
                            let version:String = jsonPackage["version"] as? String else {
                                continue
                        }
                        
                        unchanged.append(DevicePackage(reference: reference,
                                                          version: version))
                    }
                }
                
                /// Unavailable packages
                var unavailable:[String] = []
                if let unavailableJSON = responseJSON["unavailable"] as? [[String: AnyObject]] {
                    for jsonPackage in unavailableJSON {
                        
                        guard let reference:String = jsonPackage["reference"] as? String else {
                                continue
                        }
                        
                        unavailable.append(reference)
                    }
                }
                
                callback.onResponse(request: request, response: GetDevicePackagesResponse(available: available, changed: changed, unchanged: unchanged, unavailable: unavailable))
        }
        
    }
}

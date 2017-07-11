//
//  GetDevicePackagesCallback.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

public protocol GetDevicePackagesCallback : class {

    func onResponse(request:GetDevicePackagesRequest, response:GetDevicePackagesResponse)
    
    func onError(_ request:GetDevicePackagesRequest, error:Error?)

}

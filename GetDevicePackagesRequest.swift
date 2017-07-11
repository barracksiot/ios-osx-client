//
//  GetDevicePackagesRequest.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

public class GetDevicePackagesRequest {
    
    /// The unique identifier for the unit being used
    let unitId:String
    
    /// User defined customClientData which will be sent to the Barracks service
    let customClientData:[String: AnyObject]
    
    ///
    let packages:[InstalledPackage]
    
    init(unitId:String, packages:[InstalledPackage], customClientData:[String: AnyObject]) {
        self.unitId = unitId
        self.packages = packages
        self.customClientData = customClientData
    }
}

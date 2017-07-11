//
//  GetDevicePackageResponse.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

public class GetDevicePackagesResponse {

    let available:[AvailablePackage]
    let changed:[ChangedPackage]
    let unchanged:[UnchangedPackage]
    let unavailable:[UnavailablePackage]
    
    init(available:[AvailablePackage], changed:[ChangedPackage], unchanged:[UnchangedPackage], unavailable:[UnavailablePackage]) {
        self.available = available
        self.changed = changed
        self.unchanged = unchanged
        self.unavailable = unavailable
    }

}

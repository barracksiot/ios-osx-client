//
//  GetDevicePackageResponse.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

/**
 This class is a container for a response provided by the Barracks service.
 The instance of this class is retrieved in the `GetDevicePackagesCallback.onresponse(response:)` when the call to `BarracksClient.getDevicePackages(_:callback:)` is successful.
 */
public class GetDevicePackagesResponse {

    /// List of packages newly available for the device
    public let available:[AvailablePackage]
    
    /// List of packages already installed on the device that have a new version
    public let changed:[ChangedPackage]
    
    /// List of packages already installed on the device that still have the same version
    public let unchanged:[UnchangedPackage]
    
    /// List of packages already installed on the device that cannot be used by the device anymore
    public let unavailable:[UnavailablePackage]
    
    init(available:[AvailablePackage], changed:[ChangedPackage], unchanged:[UnchangedPackage], unavailable:[UnavailablePackage]) {
        self.available = available
        self.changed = changed
        self.unchanged = unchanged
        self.unavailable = unavailable
    }

}

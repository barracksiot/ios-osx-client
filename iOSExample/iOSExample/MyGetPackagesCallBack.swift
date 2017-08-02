//
//  MyGetPackagesCallBack.swift
//  iOSExample
//
//  Created by Paul Aigueperse on 17-08-02.
//  Copyright © 2017 CleverToday. All rights reserved.
//

import Foundation
import Barracks

class MyGetPackagesCallback: GetDevicePackagesCallback {
    
    weak var parent: ViewController! = nil
    
    func onError(_ request: GetDevicePackagesRequest, error: Error?) {
        
        print("Error : ", error ?? "")
    }
    
    func onResponse(request: GetDevicePackagesRequest, response: GetDevicePackagesResponse) {
        
        parent.downloadablePackages.removeAll()
        parent.devicePackages.removeAll()
        parent.unavailablePackage.removeAll()
        
        // get all Downloadable packages
        parent.downloadablePackages.append(contentsOf: response.availablePackages)
        parent.downloadablePackages.append(contentsOf: response.changedPackages)
        
        // get other packages
        parent.devicePackages.append(contentsOf: response.unchangedPackages)
        parent.unavailablePackage.append(contentsOf: response.unavailablePackages)
        
        parent.collectionView.reloadData()
    }
}

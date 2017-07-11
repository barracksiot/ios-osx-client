//
//  UnchangedPackages.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

public class UnchangedPackage: DevicePackage {
    
    ///
    let version:String
    
    init(reference:String, version:String) {
        self.version = version
        super.init(reference: reference)
    }
}

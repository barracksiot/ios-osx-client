//
//  InstalledPackage.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

class InstalledPackage {
    
    let reference:String
    let version:String
    
    init(reference:String, version:String) {
        self.reference = reference
        self.version = version
    }
}

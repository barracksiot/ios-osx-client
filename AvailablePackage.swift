//
//  AvailablePackageInfo.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

public class AvailablePackage: DevicePackage {
    
    ///
    public let version:String
    /// The url at which the file is available
    public let url: String
    /// The MD5 hash which will be used to verify the file integrity
    public let md5: String
    /// The expected size of the file
    public let size: UInt64
    ///
    public let fileName:String
    
    init(reference:String, version:String, url:String, md5:String, size:UInt64, fileName:String) {
        self.version = version
        self.url = url
        self.md5 = md5
        self.size = size
        self.fileName = fileName
        super.init(reference:reference)
    }
}

//
//  DownloadPackageCallback.swift
//  BarracksClient
//
//  Created by Paul Aigueperse on 17-07-11.
//
//

import Foundation

/**
 This protocol is used when downloading an update using `BarracksClient.downloadPackage(package:, callback:, destination:)`
 */
public protocol DownloadPackageCallback {
    /**
     This method is called during the download, to inform of the progress of the download.
     
     - parameter package:   The `AvailablePackage or ChangedPackage` to download.
     - parameter progress:  The download progress in percent.
     */
    func onProgress(_ package:AvailablePackage, progress:UInt)
    
    /**
     This method is called when an error occurs during the download.
     
     - parameter package:   The `AvailablePackage or ChangedPackage` to download.
     - parameter error:     The error raised during the download.
     */
    func onError(_ package:AvailablePackage, error: Error?)
    
    /**
     This method is used when an download is successfully completed.
     
     - parameter package:   The `AvailablePackage or ChangedPackage` to download.
     - parameter path:      The path of the downloaded file.
     */
    func onSuccess(_ package:AvailablePackage, path:String)
}

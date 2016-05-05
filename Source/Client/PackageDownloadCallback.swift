//
//  PackageDownloadCallback.swift
//  BarracksClient
//
//  Created by Simon Guerout on 04/05/2016.
//
//

import Foundation

@objc public protocol PackageDownloadCallback {
    optional func onProgress(response:UpdateCheckResponse, progress:UInt)
    optional func onError(response:UpdateCheckResponse, error: NSError?)
    optional func onSuccess(response:UpdateCheckResponse, path:String)
}
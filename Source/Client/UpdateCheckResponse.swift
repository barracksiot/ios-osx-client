//
//  UpdateCheckResponse.swift
//  BarracksClient
//
//  Created by Simon Guerout on 16-04-19.
//
//

import Foundation
public struct UpdateCheckResponse {
    var versionId:String
    var url: String
    var hash: String
    var size: UInt64
    var properties: [String: AnyObject?]?
    
}
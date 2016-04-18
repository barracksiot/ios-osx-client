//
//  UpdateCheckCallback.swift
//  BarracksClient
//
//  Created by Simon Guerout on 16-04-17.
//
//

import Foundation

public protocol UpdateCheckCallback{
    func onUpdateAvailable()
    func onUpdateUnavailable()
    func onError()
}
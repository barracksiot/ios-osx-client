//
//  MyDownloadPAckageCallback.swift
//  iOSExample
//
//  Created by Paul Aigueperse on 17-08-02.
//  Copyright © 2017 CleverToday. All rights reserved.
//

import Foundation
import Barracks

class MyDownloadPackageCallback: DownloadPackageCallback {
    
    weak var parent: DevicePackageCell! = nil
    
    func onError(_ package: DownloadablePackage, error: Error?) {
        parent?.downloadStatus.isHidden = false
        parent?.downloadStatus.text = "Error : \(error?.localizedDescription ?? "" )"
    }
    
    func onSuccess(_ package: DownloadablePackage, path: String) {
        parent?.statusImage.image = UIImage(named: "circle-check-mark.png")
        parent?.progressBar.isHidden = true
        parent?.downloadStatus.isHidden = false
        parent?.downloadStatus.text = path
    }
    
    func onProgress(_ package: DownloadablePackage, progress: UInt) {
        parent?.progressBar.setProgress(Float(progress) / 100, animated: true)
    }
}

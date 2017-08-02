//
//  DevicePackageCell.swift
//  iOSExample
//
//  Created by Paul Aigueperse on 17-08-02.
//  Copyright © 2017 CleverToday. All rights reserved.
//

import UIKit
import Barracks

class DevicePackageCell: UICollectionViewCell {
    @IBOutlet weak var packageRef: UILabel!
    @IBOutlet weak var packageVersion: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var downloadStatus: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    var downloadablePackage:DownloadablePackage?
    var callback:MyDownloadPackageCallback?
    
    private func mainInit(){
        self.mainView.layer.cornerRadius = 15
        self.mainView.layer.masksToBounds = true
    }
    
    func initContent(from package:DevicePackage) {
        mainInit()
        packageRef.text = package.reference
        packageVersion.text = package.version
        
        self.statusImage.isHidden = true
        
    }
    
    func initContent(from package:DownloadablePackage) {
        mainInit()
        self.downloadablePackage = package
        packageRef.text = package.reference
        packageVersion.text = package.version + " - " + getKbSize(size: package.size)
        
        self.callback = MyDownloadPackageCallback()
        self.callback!.parent = self
    }
    
    func initContent(from ref:String) {
        mainInit()
        packageRef.text = ref
    }
    
    private func getKbSize(size:UInt64) -> String {
        return "\(size / 1000)Kb"
    }
}

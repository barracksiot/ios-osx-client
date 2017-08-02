//
//  ViewController.swift
//  iOSExample
//
//  Created by Paul Aigueperse on 17-08-02.
//  Copyright © 2017 CleverToday. All rights reserved.
//

import UIKit
import Barracks

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var client: BarracksClient!
    var response: GetDevicePackagesResponse!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var unitIdTextField: UITextField!
    
    var downloadablePackages:[DownloadablePackage] = []
    var devicePackages:[DevicePackage] = []
    var unavailablePackage:[String] = []
    
    static let downloadPackageNotification:NSNotification.Name = NSNotification.Name(rawValue: "downloadPackageNotificationName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView UI settings
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        collectionView.collectionViewLayout = layout
        
        client = BarracksClient("",
                                baseUrl: "https://app.barracks.io/api/device/resolve",
                                ignoreSSL:true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Call Barracks to get device packags
    @IBAction func getPackagesButtonClicked(_ sender: UIButton) {
        
        if(unitIdTextField.text != nil && !unitIdTextField.text!.isEmpty ){
            
            self.downloadablePackages.removeAll()
            self.devicePackages.removeAll()
            self.unavailablePackage.removeAll()
            
            self.collectionView.reloadData()
            
            let request = GetDevicePackagesRequest(unitId: unitIdTextField.text!,
                                                   packages:[
                                                    DevicePackage(reference: "a.package", version: "2.9.0"),
                                                    DevicePackage(reference: "a.nice.pkg", version: "version_2")
                                                    ],
                                                   customClientData:[:])
            
            let callback = MyGetPackagesCallback()
            callback.parent = self
            
            client.getDevicePackages(request: request, callback: callback)
            
            self.unitIdTextField.resignFirstResponder()
        }
        
    }
    
    func downloadPackage(cell:DevicePackageCell) {
        cell.progressBar?.isHidden = false
        client.downloadPackage(package: cell.downloadablePackage!, callback: cell.callback!)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return downloadablePackages.count
        case 2:
            return devicePackages.count
        case 3:
            return unavailablePackage.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "packageCell", for: indexPath) as! DevicePackageCell
        
        switch indexPath.section {
        case 1:
            cell.initContent(from: downloadablePackages[indexPath.item])
        case 2:
            cell.initContent(from: devicePackages[indexPath.item])
        case 3:
            cell.initContent(from: unavailablePackage[indexPath.item])

        default:
            return UICollectionViewCell()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1) {
            self.downloadPackage(cell: collectionView.cellForItem(at: indexPath) as! DevicePackageCell)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth / 2) - 10, height: screenWidth / 2)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        return .lightContent
    }
    
    

}


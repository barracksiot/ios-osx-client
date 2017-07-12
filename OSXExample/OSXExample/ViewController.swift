/*
 *    Copyright 2016 Barracks Solutions Inc.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

import Cocoa
import Barracks

class ViewController: NSViewController {
    var client: BarracksClient!
    var response: GetDevicePackagesResponse!
    
    class MyGetPackagesCallback : GetDevicePackagesCallback {
        weak var parent: ViewController! = nil
        
        func onResponse(request: GetDevicePackagesRequest, response: GetDevicePackagesResponse) {
            debugPrint(response)
            parent.response = response
            printNotification(title: "Packages status available", subtitle: "Available: \(response.available.count), Changed: \(response.changed.count), Unchanged: \(response.unchanged.count), Unavailable: \(response.unavailable.count)")
            parent.btnDownload.isEnabled = true
            
            let availableStr = response.available.map({ (package) -> String in
                return " \(package.reference) (\(package.version))"
            })
            parent.availableTextField.stringValue = "Available : \(availableStr)"
            
            let changedStr = response.changed.map({ (package) -> String in
                return " \(package.reference) (\(package.version))"
            })
            parent.changedTextField.stringValue = "Changed : \(changedStr)"
            
            let unchangedStr = response.unchanged.map({ (package) -> String in
                return " \(package.reference) (\(package.version))"
            })
            parent.unchangedTextField.stringValue = "Unchanged : \(unchangedStr)"
            
            let unavailableStr = response.unavailable.map({ (package) -> String in
                return " \(package.reference) "
            })
            parent.unavailableTextField.stringValue = "Unavailable : \(unavailableStr)"
            
        }
        
        func onError(_ request: GetDevicePackagesRequest, error: Error?) {
            parent.btnDownload.isEnabled = false
            printNotification(title: "Error while checking for device packages status", subtitle: error?.localizedDescription ?? "Error")
        }
    }
    
    class MyDownloadCallback : DownloadPackageCallback {
        weak var parent: ViewController! = nil
        func onError(_ package: AvailablePackage, error: Error?) {
            printNotification(title: "Error while checking for updates", subtitle: (error?.localizedDescription)!)
        }
        func onProgress(_ package: AvailablePackage, progress: UInt) {
            
        }
        func onSuccess(_ package: AvailablePackage, path: String) {
            printNotification(title: "Package \(package.reference) version \(package.version) downloaded", subtitle: path, userInfo: ["path": path as AnyObject])
        }
    }
    
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var btnCheck: NSButton!
    @IBOutlet weak var btnDownload: NSButton!
    @IBOutlet weak var availableTextField: NSTextField!
    @IBOutlet weak var changedTextField: NSTextField!
    @IBOutlet weak var unchangedTextField: NSTextField!
    @IBOutlet weak var unavailableTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnCheck.target = self
        btnCheck.action = #selector(ViewController.checkUpdate(obj:))
        btnDownload.target = self
        btnDownload.action = #selector(ViewController.downloadUpdate(obj:))
        client = BarracksClient("747ae2efa7c0e68fa7dda312aaea2ddeb8bfcffb003c9205b509ae430760cabf", baseUrl: "https://app.barracks.io/api/device/resolve", ignoreSSL:true)
    }
    
    func checkUpdate(obj: AnyObject) {
        let request = GetDevicePackagesRequest(unitId: version.stringValue, packages:[], customClientData:[:])
        let callback = MyGetPackagesCallback()
        callback.parent = self
        client.getDevicePackages(request: request, callback: callback)
    }
    
    func downloadUpdate(obj: AnyObject) {
        btnDownload.isEnabled = false
        let callback = MyDownloadCallback()
        callback.parent = self
        
        for availablePackage in response.available {
            client.downloadPackage(package: availablePackage, callback: callback)
        }
        
        for changedPackage in response.changed {
            client.downloadPackage(package: changedPackage, callback: callback)
        }
    }
}

func printNotification(title:String, subtitle:String! = nil, userInfo:[String: AnyObject] = [String:AnyObject]()) {
    let center = NSUserNotificationCenter.default
    let notification = NSUserNotification.init()
    notification.title = title
    notification.subtitle = subtitle
    notification.userInfo = userInfo
    center.deliver(notification)
}



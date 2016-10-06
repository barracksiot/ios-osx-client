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
    var update:UpdateCheckResponse!
    
    class MyUpdateCallback : UpdateCheckCallback {
        weak var parent: ViewController! = nil
        func onUpdateAvailable(_ request:UpdateCheckRequest, update:UpdateCheckResponse) {
            debugPrint(update)
            parent.update = update
            printNotification(title: "Update available", subtitle: "Version \(update.versionId)")
            parent.btnDownload.isEnabled = true
        }
        func onUpdateUnavailable(_ request:UpdateCheckRequest){
            printNotification(title: "No update available", subtitle: "Please check later")
            parent.btnDownload.isEnabled = false
        }
        func onError(_ request:UpdateCheckRequest, error:Error?){
            parent.btnDownload.isEnabled = false

            printNotification(title: "Error while checking for updates", subtitle: error?.localizedDescription ?? "Error")
        }
        
        
    }
    
    class MyDownloadCallback : PackageDownloadCallback {
        weak var parent: ViewController! = nil
        func onError(_ response: UpdateCheckResponse, error: Error?) {
            printNotification(title: "Error while checking for updates", subtitle: (error?.localizedDescription)!)
        }
        func onProgress(_ response: UpdateCheckResponse, progress: UInt) {
            
        }
        func onSuccess(_ response: UpdateCheckResponse, path: String) {
            printNotification(title: "Update \(response.versionId) downloaded", subtitle: path, userInfo: ["path": path as AnyObject])
        }
    }
    
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var btnCheck: NSButton!
    @IBOutlet weak var btnDownload: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnCheck.target = self
        btnCheck.action = #selector(ViewController.checkUpdate(obj:))
        btnDownload.target = self
        btnDownload.action = #selector(ViewController.downloadUpdate(obj:))
        client = BarracksClient("deadbeef", baseUrl: "https://app.barracks.io/api/device/update/check", ignoreSSL:true)
    }
    
    func checkUpdate(obj: AnyObject) {
        let request = UpdateCheckRequest(unitId: "deadbeef", versionId: version.stringValue)
        let callback = MyUpdateCallback()
        callback.parent = self
        client.checkUpdate(request, callback:callback)
    }
    
    func downloadUpdate(obj: AnyObject) {
        btnDownload.isEnabled = false
        let callback = MyDownloadCallback()
        callback.parent = self
        client.downloadPackage(update, callback: callback)
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



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
    
    class MyCallback : UpdateCheckCallback {
        func onUpdateAvailable(_:UpdateCheckResponse) {
            print("Available")
        }
        func onUpdateUnavailable(){
            print("Unavailable")
        }
        func onError(_:NSError?){
            print("Error")
        }
    }
    
    @IBOutlet weak var version: NSTextField!
    @IBOutlet weak var btnCheck: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello world")
        // Do any additional setup after loading the view.
        btnCheck.target = self
        btnCheck.action = #selector(ViewController.checkUpdate(_:))
        client = BarracksClient(apiKey: "deadbeef", baseUrl: "http://integration-01.barracks.io/device/update/check")
    }

    func checkUpdate(obj: AnyObject) {
        print("Checkin update...")
        let request = UpdateCheckRequest(unitId: "deadbeef", versionId: "v0.1")
        client.checkUpdate(request, callback:MyCallback())
    }
}


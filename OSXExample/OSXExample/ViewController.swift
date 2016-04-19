//
//  ViewController.swift
//  OSXExample
//
//  Created by Simon Guerout on 16-04-17.
//  Copyright © 2016 Barracks. All rights reserved.
//

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


![Barracks logo](https://barracks.io/wp-content/uploads/2016/09/barracks_logo_green.png)
# Barracks ios-osx-client
This is the iOS and OSX Client Library for [Barracks](https://barracks.io/). </ br> </ br>

This SDK help you interact with **Barracks v2** Checkout our [API Doccumentation](https://barracks.io/support/application-management/) to learn how to do **application-management** with Barracks.
## Requirements
- iOS 8.0+
- Xcode 8.0+
- Swift 3.0+

## Installation
### CocoaPods
Add Barracks to your **Podfile**
```text
pod 'Barracks'
```
Then run the following : 
```bash
$ pod install
```

## Usage
### Create a Barracks Client instance:
```swift
var barracksClient = BarracksClient("YOUR API KEY")
```
You can change baseUrl and ignoreSSL parameters. Default value are <br />
**baseUrl** : "https://app.barracks.io/api/device/resolve",<br />
**ignoreSSL** : false<br />

Your user api key can be found on the Account page of the [Barracks application](https://app.barracks.io/).

### Check for new packages and package updates:
If you're not sure about how to **managed your package** from Barracks check [our doccumentation](https://barracks.io/support/application-management/)
Create your callback by implementing the **GetDevicePackagesCallback** protocol

```swift
class MyGetPackagesCallback : GetDevicePackagesCallback {

func onResponse(request: GetDevicePackagesRequest, response: GetDevicePackagesResponse) {

/// List of packages newly available for the device
response.available ...

/// List of packages already installed on the device that have a new version
response.changed ...

/// List of packages already installed on the device that cannot be used by the device anymore
response.unavailable ...

/// List of packages already installed on the device that still have the same version
response.unchanged ...
}

func onError(_ request: GetDevicePackagesRequest, error: Error?) {
// Handle any error here
}
}
```
Request device packages status to **Barracks** <br />
You need to send the device's **installed packages references and versions** using ```InstalledPackage``` object.
```swift
// Create your installed packages list
var installedPackages:[InstalledPackage] = []
installedPackages.append(
InstalledPackage(reference: "an.installed.package", version: "1.0.2")
)

// You can send some custom client data
let myCustomClientData:[String:AnyObject] = [
"city" : "Montreal"
]

// Create a GetDevicePackagesRequest
let request = GetDevicePackagesRequest(
unitId: "A_DEVICE_UNITID",
packages: installedPackages,
customClientData: myCustomClientData)

// Call Barracks
barracksClient.getDevicePackages(request: request, callback: MyGetPackagesCallback())

```

### Download a package

Once you have the response from getDevicePackages, you'll be able to download file for all packages that are available for the device (packages that are in the ```available```, and ```changed``` lists of the response).

First create a callback by implenting **DownloadPackageCallback** protocol

```swift
class MyDownloadCallback : DownloadPackageCallback {
func onError(_ package: AvailablePackage, error: Error?) {
// Handle any download error here
}
func onProgress(_ package: AvailablePackage, progress: UInt) {
// Here is the progress of your download
}
func onSuccess(_ package: AvailablePackage, path: String) {
// On success you got the download path of th package file
}
```
Then you can Download a package wrapped in **AvailablePackage** or **ChangedPackage** object
```swift
barracksClient.downloadPackage(package: anAvailablePackage, callback: MyDownloadCallback())
```
The **default** path for file is </br>
```<NSFileManager.SearchPathDirectory.doccument>/<Your app Bundle ID>/<A random UUID>-<the filename from Barracks>```
<br /> <br />
**Custom filePath**
```swift
// To dowload the file to a custom path simply use :
barracksClient.downloadPackage(
package: anAvailablePackage, 
callback: MyDownloadCallback(), 
destination: "/a/custom/file/path/for/myFile.zip")
```

## Docs & Community

* [Website and Documentation](https://barracks.io/)
* [Github Organization](https://github.com/barracksiot) for other official SDKs

## License

[Apache License, Version 2.0](LICENSE)

source 'https://github.com/CocoaPods/Specs.git'

workspace 'BarracksClient.xcworkspace'
use_frameworks!

def sharedPods
    pod 'Alamofire', '~> 4.5.0'
    pod 'CryptoSwift', '~> 0.7.0'
end

target 'Barracks_iOS' do
    project 'BarracksClient.xcodeproj'
    platform :ios, '9.0'
    sharedPods
    target 'Barracks_iOS_Tests' do
        sharedPods
	pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'Barracks_OSX' do
    project 'BarracksClient.xcodeproj'
    platform :osx, '10.11'
    sharedPods
    target 'Barracks_OSX_Tests' do
        sharedPods
	pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'OSXExample' do
    platform :osx, '10.11'
    project 'OSXExample/OSXExample.xcodeproj'
    pod 'Barracks', :path => './'
end

target 'iOSExample' do
    platform :ios, '9.0'
    project 'iOSExample/iOSExample.xcodeproj'
    pod 'Barracks', :path => './'
end

source 'https://github.com/CocoaPods/Specs.git'

workspace 'BarracksClient.xcworkspace'
use_frameworks!

def sharedPods
    pod 'Alamofire', '~> 3.3'
end

target 'Barracks iOS' do
    project 'BarracksClient.xcodeproj'
    platform :ios, '8.0'
    sharedPods
    target 'Barracks iOSTests' do
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'Barracks OSX' do
    project 'BarracksClient.xcodeproj'
    platform :osx, '10.9'
    sharedPods
    target 'Barracks OSX Tests' do
        inherit! :search_paths
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'OSXExample' do
    platform :osx, '10.9'
    project 'OSXExample/OSXExample.xcodeproj'
    pod 'Barracks', :path => './'
end
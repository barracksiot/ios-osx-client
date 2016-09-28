source 'https://github.com/CocoaPods/Specs.git'

workspace 'BarracksClient.xcworkspace'
use_frameworks!

def sharedPods
    pod 'Alamofire', '~> 4.0.0'
    pod 'IDZSwiftCommonCrypto'
end

target 'Barracks iOS' do
    project 'BarracksClient.xcodeproj'
    platform :ios, '9.3'
    sharedPods
    target 'Barracks iOS Tests' do
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'Barracks OSX' do
    project 'BarracksClient.xcodeproj'
    platform :osx, '10.12'
    sharedPods
    target 'Barracks OSX Tests' do
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'OSXExample' do
    platform :osx, '10.12'
    project 'OSXExample/OSXExample.xcodeproj'
    pod 'Barracks', :path => './'
end

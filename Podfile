source 'https://github.com/CocoaPods/Specs.git'

workspace 'BarracksClient.xcworkspace'
use_frameworks!

def sharedPods
    pod 'Alamofire', '~> 4.0.0'
    pod 'CryptoSwift', '~> 0.7.0'
end

target 'Barracks iOS' do
    project 'BarracksClient.xcodeproj'
    platform :ios, '9.0'
    sharedPods
    target 'Barracks iOS Tests' do
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'Barracks OSX' do
    project 'BarracksClient.xcodeproj'
    platform :osx, '10.11'
    sharedPods
    target 'Barracks OSX Tests' do
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end
end

target 'OSXExample' do
    platform :osx, '10.11'
    project 'OSXExample/OSXExample.xcodeproj'
    pod 'Barracks', :path => './'
end

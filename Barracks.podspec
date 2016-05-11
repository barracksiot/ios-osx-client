Pod::Spec.new do |s|
s.name = 'Barracks'
s.version = '0.0.1'
s.license = 'Apache 2'
s.summary = 'Barracks Client in swift'
s.homepage = 'https://barracks.io'
s.social_media_url = 'http://twitter.com/barracksiot'
s.authors = { 'Barracks Solutions' => 'contact@barracks.io' }
s.source = { :git => 'ssh://git@bitbucket.org/barracksiot/barracks-client-ios.git', :branch => 'common_crypto' }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.9'

s.source_files = 'Client/Source/*.swift'

s.dependency 'Alamofire', '~> 3.3'

s.preserve_paths = 'CommonCrypto/*'
s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'        => '$(SRCROOT)/Barracks/CommonCrypto/',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]' => '$(SRCROOT)/Barracks/CommonCrypto/',
    'SWIFT_INCLUDE_PATHS[sdk=macosx*]'          => '$(SRCROOT)/Barracks/CommonCrypto/'
}

end


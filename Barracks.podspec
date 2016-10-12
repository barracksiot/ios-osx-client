Pod::Spec.new do |s|
s.name = 'Barracks'
s.version = '1.1.0'
s.license = 'Apache 2'
s.summary = 'Barracks Client in swift'
s.homepage = 'https://barracks.io'
s.social_media_url = 'http://twitter.com/barracksiot'
s.authors = { 'Barracks Solutions' => 'contact@barracks.io' }
s.source = { :git => 'https://github.com/barracksiot/ios-osx-client.git', :tag => '1.1.0' }

s.ios.deployment_target = '9.0'
s.osx.deployment_target = '10.11'

s.source_files = 'Client/Source/*.swift'

s.requires_arc = true

s.dependency 'Alamofire', '~> 4.0.0'
s.dependency 'CryptoSwift', '~> 0.6.0'

end


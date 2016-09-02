Pod::Spec.new do |s|
s.name = 'Barracks'
s.version = '0.0.1'
s.license = 'Apache 2'
s.summary = 'Barracks Client in swift'
s.homepage = 'https://barracks.io'
s.social_media_url = 'http://twitter.com/barracksiot'
s.authors = { 'Barracks Solutions' => 'contact@barracks.io' }
s.source = { :git => 'ssh://git@bitbucket.org/barracksiot/barracks-client-ios.git', :branch => 'master' }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'

s.source_files = 'Client/Source/*.swift'

s.requires_arc = true

s.dependency 'Alamofire', '~> 3.3'
s.dependency 'IDZSwiftCommonCrypto', '~> 0.7.1'

end

Pod::Spec.new do |s|
s.name = 'Barracks'
s.version = '1.0.0'
s.license = 'Apache 2'
s.summary = 'Barracks Client in swift'
s.homepage = 'https://barracks.io'
s.social_media_url = 'http://twitter.com/barracksiot'
s.authors = { 'Barracks Solutions' => 'contact@barracks.io' }
s.source = { :git => 'ssh://git@bitbucket.org/barracksiot/barracks-client-ios.git', :branch => 'master' }

s.ios.deployment_target = '9.3'
s.osx.deployment_target = '10.11'

s.source_files = 'Client/Source/*.swift'

s.requires_arc = true

s.dependency 'Alamofire', '~> 4.0'
s.dependency 'IDZSwiftCommonCrypto'

end


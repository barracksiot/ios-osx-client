
Pod::Spec.new do |s|
s.name = 'Barracks'
s.version = '0.0.1'
s.license = 'Apache 2'
s.summary = 'Barracks Client in swift'
s.homepage = 'https://barracks.io'
s.social_media_url = 'http://twitter.com/barracksiot'
s.authors = { 'Barracks Solutions' => 'contact@barracks.io' }
s.source = { :git => 'ssh://git@bitbucket.org/barracksiot/barracks-client-ios.git', :tag => s.version }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.9'

s.source_files = 'Source/Client/*.swift'

s.dependency 'Alamofire', '~> 3.3'
end
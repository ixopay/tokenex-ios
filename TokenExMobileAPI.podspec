Pod::Spec.new do |s|
  s.name = 'TokenExMobileAPI'
  s.version = '1.0.0'
  s.summary = 'Tokenize data from iOS apps.'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://docs.tokenex.com/docs/tokenex-mobile-api'
  s.authors = { 'TokenEx' => 'support@tokenex.com' }
  s.source = { :git => 'https://github.com/ixopay/tokenex-ios.git', :tag => "#{s.version}" }
  s.frameworks = 'Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.swift_version = '5.0'
  s.ios.deployment_target = '15.0'
  s.source_files = 'TokenExMobileAPI/TokenExMobileAPI/**/*.swift'
end

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint geoq.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'geoq'
  s.version          = '1.0.0'
  s.summary          = 'Plugin GeoQ'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://geoq.es'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'GeoQ' => 'info@geoq.es' }
  s.source           = { :path => '.' }
  
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  s.preserve_paths = 'GeoQSDK.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework GeoQSDK' }
  s.vendored_frameworks = 'GeoQSDK.xcframework'
end

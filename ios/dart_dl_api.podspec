Pod::Spec.new do |s|
  s.name             = 'dart_dl_api'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  s.public_header_files = 'Classes/**/*.h'
  s.source_files        = [
    'Classes/**/*',
    # Since we can't embed source from ../third_party/, we have created files
    # in ios/third_party/... which simply use #include "../...". This is a hack!
    'third_party/dart-sdk/**/*.{c,h}',
  ]
  s.compiler_flags      = [
    '-GCC_WARN_INHIBIT_ALL_WARNINGS',
    '-w',
  ]

  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => [
      '$(PODS_TARGET_SRCROOT)/../third_party/dart-sdk/src/runtime',
    ],
    'DEFINES_MODULE' => 'YES',
    # Flutter.framework does not contain a i386 slice.
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end

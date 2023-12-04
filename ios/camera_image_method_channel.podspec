
Pod::Spec.new do |s|
  s.name             = 'camera_image_method_channel'
  s.version          = '0.0.1'
  s.summary          = 'The iOS implementation for the camera_image_method_channel Flutter plugin.'
  s.description      = <<-DESC
  A Flutter plugin that provides support for other Flutter `MethodChannel` plugins to process a `CameraImage` received from the `camera` package, to perform custom modifications to the pixel buffer.
                       DESC
  s.homepage         = 'https://www.jamiewalker.nz'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Jamie Walker' => 'walker.jamie235@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

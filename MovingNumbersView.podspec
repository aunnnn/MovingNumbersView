Pod::Spec.new do |s|

  s.platforms = { :ios => '13.0', :osx => '10.15' }

  s.name             = 'MovingNumbersView'
  s.version          = '0.1.0'
  s.summary          = 'A number label with moving digit effect'
  s.requires_arc     = true
 
  s.description      = <<-DESC
A number label with moving digit effect.
                       DESC
 
  s.homepage         = 'https://github.com/aunnnn/MovingNumbersView'
  s.license          = 'MIT'
  s.author           = { 'Wirawit Rueopas' => 'aun.wirawit@gmail.com' }
  s.source           = { :git => 'https://github.com/aunnnn/MovingNumbersView.git', :tag => s.version.to_s }
 
  s.source_files     = 'Sources/MovingNumbersView/*.swift'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '13.0'
 
end
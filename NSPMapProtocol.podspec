Pod::Spec.new do |s|
  s.name             = 'NSPMapProtocol'
  s.version          = '0.1.0'
  s.summary          = 'Map snapshots in your TVML application made simple'

  s.description      = <<-DESC
  The NSPMapProtocol library defines the nspmap:// URL protocol to be used in Cocoa applications. Calling an URL with this protocol returns a .png snapshot of the map of the specified region.
  The real strength of this protocol can be seen when using it in Apple's TVML apps where there is no simple out-of-the-box solution provided to include static map screenshots in the application.
                       DESC

  s.homepage         = 'https://github.com/Neosperience/NSPMapProtocol'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Janos Tolgyesi' => 'janos.tolgyesi@neosperience.com' }
  s.source           = { :git => 'https://github.com/Neosperience/NSPMapProtocol.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.2'

  s.source_files = 'NSPMapProtocol/**/*'

  s.frameworks = 'UIKit', 'MapKit'

end

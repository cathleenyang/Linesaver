# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LineSaver' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_modular_headers!
  # Pods for LineSaver
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'PhoneNumberKit', '~> 3.1'
  pod 'GooglePlaces'
  pod 'FontAwesome.swift'

  target 'LineSaverTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LineSaverUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

platform :ios, '27.0'
use_frameworks!

target 'BookStoreSwiftMVVM' do
  pod 'Kingfisher', '~> 8.0'

  target 'BookStoreSwiftMVVMTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '27.0'
    end
  end
end

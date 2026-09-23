Pod::Spec.new do |s|
  s.name             = 'BookStoreNetworking'
  s.version          = '1.0.0'
  s.summary          = 'Capa de networking encapsulada como XCFramework.'
  s.description      = <<-DESC
                       Cliente HTTP generico y agnostico del dominio.
                       Se distribuye como XCFramework binario (device + simulator).
                       DESC
  s.homepage         = 'https://github.com/wilvermunozm/book-store-swift-mvvm'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Wilver Munoz' => 'mawistoreinfo@gmail.com' }
  s.source           = { :git => 'https://github.com/wilvermunozm/book-store-swift-mvvm.git', :tag => s.version.to_s }

  s.ios.deployment_target = '27.0'
  s.swift_version    = '5.0'

  s.vendored_frameworks = 'BookStoreNetworking.xcframework'
end

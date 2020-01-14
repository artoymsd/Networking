Pod::Spec.new do |spec|

  spec.name         = "ALNetworking"
  spec.version      = "1.0.1"
  spec.summary      = "A short description of Networking."

  spec.description  = <<-DESC
  Lib with networking layer
  DESC

  spec.homepage     = "https://github.com/artoymsd/networking"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Artem Sidorenko" => "artoymsd@gmail.com" }

  spec.platform     = :ios, "10.0"
  spec.ios.deployment_target = "10.0"

  spec.swift_version = '5.0'

  spec.source        = { :git => "https://github.com/artoymsd/networking.git", :tag => "#{spec.version}" }

  spec.source_files  = "Networking/**/*.swift"
  spec.exclude_files = "Networking/**/*.plist"
end


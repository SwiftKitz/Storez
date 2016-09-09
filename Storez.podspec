Pod::Spec.new do |s|

  s.name         = "Storez"
  s.version      = "2.0.0"
  s.summary      = "Safe, statically-typed, store-agnostic key-value storage!"
  s.description  = <<-DESC
                   Provides an extremely flexible way to implement a statically
                   typed key-value store, backed by the persistence store of your
                   choice.
                   DESC

  s.homepage     = "http://kitz.io"
  s.license      = "MIT"
  s.source       = { :git => "https://github.com/SwiftKitz/Storez.git", :tag => "v2.0.0" }
  s.author             = { "Maz Jaleel" => "mazjaleel@gmail.com" }
  s.social_media_url   = "http://twitter.com/SwiftKitz"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.default_subspec = 'All'

  ### Subspecs

  s.subspec 'All' do |ca|
    ca.dependency 'Storez/UserDefaults'
    ca.dependency 'Storez/Cache'
  end

  s.subspec 'Core' do |cc|
    cc.source_files = 'Storez/Storez/Entity/*'
  end

  s.subspec 'UserDefaults' do |cu|
    cu.source_files   = 'Storez/Storez/Stores/UserDefaults/*'
    cu.dependency 'Storez/Core'
  end

  s.subspec 'Cache' do |cc|
    cc.source_files   = 'Storez/Storez/Stores/Cache/*'
    cc.dependency 'Storez/Core'
  end
end

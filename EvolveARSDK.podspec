Pod::Spec.new do |s|
  s.name         = "EvolveARSDK"
  s.version      = "1.0"
  s.summary      = "SDK for Live Campaigns only"
  s.homepage     = "http://evolvear.io"
  s.license      = "Evolve Innovative Solutions"
  s.author             = { "EIS" => "" }
  s.source       = { :git => "https://github.com/xician/EvolveSDK.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
end

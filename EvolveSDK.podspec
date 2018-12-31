Pod::Spec.new do |s|
  s.name         = "EvolveSDK"
  s.version      = "1.0"
  s.summary      = "SDK for Live Campaigns only"
  s.homepage     = "http://evolvear.io"
  s.license      = "Evolve Innovative Solutions"
  s.author             = { "EIS" => "" }
  s.source       = { :git => "https://github.com/xician/EvolveSDK.git", 
      :submodules => true , :branch => "master" }
  s.source_files  = 'Pod/Classes/*.{h,m}'
	s.ios.deployment_target = '12'


s.subspec 'subs' do |subs|
    subs.dependency 'PopupKit'
    subs.dependency 'UIView+Shimmer'
    subs.dependency 'iCarousel'
    subs.dependency 'LGSideMenuController'
    subs.dependency 'MBCircularProgressBar'
    subs.dependency 'PVOnboardKit'
    subs.dependency 'SDWebImage'
    subs.dependency 'NYT360Video'
    subs.dependency 'lottie-ios'
    subs.dependency 'NYAlertViewController'
    subs.dependency 'MBProgressHUD'
  end



end

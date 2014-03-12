#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "FSHeadsUpDisplay"
  s.version          = "0.1.0"
  s.summary          = "Presents a heads-up display on iOS."
  s.description      = <<-DESC
      Provides a simple heads-up display for iOS apps. Can be used
      to display messages on either iPhone or iPad.  Display automatically
      hides after a predetermined time if no additional messages are
      presented.
                       DESC
  s.homepage         = "https://github.com/FocalShift/FSHeadsUpDisplay"
  s.screenshots      = "https://raw.github.com/FocalShift/FSHeadsUpDisplay/develop/Screenshots/ipad-hud-landscape.png"
  s.license          = 'MIT'
  s.author           = { "Bennett Smith" => "bennett@focalshift.com" }
  s.source           = { :git => "https://github.com/FocalShift/FSHeadsUpDisplay.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/NAME'

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/ios/*.{h,m}'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end

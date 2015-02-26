#
# Be sure to run `pod lib lint MXSegmentedPager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MXSegmentedPager"
  s.version          = "0.1.0"
  s.summary          = "UIScrollView paging control using HMSegmentedControl."
  s.description      = <<-DESC
                       UIScrollView paging control using [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl).
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/MXSegmentedPager"
  s.screenshots     = "https://lh5.googleusercontent.com/IaLYGDkE2ODAPP-fuDUWy1n2t3O9akH3lJ6NLa_WlYnOfNbfxI8AZcE7RhlR3q5FKnqDOJERyp8=w1416-h658"
  s.license          = 'MIT'
  s.author           = { "Maxime Epain" => "maxime.epain@gmail.com" }
  s.source           = { :git => "https://github.com/maxep/MXSegmentedPager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MaximeEpain'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MXSegmentedPager' => ['Pod/Assets/*.png']
  }
  s.dependency 'HMSegmentedControl', '~> 1.4'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

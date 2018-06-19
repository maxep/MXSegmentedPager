#
# Be sure to run `pod lib lint SNPSegmentedPager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SNPSegmentedPager'
  s.version          = '0.1.0'
  s.summary          = 'Segmented pager view with Parallax header.'

  s.description      = <<-DESC
  MXSegmentedPager combines [MXPagerView](https://github.com/maxep/MXPagerView) with [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl) to control the page selection.
  The integration of [MXParallaxHeader](https://github.com/maxep/MXParallaxHeader) allows you to add an parallax header on top while keeping a reliable scrolling effect.
  DESC
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/snapp-cab/SNPSegmentedPager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jebelli.farhad@gmail.com' => 'jebelli.farhad@gmail.com' }
  s.source           = { :git => 'https://github.com/snapp-cab/SNPSegmentedPager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.2'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = ['SNPSegmentedPager/Classes/**/*.{swift}','SNPSegmentedPager/Classes/**/*.{m}','SNPSegmentedPager/Classes/**/*.{h}']
  s.public_header_files = ['SNPSegmentedPager/**/*.{h}']
  s.dependency 'MXPagerView', '0.2.1'
  s.dependency 'MXParallaxHeader', '0.6.1'
  
  # s.resource_bundles = {
  #   'SNPSegmentedPager' => ['SNPSegmentedPager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

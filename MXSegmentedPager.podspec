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
  s.version          = "1.2.1"
  s.summary          = "Segmented pager view with Parallax header."
  s.description      = <<-DESC
                       The standard MXSegmentedPager class is a simple paging control using [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl). The ParallaxHeader category is an extension that allow you to add a [VGParallaxHeader](https://github.com/stoprocent/VGParallaxHeader) to your segmented pager.
                       DESC

  s.homepage         = "https://github.com/maxep/MXSegmentedPager"
  s.license          = 'MIT'
  s.author           = { "Maxime Epain" => "maxime.epain@gmail.com" }
  s.source           = { :git => "https://github.com/maxep/MXSegmentedPager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MaximeEpain'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

s.source_files = 'MXSegmentedPager/*.{m,h}'
  s.dependency 'HMSegmentedControl', '~> 1.5.2'
  s.dependency 'VGParallaxHeader', '~> 0.0.6'
end

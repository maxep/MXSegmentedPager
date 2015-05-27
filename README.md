# MXSegmentedPager

[![CI Status](http://img.shields.io/travis/maxep/MXSegmentedPager.svg?style=flat)](https://travis-ci.org/maxep/MXSegmentedPager)
[![Version](https://img.shields.io/cocoapods/v/MXSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/MXSegmentedPager)
[![License](https://img.shields.io/cocoapods/l/MXSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/MXSegmentedPager)
[![Platform](https://img.shields.io/cocoapods/p/MXSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/MXSegmentedPager)
[![Dependency Status](https://www.versioneye.com/objective-c/mxsegmentedpager/1.0/badge.svg)](https://www.versioneye.com/objective-c/mxsegmentedpager)

The standard MXSegmentedPager class is a simple paging control using [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl). The ParallaxHeader category is an extension that allow you to add a [VGParallaxHeader](https://github.com/stoprocent/VGParallaxHeader) to your segmented pager.


|           Simple view         |           Parallax view         |
|-------------------------------|---------------------------------|
|![Demo](Example/SimpleView.gif)|![Demo](Example/ParallaxView.gif)|


## Usage

If you want to try it, simply run:
```
pod try MXSegmentedPager
```
Or clone the repo and run `pod install` from the Example directory first. 

+ See MXSimpleViewController for a standard implementation.
+ See MXParallaxViewController to implement a pager with a parallax header.

The MXSegmentedPagerController class creates a controller object that manages a segmented-pager. The MXExampleViewController provide an example of a MXSegmentedPagerController subclass.

## Installation

MXSegmentedPager is available through [CocoaPods](https://cocoapods.org/pods/MXSegmentedPager). To install
it, simply add the following line to your Podfile:

```
pod 'MXSegmentedPager'
````

## Documentation

Documentation is available through [CocoaDocs](http://cocoadocs.org/docsets/MXSegmentedPager/).
                                               
## Author

[Maxime Epain](http://maxep.github.io)

[![Twitter](https://img.shields.io/badge/twitter-%40MaximeEpain-blue.svg?style=flat)](https://twitter.com/MaximeEpain)
                                               
## License
                                               
MXSegmentedPager is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

# MXSegmentedPager

[![CI Status](http://img.shields.io/travis/maxep/MXSegmentedPager.svg?style=flat)](https://travis-ci.org/maxep/MXSegmentedPager)
[![Version](https://img.shields.io/cocoapods/v/MXSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/MXSegmentedPager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/MXSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/MXSegmentedPager)
[![Platform](https://img.shields.io/cocoapods/p/MXSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/MXSegmentedPager)
[![Dependency Status](https://www.versioneye.com/objective-c/mxsegmentedpager/1.0/badge.svg)](https://www.versioneye.com/objective-c/mxsegmentedpager)

MXSegmentedPager combines [MXPagerView](https://github.com/maxep/MXPagerView) with [MXSegmentedControl](https://github.com/maxep/MXSegmentedControl) to control the page selection. The integration of [MXParallaxHeader](https://github.com/maxep/MXParallaxHeader) allows you to add a parallax header on top while keeping a reliable scrolling effect.


|           Simple view         |           Parallax view         |
|-------------------------------|---------------------------------|
|![Demo](Examples/Simple.gif)|![Demo](Examples/Parallax.gif)|

## Highlight
+ [MXSegmentedControl](https://github.com/maxep/MXSegmentedControl) is a very customizable control.
+ [MXParallaxHeader](https://github.com/maxep/MXParallaxHeader) supports any kind of view with different modes.
+ [MXPagerView](https://github.com/maxep/MXPagerView) lazily loads pages and supports reusable page registration.
+ Reliable vertical scroll with any view hierarchy.
+ Can load view-controller from storyboard using custom segues.
+ Fully documented.

## Usage

### MXSegmentedPager calls data source methods to load pages.

<details open=1>
<summary>Swift</summary>

```swift
// Asks the data source to return the number of pages in the segmented pager.
func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
    return 10
}

// Asks the data source for a title realted to a particular page of the segmented pager.
func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
    return "Page \(index)"
}

// Asks the data source for a view to insert in a particular page of the pager.
func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
    let label = UILabel()
    label.text = "Page \(index)"
    label.textAlignment = .center
    return label;
}
```
</details>

<details>
<summary>Objective-C</summary>

```objective-c
#pragma mark <MXSegmentedPagerDataSource>

// Asks the data source to return the number of pages in the segmented pager.
- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 10;
}

// Asks the data source for a title realted to a particular page of the segmented pager.
- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"Page %li", (long) index];
}

// Asks the data source for a view to insert in a particular page of the pager.
- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"Page #%i", index];
    label.textAlignment = NSTextAlignmentCenter;;

    return label;
}
```
</details>

### Adding a parallax header to a MXSegmentedPager is straightforward, e.g:

<details open=1>
<summary>Swift</summary>

```swift
let headerView = UIImageView()
headerView.image = UIImage(named: "success-baby")
headerView.contentMode = .scaleAspectFit

let segmentedPager = MXSegmentedPager()
segmentedPager.parallaxHeader.view = headerView
segmentedPager.parallaxHeader.height = 150
segmentedPager.parallaxHeader.mode = .fill
segmentedPager.parallaxHeader.minimumHeight = 20
```
</details>

<details>
<summary>Objective-C</summary>

```objective-c
UIImageView *headerView = [UIImageView new];
headerView.image = [UIImage imageNamed:@"success-baby"];
headerView.contentMode = UIViewContentModeScaleAspectFill;
   
MXSegmentedPager *segmentedPager = [MXSegmentedPager new]; 
segmentedPager.parallaxHeader.view = headerView;
segmentedPager.parallaxHeader.height = 150;
segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
segmentedPager.parallaxHeader.minimumHeight = 20;
```
</details>



## Examples

If you want to try it, simply run:
```
pod try MXSegmentedPager
```
Or clone the repo and run `pod install` from the Example directory first. 

+ See MXSimpleViewController for a standard implementation.
+ See MXParallaxViewController to implement a pager with a parallax header.
+ See MXExampleViewController for a MXSegmentedPagerController subclass example.

This repo also provides a **Swift** example project, see [Examples/Swift](Examples/Swift).

## Installation

MXSegmentedPager is available through [CocoaPods](https://cocoapods.org/pods/MXSegmentedPager). To install
it, simply add the following line to your Podfile:

```
pod 'MXSegmentedPager'
```

## Documentation

Documentation is available through [CocoaDocs](http://cocoadocs.org/docsets/MXSegmentedPager/).
                                               
## Author

[Maxime Epain](http://maxep.github.io)

[![Twitter](https://img.shields.io/badge/twitter-%40MaximeEpain-blue.svg?style=flat)](https://twitter.com/MaximeEpain)
                                               
## License
                                               
MXSegmentedPager is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

# MXPagerView

[![CI Status](http://img.shields.io/travis/maxep/MXPagerView.svg?style=flat)](https://travis-ci.org/maxep/MXPagerView)
[![Version](https://img.shields.io/cocoapods/v/MXPagerView.svg?style=flat)](http://cocoapods.org/pods/MXPagerView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/MXPagerView.svg?style=flat)](http://cocoapods.org/pods/MXPagerView)
[![Platform](https://img.shields.io/cocoapods/p/MXPagerView.svg?style=flat)](http://cocoapods.org/pods/MXPagerView)

MXPagerView is a pager view with the ability to reuse pages like you would do with a table view and cells. Depending on the transition style, it will load the current page and neighbors and unload others pages.

MXPagerViewController allows you to load pages from storyboard using the MXPageSegue.

## Usage

If you want to try it, simply run:

```
pod try MXPagerView
```

Or clone the repo and run `pod install` from the Example directory first. 

+ As a UITableView, the MXPagerView calls data source methods to load pages. 

```objective-c
#pragma mark <MXPagerViewDataSource>

// Asks the data source to return the number of pages in the pager.
- (NSInteger)numberOfPagesInPagerView:(MXPagerView *)pagerView {
    return 10;
}

// Asks the data source for a view to insert in a particular page of the pager.
- (UIView *)pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"Page #%i", index];
    [label sizeToFit];

    return label;
}
```

+ In order to reuse pages, first register the reusable view, e.g:

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Register UITextView as page
    [self.pagerView registerClass:[UITextView class] forPageReuseIdentifier:@"TextPage"];
}
```

Then, dequeue a reusable page in the data source:

```objective-c
// Asks the data source for a view to insert in a particular page of the pager.
- (UIView *)pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    
    //Dequeue reusable page
    UITextView *page = [self.pagerView dequeueReusablePageWithIdentifier:@"TextPage"];
    page.text = @"This is a text";
    
    return page;
}
```

The MXPagerView comes with a UIView category which exposed the reuse identifier of the page as well as the ```prepareForReuse``` method, this is called just before the page is returned from the pager view method ```dequeueReusablePageWithIdentifier:```.

+ Using MXPagerViewController in storyboard is super easy:

![Demo](Example-swift/MXPagerView.png)

## Installation

MXPagerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MXPagerView"
```

## Documentation

Documentation is available through [CocoaDocs](http://cocoadocs.org/docsets/MXPagerView/).

## Author

[Maxime Epain](http://maxep.github.io)

[![Twitter](https://img.shields.io/badge/twitter-%40MaximeEpain-blue.svg?style=flat)](https://twitter.com/MaximeEpain)

## License

MXPagerView is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

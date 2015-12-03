// MXSegmentedPagerController.h
//
// Copyright (c) 2015 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <MXPagerView/MXPagerViewController.h>
#import "MXSegmentedPager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The MXSegmentedPager's data source object may adopt the MXSegmentedPagerControllerDataSource protocol in order to use the MXSegmentedPagerController with child UIViewController.
 */
@protocol MXSegmentedPagerControllerDataSource <MXSegmentedPagerDataSource>

/**
 Asks the data source for a view controller to insert in a particular page of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the view.
 @param index          An index number identifying a page in segmented-pager.
 
 @return An object inheriting from UIViewController that the segmented-pager can use for the specified page.
 */
- (__kindof UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index;

/**
 Asks the data source for a segue identifier to insert in a particular page of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the view.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The segue identifier that the segmented-pager can use for the specified page.
 */
- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager segueIdentifierForPageAtIndex:(NSInteger)index;

@end

/**
 The MXSegmentedPagerController class creates a controller object that manages a segmengted-pager view.
 */
@interface MXSegmentedPagerController : UIViewController <MXSegmentedPagerDelegate, MXSegmentedPagerControllerDataSource>

/**
 Returns the segmengted-pager view managed by the controller object.
 */
@property (nonatomic, strong, readonly) MXSegmentedPager *segmentedPager;

@end

NS_ASSUME_NONNULL_END

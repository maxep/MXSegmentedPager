// MXPagerViewController.h
//
// Copyright (c) 2017 Maxime Epain
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

#import "MXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The MXSegmentedPager's data source object may adopt the MXSegmentedPagerControllerDataSource protocol in order to use the MXSegmentedPagerController with child UIViewController.
 */
@protocol MXPagerViewControllerDataSource <MXPagerViewDataSource>

/**
 Asks the data source for a view controller to insert in a particular page of the pager-view.
 
 @param pagerView   A pager-view object requesting the view.
 @param index       An index number identifying a page in pager-view.
 
 @return An object inheriting from UIViewController that the pager-view can use for the specified page.
 */
- (__kindof UIViewController *)pagerView:(MXPagerView *)pagerView viewControllerForPageAtIndex:(NSInteger)index;

/**
 Asks the data source for a segue identifier to insert in a particular page of the pager-view.
 
 @param pagerView   A pager-view object requesting the view.
 @param index       An index number identifying a page in pager-view.
 
 @return The segue identifier that the pager-view can use for the specified page.
 */
- (NSString *)pagerView:(MXPagerView *)pagerView segueIdentifierForPageAtIndex:(NSInteger)index;

@end

/**
 The MXPagerViewController class creates a controller object that manages a pager view.
 */
@interface MXPagerViewController : UIViewController <MXPagerViewDelegate, MXPagerViewControllerDataSource>

/**
 Returns the pager view managed by the controller object.
 */
@property (nonatomic,strong,readonly) MXPagerView *pagerView;

@end

/**
 A UIViewController must adopt the MXPageSegueSource protocol in order to perfom MXPageSegue.
 */
@protocol MXPageSegueSource <NSObject>

@required

/**
 The destination page index.
 */
@property (nonatomic, readonly) NSInteger pageIndex;

/**
 Sets the requested page controller at the required index.
 
 @param pageViewController The page view controller.
 @param index              The page index.
 */
- (void)setPageViewController:(__kindof UIViewController *)pageViewController atIndex:(NSInteger)index;

@end

extern NSString * const MXSeguePageIdentifierFormat; // @"mx_page_%ld"

/**
 The MXPageSegue class creates a segue object to get pages from storyboard.
 */
@interface MXPageSegue : UIStoryboardSegue

/**
 The source view controller that adopt the MXPageSegueDelegate protocol.
 */
@property (nonatomic,readonly) __kindof UIViewController<MXPageSegueSource> *sourceViewController;

/**
 Returns index representing page attached to segue.
 */
@property (nonatomic,readonly) NSInteger pageIndex;

@end

NS_ASSUME_NONNULL_END

// MXSegmentedPager.h
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
#import "HMSegmentedControl.h"

/**
 The segmented control position options relative to the segmented-pager.
 */
typedef NS_ENUM(NSInteger, MXSegmentedControlPosition) {
    /** Top position. */
    MXSegmentedControlPositionTop,
    /** Bottom position. */
    MXSegmentedControlPositionBottom
};

@class MXSegmentedPager;

/**
 The delegate of a MXSegmentedPager object may adopt the MXSegmentedPagerDelegate protocol. Optional methods of the protocol allow the delegate to manage selections.
 */
@protocol MXSegmentedPagerDelegate <NSObject>

@optional
/**
 Tells the delegate that a specified view is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param view           The selected page view.
 */
- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectView:(UIView*)view;

/**
 Tells the delegate that a specified title is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param title          The selected page title.
 */
- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithTitle:(NSString*)title;

/**
 Tells the delegate that a specified index is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param index          The selected page index.
 */
- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithIndex:(NSInteger)index;

/**
 Asks the delegate to return the height of the segmented control in the segmented-pager.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 
 @return A nonnegative floating-point value that specifies the height (in points) that segmented-control should be.
 */
- (CGFloat) heightForSegmentedControlInSegmentedPager:(MXSegmentedPager*)segmentedPager;

@end

/**
 MXSegmentedPager data source protocol.
 The MXSegmentedPager protocol is adopted by an object that mediates the application’s data model for a MXSegmentedPager object. The data source provides the segmented-pager object with the information it needs to construct and modify a MXSegmentedPager view.
 
 The required methods of the protocol provide the pages to be displayed by the segmented-pager as well as inform the MXSegmentedPager object about the number of pages. The data source may implement optional methods to configure the segmented control.
 */
@protocol MXSegmentedPagerDataSource <NSObject>

@required
/**
 Asks the data source to return the number of pages in the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting this information.
 
 @return The number of pages in segmented-pager.
 */
- (NSInteger) numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager;

/**
 Asks the data source for a view to insert in a particular page of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the view.
 @param index          An index number identifying a page in segmented-pager.
 
 @return An object inheriting from UIView that the segmented-pager can use for the specified page.
 */
- (UIView*) segmentedPager:(MXSegmentedPager*)segmentedPager viewForPageAtIndex:(NSInteger)index;

@optional

/**
 Asks the data source for a title to assign to a particular page of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The title of the page in segmented-pager.
 */
- (NSString*) segmentedPager:(MXSegmentedPager*)segmentedPager titleForSectionAtIndex:(NSInteger)index;

/**
 Asks the data source for a image to assign to a particular page of the segmented-pager. The title will be override by the image.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The image of the page in segmented-pager.
 */
- (UIImage*) segmentedPager:(MXSegmentedPager*)segmentedPager imageForSectionAtIndex:(NSInteger)index;

@end

/**
 You use the MXSegmentedPager class to create and manage segmented pages. A segmented pager displays a horizontal segmented control on top of pages, each segment corresponds to a page in the MXSegmentedPager view.The currently viewed page is indicated by the segmented control.
 */
@interface MXSegmentedPager : UIView

/**
 Delegate instance that adopt the MXSegmentedPagerDelegate.
 */
@property (nonatomic, assign) id<MXSegmentedPagerDelegate> delegate;

/**
 Data source instance that adopt the MXSegmentedPagerDataSource.
 */
@property (nonatomic, assign) id<MXSegmentedPagerDataSource> dataSource;

/**
 The segmented control. cf. [HMSegmentedControl](http://cocoadocs.org/docsets/HMSegmentedControl/1.5/) for customazation.
 */
@property (nonatomic, strong) HMSegmentedControl* segmentedControl;

/**
 The segmented control position option.
 */
@property (nonatomic, assign) MXSegmentedControlPosition segmentedControlPosition;

/**
 The pages container. The container will be placed below the segmented control.
 */
@property (nonatomic, strong) UIScrollView* container;

/**
 The pages container size. Use this property to set up your pages frame.
 */
@property (nonatomic, readonly) CGSize containerSize;

/**
 The current selected page view.
 */
@property (nonatomic, readonly) UIView* selectedPage;

/**
 Reloads everything from scratch. redisplays pages in container.
 */
- (void) reloadData;

@end

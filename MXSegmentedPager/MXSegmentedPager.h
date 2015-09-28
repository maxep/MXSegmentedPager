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
#import "UIScrollView+VGParallaxHeader.h"
#import "MXPagerView.h"

/**
 The segmented control position options relative to the segmented-pager.
 */
typedef NS_ENUM(NSInteger, MXSegmentedControlPosition) {
    /** Top position. */
    MXSegmentedControlPositionTop,
    /** Bottom position. */
    MXSegmentedControlPositionBottom
};

/**
 MXProgressBlock type definition.
 
 @param progress The scroll progress.
 */
typedef void (^MXProgressBlock) (CGFloat progress);

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
- (void) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager didSelectView:(nonnull UIView*)view;

/**
 Tells the delegate that a specified title is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param title          The selected page title.
 */
- (void) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager didSelectViewWithTitle:(nonnull NSString*)title;

/**
 Tells the delegate that a specified index is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param index          The selected page index.
 */
- (void) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager didSelectViewWithIndex:(NSInteger)index;

/**
 Asks the delegate to return the height of the segmented control in the segmented-pager.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 
 @return A nonnegative floating-point value that specifies the height (in points) that segmented-control should be.
 */
- (CGFloat) heightForSegmentedControlInSegmentedPager:(nonnull MXSegmentedPager*)segmentedPager;

@end

/**
 MXSegmentedPager data source protocol.
 The MXSegmentedPagerDataSource protocol is adopted by an object that mediates the application’s data model for a MXSegmentedPager object. The data source provides the segmented-pager object with the information it needs to construct and modify a MXSegmentedPager view.
 
 The required methods of the protocol provide the pages to be displayed by the segmented-pager as well as inform the MXSegmentedPager object about the number of pages. The data source may implement optional methods to configure the segmented control.
 */
@protocol MXSegmentedPagerDataSource <NSObject>

@required
/**
 Asks the data source to return the number of pages in the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting this information.
 
 @return The number of pages in segmented-pager.
 */
- (NSInteger) numberOfPagesInSegmentedPager:(nonnull MXSegmentedPager *)segmentedPager;

/**
 Asks the data source for a view to insert in a particular page of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the view.
 @param index          An index number identifying a page in segmented-pager.
 
 @return An object inheriting from UIView that the segmented-pager can use for the specified page.
 */
- (nonnull __kindof UIView*) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager viewForPageAtIndex:(NSInteger)index;

@optional

/**
 Asks the data source for a title to assign to a particular page of the segmented-pager. The title will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The NSString title of the page in segmented-pager.
 */
- (nonnull NSString*) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager titleForSectionAtIndex:(NSInteger)index;

/**
 Asks the data source for a title to assign to a particular page of the segmented-pager. The title will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The NSAttributedString title of the page in segmented-pager.
 */
- (nonnull NSAttributedString*) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager attributedTitleForSectionAtIndex:(NSInteger)index;

/**
 Asks the data source for a image to assign to a particular page of the segmented-pager. The image will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The image of the page in segmented-pager.
 */
- (nonnull UIImage*) segmentedPager:(nonnull MXSegmentedPager*)segmentedPager imageForSectionAtIndex:(NSInteger)index;

@end

/**
 You use the MXSegmentedPager class to create and manage segmented pages. A segmented pager displays a horizontal segmented control on top of pages, each segment corresponds to a page in the MXSegmentedPager view.The currently viewed page is indicated by the segmented control.
 */
@interface MXSegmentedPager : UIView

/**
 Delegate instance that adopt the MXSegmentedPagerDelegate.
 */
@property (nonatomic, weak) id<MXSegmentedPagerDelegate> delegate;

/**
 Data source instance that adopt the MXSegmentedPagerDataSource.
 */
@property (nonatomic, weak) id<MXSegmentedPagerDataSource> dataSource;

/**
 The segmented control. cf. [HMSegmentedControl](http://cocoadocs.org/docsets/HMSegmentedControl/1.5/) for customazation.
 */
@property (nonatomic, readonly, nonnull) HMSegmentedControl* segmentedControl;

/**
 The segmented control position option.
 */
@property (nonatomic) MXSegmentedControlPosition segmentedControlPosition;

/**
 The pager. The pager will be placed above or below the segmented control depending on the segmentedControlPosition property.
 */
@property (nonatomic, readonly, nonnull) MXPagerView* pager;

/**
 The padding from the top, left, right, and bottom of the segmentedControl
 */
@property (nonatomic) UIEdgeInsets segmentedControlEdgeInsets;

/**
 Reloads everything from scratch. redisplays pages.
 */
- (void) reloadData;

@end

/**
 MXSegmentedPager with parallax header. This category uses [VGParallaxHeader](http://cocoadocs.org/docsets/VGParallaxHeader/0.0.6/) to set up a parallax header on top of a segmented-pager.
 */
@interface MXSegmentedPager (ParallaxHeader)

/**
 The parallax header. cf. [VGParallaxHeader](http://cocoadocs.org/docsets/VGParallaxHeader/0.0.6/) for more details.
 */
@property (nonatomic, strong, readonly, nonnull) VGParallaxHeader *parallaxHeader;

/**
 The minimum header height, the header won't scroll below this value. By default, the minimum height is set to 0.
 */
@property (nonatomic) CGFloat minimumHeaderHeight;

/**
 The progress block called when scroll is progressing.
 */
@property (nonatomic, strong, nullable) MXProgressBlock progressBlock;

/**
 Sets the parallax header view.
 
 @param view   The parallax header view.
 @param mode   The parallax header mode. cf. [VGParallaxHeader](http://cocoadocs.org/docsets/VGParallaxHeader/0.0.6/) for more details.
 @param height The header height.
 */
- (void)setParallaxHeaderView:(nonnull __kindof UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height;
@end

/**
 While using MXSegmentedPager with Parallax header, your pages can adopt the MXPageDelegate protocol to control subview's scrolling effect.
 */
@protocol MXPageProtocol <NSObject>

@optional
/**
 Asks the page if the segmented-pager should scroll with the view.
 
 @param segmentedPager The segmented-pager. This is the object sending the message.
 @param view           An instance of a sub view.
 
 @return YES to allow segmented-pager and view to scroll together. The default implementation returns YES.
 */
- (BOOL) segmentedPager:(nonnull MXSegmentedPager *)segmentedPager shouldScrollWithView:(nonnull __kindof UIView*)view;

@end

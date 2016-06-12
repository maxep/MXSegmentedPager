// MXSegmentedPager.h
//
// Copyright (c) 2016 Maxime Epain
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
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <MXPagerView/MXPagerView.h>
#import <MXParallaxHeader/MXParallaxHeader.h>

NS_ASSUME_NONNULL_BEGIN

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
- (void)segmentedPager:(MXSegmentedPager*)segmentedPager didSelectView:(UIView*)view;

/**
 Tells the delegate that a specified title is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param title          The selected page title.
 */
- (void)segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithTitle:(NSString*)title;

/**
 Tells the delegate that a specified index is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param index          The selected page index.
 */
- (void)segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithIndex:(NSInteger)index;

/**
 Asks the delegate to return the height of the segmented control in the segmented-pager.
 If the delegate doesn’t implement this method, 44 is assumed.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 
 @return A nonnegative floating-point value that specifies the height (in points) that segmented-control should be.
 */
- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager*)segmentedPager;

/**
 Tells the delegate that the segmented pager has scrolled with the parallax header.
 
 @param segmentedPager A segmented-pager object in which the scrolling occurred.
 @param parallaxHeader The parallax-header that has scrolled.
 */
- (void)segmentedPager:(MXSegmentedPager*)segmentedPager didScrollWithParallaxHeader:(MXParallaxHeader *)parallaxHeader;

/**
 Tells the delegate when dragging ended with the parallax header.
 
 @param segmentedPager A segmented-pager object that finished scrolling the content view.
 @param parallaxHeader The parallax-header that has scrolled.
 */
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didEndDraggingWithParallaxHeader:(MXParallaxHeader *)parallaxHeader;

/**
 Asks the delegate if the segmented-pager should scroll to the top.
 If the delegate doesn’t implement this method, YES is assumed.
 
 @param segmentedPager The segmented-pager object requesting this information.
 
 @return YES to permit scrolling to the top of the content, NO to disallow it.
 */
- (BOOL)segmentedPagerShouldScrollToTop:(MXSegmentedPager *)segmentedPager;

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
- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager;

/**
 Asks the data source for a view to insert in a particular page of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the view.
 @param index          An index number identifying a page in segmented-pager.
 
 @return An object inheriting from UIView that the segmented-pager can use for the specified page.
 */
- (__kindof UIView*)segmentedPager:(MXSegmentedPager*)segmentedPager viewForPageAtIndex:(NSInteger)index;

@optional

/**
 Asks the data source for a title to assign to a particular page of the segmented-pager. The title will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The NSString title of the page in segmented-pager.
 */
- (NSString*)segmentedPager:(MXSegmentedPager*)segmentedPager titleForSectionAtIndex:(NSInteger)index;

/**
 Asks the data source for a title to assign to a particular page of the segmented-pager. The title will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The NSAttributedString title of the page in segmented-pager.
 */
- (NSAttributedString*)segmentedPager:(MXSegmentedPager*)segmentedPager attributedTitleForSectionAtIndex:(NSInteger)index;

/**
 Asks the data source for a image to assign to a particular page of the segmented-pager. The image will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The image of the page in segmented-pager.
 */
- (UIImage*)segmentedPager:(MXSegmentedPager*)segmentedPager imageForSectionAtIndex:(NSInteger)index;

/**
 Asks the data source for a selected image to assign to a particular page of the segmented-pager. The image will be used depending on the HMSegmentedControlType you have choosen.
 
 @param segmentedPager A segmented-pager object requesting the title.
 @param index          An index number identifying a page in segmented-pager.
 
 @return The selected image of the page in segmented-pager.
 */
- (UIImage*)segmentedPager:(MXSegmentedPager*)segmentedPager selectedImageForSectionAtIndex:(NSInteger)index;

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
@property (nonatomic, readonly) HMSegmentedControl* segmentedControl;

/**
 The segmented control position option.
 */
@property (nonatomic) MXSegmentedControlPosition segmentedControlPosition;

/**
 The pager. The pager will be placed above or below the segmented control depending on the segmentedControlPosition property.
 */
@property (nonatomic, readonly) MXPagerView* pager;

/**
 The padding from the top, left, right, and bottom of the segmentedControl
 */
@property (nonatomic) UIEdgeInsets segmentedControlEdgeInsets;

/**
 Reloads everything from scratch. redisplays pages.
 */
- (void)reloadData;

/**
 Scrolls the main contentView back to the top position
 */
- (void)scrollToTopAnimated:(BOOL)animated;

@end

/**
 MXSegmentedPager with parallax header. This category uses [MXParallaxHeader](http://cocoadocs.org/docsets/MXParallaxHeader) to set up a parallax header on top of a segmented-pager.
 */
@interface MXSegmentedPager (ParallaxHeader)

/**
 The parallax header. cf. [MXParallaxHeader](http://cocoadocs.org/docsets/MXParallaxHeader) for more details.
 */
@property (nonatomic, strong, readonly) MXParallaxHeader *parallaxHeader;

/**
 Allows bounces. Default YES.
 */
@property (nonatomic) BOOL bounces;

/**
 The progress block called when scroll is progressing.
 */
@property (nonatomic, strong, nullable) MXProgressBlock progressBlock DEPRECATED_MSG_ATTRIBUTE("Use the delegate method 'segmentedPager:didScrollWithParallaxHeader:' instead.");

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
- (BOOL)segmentedPager:(MXSegmentedPager *)segmentedPager shouldScrollWithView:(__kindof UIView*)view;

@end

NS_ASSUME_NONNULL_END

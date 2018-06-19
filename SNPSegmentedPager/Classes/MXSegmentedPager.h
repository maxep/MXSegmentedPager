// MXSegmentedPager.h
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

#import <UIKit/UIKit.h>

#import <MXPagerView/MXPagerView.h>
#import <MXParallaxHeader/MXParallaxHeader.h>

NS_ASSUME_NONNULL_BEGIN

@class ViewSegmentControll;
@class SegmentedView;
/**
 The segmented control position options relative to the segmented-pager.
 */
typedef NS_ENUM(NSInteger, MXSegmentedControlPosition) {
    /** Top position. */
    MXSegmentedControlPositionTop,
    /** Bottom position. */
    MXSegmentedControlPositionBottom,
    /** Top Over position. */
    MXSegmentedControlPositionTopOver

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
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectView:(UIView *)view;

/**
 Tells the delegate that a specified title is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param title          The selected page title.
 */
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title;

/**
 Tells the delegate that a specified index is about to be selected.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 @param index          The selected page index.
 */
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithIndex:(NSInteger)index;

/**
 Tells the delegate the segmented pager is about to draw a page for a particular index.
 A segmented page view sends this message to its delegate just before it uses page to draw a index, thereby permitting the delegate to customize the page object before it is displayed.
 
 @param segmentedPager The segmented-pager object informing the delegate of this impending event.
 @param page A page view object that segmented-pager is going to use when drawing the index.
 @param index An index locating the page in pagerView.
 */
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager willDisplayPage:(UIView *)page atIndex:(NSInteger)index;

/**
 Tells the delegate that the specified page was removed from the pager.
 Use this method to detect when a page is removed from a pager view, as opposed to monitoring the view itself to see when it appears or disappears.
 
 @param segmentedPager The segmented-pager object that removed the view.
 @param page The page that was removed.
 @param index The index of the page.
 */
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didEndDisplayingPage:(UIView *)page atIndex:(NSInteger)index;

/**
 Asks the delegate to return the height of the segmented control in the segmented-pager.
 If the delegate doesn’t implement this method, 44 is assumed.
 
 @param segmentedPager A segmented-pager object informing the delegate about the impending selection.
 
 @return A nonnegative floating-point value that specifies the height (in points) that segmented-control should be.
 */
- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager;

/**
 Tells the delegate that the segmented pager has scrolled with the parallax header.
 
 @param segmentedPager A segmented-pager object in which the scrolling occurred.
 @param parallaxHeader The parallax-header that has scrolled.
 */
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didScrollWithParallaxHeader:(MXParallaxHeader *)parallaxHeader;

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
- (__kindof UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index;

/**
 Asks the data source for views of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the views.

 @return The Array of views of the page in segmented-pager.
 */
@optional
- (NSArray<SegmentedView*>*)viewsForSegmentedPager:(MXSegmentedPager *)segmentedPager;

/**
 Asks the data source for colors of the indicator of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the views.
 
 @return The Array of colors of the indicator in segmented-pager.
 */
- (NSArray<UIColor*>*)indicatorColorForSegmentedPager:(MXSegmentedPager *)segmentedPager;

/**
 Asks the data source for heigth of the indicator of the segmented-pager.
 
 @param segmentedPager A segmented-pager object requesting the views.
 
 @return The heigth of the indicator in segmented-pager.
 */
- (CGFloat)indicatorHeigthForSegmentedPager:(MXSegmentedPager *)segmentedPager;


@end

/**
 You use the MXSegmentedPager class to create and manage segmented pages. A segmented pager displays a horizontal segmented control on top of pages, each segment corresponds to a page in the MXSegmentedPager view.The currently viewed page is indicated by the segmented control.
 */
@interface MXSegmentedPager : UIView

/**
 Delegate instance that adopt the MXSegmentedPagerDelegate.
 */
@property (nonatomic, weak) IBOutlet id<MXSegmentedPagerDelegate> delegate;

/**
 Data source instance that adopt the MXSegmentedPagerDataSource.
 */
@property (nonatomic, weak) IBOutlet id<MXSegmentedPagerDataSource> dataSource;

/**
 The segmented control. cf. [HMSegmentedControl](http://cocoadocs.org/docsets/HMSegmentedControl/1.5/) for customazation.
 */
@property (nonatomic, readonly)  ViewSegmentControll *segmentedControl;

/**
 The segmented control position option.
 */
@property (nonatomic) MXSegmentedControlPosition segmentedControlPosition;

/**
 The pager. The pager will be placed above or below the segmented control depending on the segmentedControlPosition property.
 */
@property (nonatomic, readonly) MXPagerView *pager;

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
- (BOOL)segmentedPager:(MXSegmentedPager *)segmentedPager shouldScrollWithView:(__kindof UIView *)view;

@end

NS_ASSUME_NONNULL_END

// MXPagerView.h
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

/**
 The pager transition styles.
 */
typedef NS_ENUM(NSInteger, MXPagerViewTransitionStyle) {
    /** The scroll transition style allows the user to slide between pages. */
    MXPagerViewTransitionStyleScroll,
    /** The tab transition style presents pages programmatically without animation. */
    MXPagerViewTransitionStyleTab
};

@class MXPagerView;

/**
 The delegate of a MXPagerView object may adopt the MXPagerViewDelegate protocol. Optional methods of the protocol allow the delegate to manage selections.
 */
@protocol MXPagerViewDelegate <UIScrollViewDelegate>

@optional
/**
  Tells the delegate that the pager is about to move to a specified page.
 
 @param pagerView A pager object informing the delegate about the impending move.
 @param index     The selected page index.
 */
- (void) pagerView:(MXPagerView *)pagerView willMoveToPageAtIndex:(NSInteger)index;

/**
 Tells the delegate that the pager did move to a specified page.
 
 @param pagerView A pager object informing the delegate about the impending move.
 @param index     The selected page index.
 */
- (void) pagerView:(MXPagerView *)pagerView didMoveToPageAtIndex:(NSInteger)index;

@end

/**
 MXPagerView data source protocol.
 The MXPagerViewDataSource protocol is adopted by an object that mediates the application’s data model for a MXPagerView object. The data source provides the pager object with the information it needs to construct and modify a MXPagerView view.
 
 The required methods of the protocol provide the pages to be displayed by the pager as well as inform the MXPagerView object about the number of pages.
 */
@protocol MXPagerViewDataSource <NSObject>

@required
/**
 Asks the data source to return the number of pages in the pager.
 
 @param segmentedPager A pager object requesting this information.
 
 @return The number of pages in pager.
 */
- (NSInteger) numberOfPagesInPagerView:(MXPagerView *)pagerView;

/**
 Asks the data source for a view to insert in a particular page of the pager.
 
 @param segmentedPager A pager object requesting the view.
 @param index          An index number identifying a page in segmented-pager.
 
 @return An object inheriting from UIView that the pager can use for the specified page.
 */
- (UIView*) pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index;

@end

/**
 A MXPagerView  lets the user navigate between pages of content. Navigation can be controlled programmatically by your app or directly by the user using gestures.
 */
@interface MXPagerView : UIScrollView

/**
 Delegate instance that adopt the MXPagerViewDelegate.
 */
@property (nonatomic,assign) id<MXPagerViewDelegate> delegate;

/**
 Data source instance that adopt the MXPagerViewDataSource.
 */
@property (nonatomic,assign) id<MXPagerViewDataSource> dataSource;

/**
 The current selected page view.
 */
@property (nonatomic, readonly) UIView *selectedPage;

/**
 The pager transition style.
 */
@property (nonatomic, assign) MXPagerViewTransitionStyle transitionStyle;

/**
 Reloads everything from scratch. redisplays pages.
 */
- (void) reloadData;

/**
 show through the pager until a page identified by index is at a particular location on the screen.
 
 @param index       An index that identifies a page.
 @param animated    YES if you want to animate the change in position; NO if it should be immediate. Animated parameter has no effect on pager with MXPagerViewBehaviorTab.
 */
- (void) showPageAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 Registers a nib object containing a page with the pager view under a specified identifier.
 
 Before dequeueing any pages, call this method or the ```registerClass:forPageReuseIdentifier:``` method to tell the pager view how to create new pages. If a page of the specified type is not currently in a reuse queue, the pager view uses the provided information to create a new page object automatically.
 
 If you previously registered a class or nib file with the same reuse identifier, the nib you specify in the nib parameter replaces the old entry. You may specify nil for nib if you want to unregister the nib from the specified reuse identifier.
 
 @param nib        A nib object that specifies the nib file to use to create the page.
 @param identifier The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
 */
- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier;

/**
 Registers a class for use in creating new page.
 
 Prior to dequeueing any pages, call this method or the ```registerNib:forPageReuseIdentifier:``` method to tell the pager view how to create new pages. If a page of the specified type is not currently in a reuse queue, the table view uses the provided information to create a new page object automatically.
 
 If you previously registered a class or nib file with the same reuse identifier, the class you specify in the pageClass parameter replaces the old entry. You may specify nil for pageClass if you want to unregister the class from the specified reuse identifier.
 
 @param pageClass  The class of a page that you want to use in the pager.
 @param identifier The reuse identifier for the page. This parameter must not be nil and must not be an empty string.
 */
- (void)registerClass:(Class)pageClass forPageReuseIdentifier:(NSString *)identifier;

/**
 Returns a reusable page object located by its identifier.
 
 A pager view maintains a queue or list of page objects that the data source has marked for reuse. Call this method from your data source object when asked to provide a new page for the table view. This method dequeues an existing page if one is available or creates a new one using the class or nib file you previously registered. If no page is available for reuse and you did not register a class or nib file, this method returns nil.
 
 @param identifier A string identifying the page object to be reused. This parameter must not be nil.
 
 @return A page object with the associated identifier or nil if no such object exists in the reusable-page queue.
 */
- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier;

@end

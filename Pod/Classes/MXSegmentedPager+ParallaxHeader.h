// MXSegmentedPager+ParallaxHeader.h
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

#import "MXSegmentedPager.h"
#import "UIScrollView+VGParallaxHeader.h"

/**
 MXProgressBlock type définition.
 
 @param progress The scroll progress.
 */
typedef void (^MXProgressBlock) (CGFloat progress);

/**
 MXSegmentedPager with parallax header. This category uses [VGParallaxHeader](http://cocoadocs.org/docsets/VGParallaxHeader/0.0.6/) to set up a parallax header on top of a segmented-pager.
 */
@interface MXSegmentedPager (ParallaxHeader)

/**
 The parallax header. @see [VGParallaxHeader](http://cocoadocs.org/docsets/VGParallaxHeader/0.0.6/) for more details.
 */
@property (nonatomic, strong, readonly) VGParallaxHeader *parallaxHeader;

/**
 The minimum header height, the header won't scroll below this value. By default, the minimum height is set to 0.
 */
@property (nonatomic, assign) CGFloat minimumHeaderHeight;

/**
 The progress block called when scroll is progressing.
 */
@property (nonatomic, strong) MXProgressBlock progressBlock;

/**
 Sets the parallax header view.
 
 @param view   The parallax header view.
 @param mode   The parallax header mode. @see [VGParallaxHeader](http://cocoadocs.org/docsets/VGParallaxHeader/0.0.6/) for more details.
 @param height The header height.
 */
- (void)setParallaxHeaderView:(UIView *)view
                         mode:(VGParallaxHeaderMode)mode
                       height:(CGFloat)height;

@end

/**
 While using MXSegmentedPager with Parallax header, your pages can adopt the MXPageDelegate protocol to have a nice effect while scrolling.
 This is useful when you have a page with a scrolling subview (e.g. UIWebView).
 */
@protocol MXPageProtocol <NSObject>

@required

/**
 Registers observer to receive KVO notifications for the specified key-path relative to the receiver. You can add the given observer to any scrolling view of your page.
 
 @param observer The object to register for KVO notifications.
 @param keyPath  The key path, relative to the receiver, of the property to observe.
 @param options  A combination of the NSKeyValueObservingOptions values that specifies what is included in observation notifications.
 @param context  Arbitrary data that is passed to observer.
 */
- (void)addScrollObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  options:(NSKeyValueObservingOptions)options
                  context:(void *)context;

/**
 Stops a given object from receiving change notifications for the property specified by a given key-path relative to the receiver and a context.
 
 @param observer The object to remove as an observer.
 @param keyPath  A key-path, relative to the receiver, for which observer is registered to receive KVO change notifications.
 @param context  Arbitrary data that more specifically identifies the observer to be removed.
 */
- (void)removeScrollObserver:(NSObject *)observer
                  forKeyPath:(NSString *)keyPath
                     context:(void *)context;

@end

/**
 UIScrollView category that adopt the MXPageProtocol protocol.
 */
@interface UIScrollView (MXSegmentedPager) <MXPageProtocol>
@end

/**
 UIWebView category that adopt the MXPageProtocol protocol.
 */
@interface UIWebView (MXSegmentedPager) <MXPageProtocol>
@end

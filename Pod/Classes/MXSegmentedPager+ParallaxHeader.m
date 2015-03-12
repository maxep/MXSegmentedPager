// MXSegmentedPager+ParallaxHeader.m
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

#import <objc/runtime.h>

#import "MXSegmentedPager+ParallaxHeader.h"

NSString * const MXKeyPathContentOffset = @"contentOffset";

@interface MXTopView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

- (void) setRelativeOffsetWithScrollView:(UIScrollView*)scrollView delta:(CGFloat)delta;

@end

@implementation MXTopView

- (void)setSegmentedControl:(HMSegmentedControl *)segmentedControl {
    _segmentedControl = segmentedControl;
    [self addSubview:segmentedControl];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.contentInset = UIEdgeInsetsZero;
        self.scrollIndicatorInsets = UIEdgeInsetsZero;
        self.alwaysBounceVertical = YES;
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This must be called in order to work
    [scrollView shouldPositionParallaxHeader];
    
    // scrollView.parallaxHeader.progress - is progress of current scroll
    NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
    
    // This is how you can implement appearing or disappearing of sticky view
    [scrollView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}

- (void) setRelativeOffsetWithScrollView:(UIScrollView*)scrollView delta:(CGFloat)delta {
    
    CGFloat y = self.contentOffset.y + delta;
    
    if (self.contentOffset.y + delta > 0) {
        y = 0;
    }
    else if (scrollView.contentOffset.y > 0) {
        y = self.contentOffset.y;
    }
    else if (scrollView.contentOffset.y - scrollView.contentInset.top < 0) {
        y = scrollView.contentOffset.y - scrollView.contentInset.top + self.contentInset.top;
    }
    
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
    
    self.frame = (CGRect ) {
        .origin = self.frame.origin,
        .size.width = self.frame.size.width,
        .size.height = self.segmentedControl.frame.size.height - y
    };
}

@end

@interface MXSegmentedPager ()
@property (nonatomic, strong) MXTopView * topView;
@end

@implementation MXSegmentedPager (ParallaxHeader)

- (void)setParallaxHeaderView:(UIView *)view mode:(VGParallaxHeaderMode)mode height:(CGFloat)height {
    
    self.topView = [[MXTopView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size.width = self.frame.size.width,
        .size.height = height + self.segmentedControl.frame.size.height
    }];
    
    self.topView.segmentedControl = self.segmentedControl;
    self.topView.contentSize = CGSizeMake(self.frame.size.width, height);
    [self.topView setParallaxHeaderView:view mode:mode height:height];
    [self addSubview:self.topView];
    [self bringSubviewToFront:self.topView];
    
    [self addObserver:self forKeyPath:MXKeyPathContainer options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark Properties

- (UIScrollView *)topView {
    return objc_getAssociatedObject(self, @selector(topView));
}

- (void)setTopView:(UIScrollView *)topView {
    objc_setAssociatedObject(self, @selector(topView), topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:MXKeyPathContainer] && object == self) {
        [self layoutScrollViews];
    }
    else if ([keyPath isEqualToString:MXKeyPathContentOffset] && [self.container.subviews containsObject:object]) {
        
        CGPoint newContentOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldContentOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat delta = newContentOffset.y - oldContentOffset.y;
        
        [self.topView setRelativeOffsetWithScrollView:object delta:delta];
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Private methods

- (void) layoutScrollViews {
    [self.container.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        UIScrollView *scrollView = (UIScrollView*)view;
        
        if (![view isKindOfClass:[UIScrollView class]]) {
            scrollView = [[UIScrollView alloc] initWithFrame:view.frame];
            view.frame = (CGRect){
                .origin   = CGPointZero,
                .size     = view.frame.size
            };
            scrollView.contentSize = view.frame.size;
            
            [scrollView addSubview:view];
            [self.container addSubview:scrollView];
        }
        
        scrollView.contentInset = (UIEdgeInsets){
            .top    = self.topView.parallaxHeader.frame.size.height,
            .left   = scrollView.contentInset.left,
            .bottom = scrollView.contentInset.bottom,
            .right  = scrollView.contentInset.right
        };
        
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -self.topView.frame.size.height);
        [scrollView addObserver:self forKeyPath:MXKeyPathContentOffset options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }];
    [self bringSubviewToFront:self.topView];
}

- (void)dealloc
{
    //Dirty hack..
    @try{
        [self.container.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeObserver:self forKeyPath:MXKeyPathContentOffset];
        }];
        [self removeObserver:self forKeyPath:MXKeyPathContainer];
    }@catch(id anException){
    }
}

@end

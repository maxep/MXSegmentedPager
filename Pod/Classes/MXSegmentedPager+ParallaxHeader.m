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

typedef NS_ENUM(NSInteger, MXPanGestureDirection) {
    MXPanGestureDirectionNone  = 1 << 0,
    MXPanGestureDirectionRight = 1 << 1,
    MXPanGestureDirectionLeft  = 1 << 2,
    MXPanGestureDirectionUp    = 1 << 3,
    MXPanGestureDirectionDown  = 1 << 4
};

@interface MXScrollView : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat minimumHeigth;
@property (nonatomic, strong) MXSegmentedPager *segmentedPager;
@property (nonatomic, strong) MXProgressBlock progressBlock;

@property (nonatomic, assign) BOOL moveView;
@end

@implementation MXScrollView

static void * const kMXScrollViewKVOContext = (void*)&kMXScrollViewKVOContext;
static NSString* const kContentOffsetKeyPath = @"contentOffset";

- (void)setSegmentedPager:(MXSegmentedPager*)segmentedPager {
    _segmentedPager = segmentedPager;
    [self addSubview:segmentedPager.segmentedControl];
    [self addSubview:segmentedPager.container];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        
        self.minimumHeigth = 0;
        
        [self addObserver:self forKeyPath:kContentOffsetKeyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:kMXScrollViewKVOContext];
        self.moveView = YES;
    }
    return self;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView shouldPositionParallaxHeader];
    
    if (self.progressBlock) {
        self.progressBlock(scrollView.parallaxHeader.progress);
    }
}

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        MXPanGestureDirection direction = [self getDirectionOfPanGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer];
        
        if (direction == MXPanGestureDirectionLeft || direction == MXPanGestureDirectionRight) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark Private methods

- (MXPanGestureDirection) getDirectionOfPanGestureRecognizer:(UIPanGestureRecognizer*) panGestureRecognizer {
    
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    CGFloat absX = fabs(velocity.x);
    CGFloat absY = fabs(velocity.y);
    
    if (absX > absY) {
        return (velocity.x > 0)? MXPanGestureDirectionRight : MXPanGestureDirectionLeft;
    }
    else if (absX < absY) {
        return (velocity.y > 0)? MXPanGestureDirectionDown : MXPanGestureDirectionUp;
    }
    return MXPanGestureDirectionNone;
}

- (void) didScrollWithDelta:(CGFloat)delta {
    
    self.moveView = NO;
    
    UIView<MXPageDelegate>* page = (id) self.segmentedPager.selectedPage;
    
    if (page) {
        
        BOOL isAtTop = ([page respondsToSelector:@selector(isAtTop)])? [page isAtTop] : YES;
        
        if (self.contentOffset.y > -self.minimumHeigth) {
            self.contentOffset = CGPointMake(self.contentOffset.x, -self.minimumHeigth);
        }
        else if (self.contentOffset.y + delta >= -self.minimumHeigth && !isAtTop) {
            self.contentOffset = CGPointMake(self.contentOffset.x, -self.minimumHeigth);
        }
        
        if (self.contentOffset.y < -self.minimumHeigth && [page respondsToSelector:@selector(scrollToTop)]) {
            [page scrollToTop];
        }
    }
    
    self.moveView = YES;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXScrollViewKVOContext && [keyPath isEqualToString:kContentOffsetKeyPath]) {
        
        if (self.moveView) {
            CGPoint newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
            CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delta = oldOffset.y - newOffset.y;
            
            [self didScrollWithDelta:delta];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

@interface MXSegmentedPager ()
@property (nonatomic, strong) MXScrollView * scrollView;
@property (nonatomic, assign) BOOL changeContainerFrame;
@end

@implementation MXSegmentedPager (ParallaxHeader)

static void * const kMXSegmentedPagerKVOContext = (void*)&kMXSegmentedPagerKVOContext;
static NSString* const kFrameKeyPath = @"frame";
static NSString* const kSegmentedControlPositionKeyPath = @"segmentedControlPosition";

- (void)setParallaxHeaderView:(UIView *)view mode:(VGParallaxHeaderMode)mode height:(CGFloat)height {
    
    self.scrollView = [[MXScrollView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = self.frame.size
    }];
    
    self.scrollView.segmentedPager = self;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + height);
    [self.scrollView setParallaxHeaderView:view mode:mode height:height];
    [self addSubview:self.scrollView];
    
    [self.container addObserver:self forKeyPath:kFrameKeyPath options:NSKeyValueObservingOptionNew context:kMXSegmentedPagerKVOContext];
    
    [self addObserver:self forKeyPath:kSegmentedControlPositionKeyPath options:NSKeyValueObservingOptionNew context:kMXSegmentedPagerKVOContext];
    
    if(self.segmentedControlPosition == MXSegmentedControlPositionBottom) {
        [self addSubview:self.segmentedControl];
    }
    
    self.changeContainerFrame = YES;
}

#pragma mark Properties

- (MXScrollView *)scrollView {
    return objc_getAssociatedObject(self, @selector(scrollView));
}

- (void)setScrollView:(MXScrollView *)scrollView {
    objc_setAssociatedObject(self, @selector(scrollView), scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VGParallaxHeader *)parallaxHeader {
    return self.scrollView.parallaxHeader;
}

- (CGFloat)minimumHeaderHeight {
    return self.scrollView.minimumHeigth;
}

- (void)setMinimumHeaderHeight:(CGFloat)minimumHeaderHeight {
    self.scrollView.minimumHeigth = minimumHeaderHeight;
}

- (MXProgressBlock)progressBlock {
    return self.scrollView.progressBlock;
}

- (void)setProgressBlock:(MXProgressBlock)progressBlock {
    self.scrollView.progressBlock = progressBlock;
}

- (BOOL)changeContainerFrame {
    NSNumber *number = objc_getAssociatedObject(self, @selector(changeContainerFrame));
    return [number boolValue];
}

- (void)setChangeContainerFrame:(BOOL)changeContainerFrame {
    NSNumber *number = [NSNumber numberWithBool:changeContainerFrame];
    objc_setAssociatedObject(self, @selector(changeContainerFrame), number , OBJC_ASSOCIATION_RETAIN);
}

#pragma mark KVO 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kMXSegmentedPagerKVOContext) {
        if ([keyPath isEqualToString:kFrameKeyPath]) {
        
            if (self.changeContainerFrame) {
                self.changeContainerFrame = NO;
                
                self.container.frame = (CGRect){
                    .origin         = self.container.frame.origin,
                    .size.width     = self.container.frame.size.width,
                    .size.height    = self.container.frame.size.height - self.scrollView.minimumHeigth
                };
                
                self.changeContainerFrame = YES;
            }
        }
        else if ([keyPath isEqualToString:kSegmentedControlPositionKeyPath]) {
            if(self.segmentedControlPosition == MXSegmentedControlPositionBottom) {
                [self addSubview:self.segmentedControl];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

@implementation UIScrollView (MXSegmentedPager)

#pragma mark <MXPageDelegate>

- (BOOL) isAtTop {
    return (self.contentOffset.y <= -self.contentInset.top);
}

- (void) scrollToTop {
    self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top);
}

@end

@implementation UIWebView (MXSegmentedPager)

#pragma mark <MXPageDelegate>

- (BOOL) isAtTop {
    return (self.scrollView.contentOffset.y <= self.scrollView.contentInset.top);
}

- (void) scrollToTop {
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.contentInset.top);
}

@end

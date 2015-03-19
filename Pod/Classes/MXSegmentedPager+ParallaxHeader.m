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
@end

@implementation MXScrollView

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
    }
    return self;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView shouldPositionParallaxHeader];
    
    if (self.progressBlock) {
        self.progressBlock(scrollView.parallaxHeader.progress);
    }

    if (self.contentOffset.y > -self.minimumHeigth) {
        self.contentOffset = CGPointMake(self.contentOffset.x, -self.minimumHeigth);
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
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

@end

@interface MXSegmentedPager ()
@property (nonatomic, strong) MXScrollView * scrollView;
@end

@implementation MXSegmentedPager (ParallaxHeader)

- (void)setParallaxHeaderView:(UIView *)view mode:(VGParallaxHeaderMode)mode height:(CGFloat)height {
    
    self.scrollView = [[MXScrollView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = self.frame.size
    }];
    
    self.scrollView.segmentedPager = self;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + height);
    [self.scrollView setParallaxHeaderView:view mode:mode height:height];
    [self addSubview:self.scrollView];
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

@end

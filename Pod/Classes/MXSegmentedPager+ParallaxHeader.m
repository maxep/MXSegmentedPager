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

@interface MXHeaderView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat minimumHeigth;
@property (nonatomic, strong) MXSegmentedPager *segmentedPager;
@property (nonatomic, strong) MXProgressBlock progressBlock;

- (void) setRelativeOffsetWithScrollView:(UIScrollView*)scrollView delta:(CGFloat)delta;

@end

@implementation MXHeaderView

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This must be called in order to work
    [scrollView shouldPositionParallaxHeader];
    
    if (self.progressBlock) {
        self.progressBlock(scrollView.parallaxHeader.progress);
    }

    if (self.contentOffset.y > -self.minimumHeigth) {
        self.contentOffset = CGPointMake(self.contentOffset.x, -self.minimumHeigth);
    }
}

- (void) setRelativeOffsetWithScrollView:(UIScrollView*)scrollView delta:(CGFloat)delta {
    
    CGFloat y = self.contentOffset.y + delta;

    if(scrollView.contentOffset.y > -self.minimumHeigth) {
        y = -self.minimumHeigth;
    }
    else if (scrollView.contentOffset.y - scrollView.contentInset.top < 0) {
        y = scrollView.contentOffset.y - scrollView.contentInset.top + self.contentInset.top;
    }
    
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@interface MXSegmentedPager ()
@property (nonatomic, strong) MXHeaderView * headerView;
@end

@implementation MXSegmentedPager (ParallaxHeader)

- (void)setParallaxHeaderView:(UIView *)view mode:(VGParallaxHeaderMode)mode height:(CGFloat)height {
    
    self.headerView = [[MXHeaderView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = self.frame.size
    }];
    
    self.headerView.segmentedPager = self;
    self.headerView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + height);
    [self.headerView setParallaxHeaderView:view mode:mode height:height];
    [self addSubview:self.headerView];
}

#pragma mark Properties

- (MXHeaderView *)headerView {
    return objc_getAssociatedObject(self, @selector(headerView));
}

- (void)setHeaderView:(MXHeaderView *)headerView {
    objc_setAssociatedObject(self, @selector(headerView), headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VGParallaxHeader *)parallaxHeader {
    return self.headerView.parallaxHeader;
}

- (CGFloat)minimunHeaderHeight {
    return self.headerView.minimumHeigth;
}

- (void)setMinimunHeaderHeight:(CGFloat)minimunHeaderHeight {
    self.headerView.minimumHeigth = minimunHeaderHeight;
}

- (MXProgressBlock)progressBlock {
    return self.headerView.progressBlock;
}

- (void)setProgressBlock:(MXProgressBlock)progressBlock {
    self.headerView.progressBlock = progressBlock;
}

@end

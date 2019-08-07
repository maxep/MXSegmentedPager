// MXSegmentedPager.m
//
// Copyright (c) 2019 Maxime Epain
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
#import <MXParallaxHeader/MXScrollView.h>
#import "MXSegmentedPager.h"

@interface MXSegmentedPager () <MXScrollViewDelegate, MXPagerViewDelegate, MXPagerViewDataSource>
@property (nonatomic, strong) MXScrollView          *contentView;
@property (nonatomic, strong) MXSegmentedControl    *segmentedControl;
@property (nonatomic, strong) MXPagerView           *pager;
@end

@implementation MXSegmentedPager {
    CGFloat     _controlHeight;
    NSInteger   _count;
}

- (void)reloadData {
    
    //Gets number of pages
    _count = [self.dataSource numberOfPagesInSegmentedPager:self];
    NSAssert(_count > 0, @"Number of pages in MXSegmentedPager must be greater than 0");
    
    //Gets the segmented control height
    _controlHeight = 44.f;
    if ([self.delegate respondsToSelector:@selector(heightForSegmentedControlInSegmentedPager:)]) {
        _controlHeight = [self.delegate heightForSegmentedControlInSegmentedPager:self];
    }
    
    for (NSInteger index = 0; index < _count; index++) {

        MXSegment *segment = [self.segmentedControl newSegment];

        if ([self.dataSource respondsToSelector:@selector(segmentedPager:attributedTitleForSectionAtIndex:)]) {
            NSAttributedString *title = [self.dataSource segmentedPager:self attributedTitleForSectionAtIndex:index];
            [segment setAttributedTitle:title forState:UIControlStateNormal];
        } else if ([self.dataSource respondsToSelector:@selector(segmentedPager:titleForSectionAtIndex:)]) {
            NSString *title = [self.dataSource segmentedPager:self titleForSectionAtIndex:index];
            [segment setTitle:title forState:UIControlStateNormal];
        } else {
            NSString *title = [NSString stringWithFormat:@"Page %ld", (long)index];
            [segment setTitle:title forState:UIControlStateNormal];
        }
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:imageForSectionAtIndex:)]) {
            UIImage *image = [self.dataSource segmentedPager:self imageForSectionAtIndex:index];
            [segment setImage:image forState:UIControlStateNormal];
        }
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:selectedImageForSectionAtIndex:)]) {
            UIImage *image = [self.dataSource segmentedPager:self selectedImageForSectionAtIndex:index];
            [segment setImage:image forState:UIControlStateSelected];
        }
    }

    [self.segmentedControl setNeedsDisplay];
    
    [self.pager reloadData];
}

- (void)scrollToTopAnimated:(BOOL)animated {
    [_contentView setContentOffset:CGPointMake(0, -self.contentView.parallaxHeader.height)
                          animated:animated];
}

- (void)showPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.pager showPageAtIndex:index animated:animated];
    [self.segmentedControl selectWithIndex:index animated:animated];
}

#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_count <= 0) {
        [self reloadData];
    }
    
    [self layoutContentView];
    [self layoutSegmentedControl];
    [self layoutPager];
}

- (void)layoutContentView {
    CGRect frame = self.bounds;
    
    frame.origin = CGPointZero;
    self.contentView.frame = frame;
    self.contentView.contentSize = self.contentView.frame.size;
    self.contentView.scrollEnabled = !!self.contentView.parallaxHeader.view;
    self.contentView.contentInset = UIEdgeInsetsMake(self.contentView.parallaxHeader.height, 0, 0, 0);
}

- (void)layoutSegmentedControl {
    CGRect frame = self.bounds;
    
    frame.origin.x = self.segmentedControlEdgeInsets.left;
    
    if (self.segmentedControlPosition == MXSegmentedControlPositionBottom) {
        frame.origin.y  = frame.size.height;
        frame.origin.y -= _controlHeight;
        frame.origin.y -= self.segmentedControlEdgeInsets.bottom;
        if (@available(iOS 11.0, *)) frame.origin.y -= self.safeAreaInsets.bottom;
    } else if(self.segmentedControlPosition == MXSegmentedControlPositionTopOver) {
        frame.origin.y = -_controlHeight;
    } else {
        frame.origin.y = self.segmentedControlEdgeInsets.top;
    }

    frame.size.width -= self.segmentedControlEdgeInsets.left;
    frame.size.width -= self.segmentedControlEdgeInsets.right;
    frame.size.height = _controlHeight;
    
    self.segmentedControl.frame = frame;
}

- (void)layoutPager {
    CGRect frame = self.bounds;
    
    frame.origin = CGPointZero;
    
    if (self.segmentedControlPosition == MXSegmentedControlPositionTop) {
        frame.origin.y  = _controlHeight;
        frame.origin.y += self.segmentedControlEdgeInsets.top;
        frame.origin.y += self.segmentedControlEdgeInsets.bottom;
    }
    
    if (self.segmentedControlPosition != MXSegmentedControlPositionTopOver) {
        frame.size.height -= _controlHeight;
        frame.size.height -= self.segmentedControlEdgeInsets.top;
        frame.size.height -= self.segmentedControlEdgeInsets.bottom;
        if (@available(iOS 11.0, *)) frame.size.height -= self.safeAreaInsets.bottom;
    }
    
    frame.size.height -= self.contentView.parallaxHeader.minimumHeight;
    
    self.pager.frame = frame;
}

#pragma mark Properties

- (MXScrollView *)contentView {
    if (!_contentView) {
        
        // Create scroll-view
        _contentView = [[MXScrollView alloc] init];
        _contentView.delegate = self;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (MXSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[MXSegmentedControl alloc] init];
        _segmentedControl.scrollView = self.pager;
        [self.contentView addSubview:_segmentedControl];
    }
    return _segmentedControl;
}

- (MXPagerView *)pager {
    if (!_pager) {
        _pager = [[MXPagerView alloc] initWithFrame:self.frame];
        _pager.delegate = self;
        _pager.dataSource = self;
        [self.contentView addSubview:_pager];
    }
    return _pager;
}

- (UIView *)selectedPage {
    return self.pager.selectedPage;
}

- (void)setSegmentedControlPosition:(MXSegmentedControlPosition)segmentedControlPosition {
    _segmentedControlPosition = segmentedControlPosition;
    [self setNeedsLayout];
}

- (void)setSegmentedControlEdgeInsets:(UIEdgeInsets)segmentedControlEdgeInsets {
    _segmentedControlEdgeInsets = segmentedControlEdgeInsets;
    [self setNeedsLayout];
}

#pragma mark <MXScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView && [self.delegate respondsToSelector:@selector(segmentedPager:didScrollWithParallaxHeader:)]) {
        [self.delegate segmentedPager:self didScrollWithParallaxHeader:scrollView.parallaxHeader];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.contentView && [self.delegate respondsToSelector:@selector(segmentedPager:didEndDraggingWithParallaxHeader:)]) {
        [self.delegate segmentedPager:self didEndDraggingWithParallaxHeader:scrollView.parallaxHeader];
    }
}

- (BOOL)scrollView:(MXScrollView *)scrollView shouldScrollWithSubView:(UIView *)subView {
    if (subView == self.pager) {
        return NO;
    }
    
    UIView<MXPageProtocol> *page = (id) self.pager.selectedPage;
    
    if ([page respondsToSelector:@selector(segmentedPager:shouldScrollWithView:)]) {
        return [page segmentedPager:self shouldScrollWithView:subView];
    }
    return YES;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(segmentedPagerShouldScrollToTop:)]) {
        return [self.delegate segmentedPagerShouldScrollToTop:self];
    }
    return YES;
}

#pragma mark <MXPagerViewDelegate>

- (void)pagerView:(MXPagerView *)pagerView willDisplayPage:(UIView *)page atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:willDisplayPage:atIndex:)]) {
        [self.delegate segmentedPager:self willDisplayPage:page atIndex:index];
    }
}

- (void)pagerView:(MXPagerView *)pagerView didEndDisplayingPage:(UIView *)page atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didEndDisplayingPage:atIndex:)]) {
        [self.delegate segmentedPager:self didEndDisplayingPage:page atIndex:index];
    }
}

#pragma mark <MXPagerViewDataSource>

- (NSInteger)numberOfPagesInPagerView:(MXPagerView *)pagerView {
    return _count;
}

- (UIView *)pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    return [self.dataSource segmentedPager:self viewForPageAtIndex:index];
}

#pragma mark Private methods

- (void)changedToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewAtIndex:)]) {
        [self.delegate segmentedPager:self didSelectViewAtIndex:index];
    }
    
    NSString *title = [self.segmentedControl segmentAt:index].titleLabel.text;
    UIView *view = self.pager.selectedPage;
                    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithTitle:)]) {
        [self.delegate segmentedPager:self didSelectViewWithTitle:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectView:)]) {
        [self.delegate segmentedPager:self didSelectView:view];
    }
}

@end

#pragma mark MXParallaxHeader

@implementation MXSegmentedPager (ParallaxHeader)

- (BOOL)bounces {
    return self.contentView.bounces;
}

- (void)setBounces:(BOOL)bounces {
    self.contentView.bounces = bounces;
}

- (MXParallaxHeader *)parallaxHeader {
    return self.contentView.parallaxHeader;
}

@end

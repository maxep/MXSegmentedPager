// MXSegmentedPager.m
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

@interface MXSegmentedPager () <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray   *boundaries;
@property (nonatomic, assign) BOOL      moveSegment;
@property (nonatomic, strong) NSArray   *pages;
@property (nonatomic, strong) NSArray   *keys;
@end

@implementation MXSegmentedPager

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self reloadData];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self reloadData];
}

- (void)reloadData {
    
    CGFloat height = 44.f;
    if ([self.delegate respondsToSelector:@selector(heightForSegmentedControlInSegmentedPager:)]) {
        height = [self.delegate heightForSegmentedControlInSegmentedPager:self];
    }
    [self layoutWithHeight:height];
    
    NSInteger numberOfPages = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInSegmentedPager:)]) {
        numberOfPages = [self.dataSource numberOfPagesInSegmentedPager:self];
    }
    
    NSMutableArray* images  = [NSMutableArray array];
    NSMutableArray* keys    = [NSMutableArray array];
    NSMutableArray* pages   = [NSMutableArray array];
    
    for (NSInteger index = 0; index < numberOfPages; index++) {
        
        NSString* key = [NSString stringWithFormat:@"Page %ld", (long)index];
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:titleForSectionAtIndex:)]) {
            key = [self.dataSource segmentedPager:self titleForSectionAtIndex:index];
        }
        [keys addObject:key];
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:viewForPageAtIndex:)]) {
            UIView* view = [self.dataSource segmentedPager:self viewForPageAtIndex:index];
            [pages addObject:view];
        }
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:imageForSectionAtIndex:)]) {
            UIImage* image = [self.dataSource segmentedPager:self imageForSectionAtIndex:index];
            [images addObject:image];
        }
    }
    
    self.pages = pages;
    self.keys = keys;
    if (images.count > 0) {
        self.segmentedControl.sectionImages = images;
    }
    else {
        self.segmentedControl.sectionTitles = keys;
    }
    
    [self layoutContainer];
}

#pragma mark Properties

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] init];
        [_segmentedControl addTarget:self
                              action:@selector(pageControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];
        
        self.moveSegment = YES;
    }
    return _segmentedControl;
}

- (UIScrollView *)container {
    if (!_container) {
        _container = [[UIScrollView alloc] init];
        _container.delegate = self;
        _container.scrollsToTop = NO;
        _container.pagingEnabled = YES;
        _container.directionalLockEnabled = YES;
        _container.alwaysBounceVertical = NO;
        _container.showsVerticalScrollIndicator = NO;
        _container.showsHorizontalScrollIndicator = NO;
        _container.keyboardDismissMode = YES;
        [self addSubview:_container];
    }
    return _container;
}

- (CGSize)containerSize {
    return self.container.frame.size;
}

#pragma mark HMSegmentedControl target

- (void)pageControlValueChanged:(HMSegmentedControl*)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    
    CGFloat x = self.frame.size.width * index;
    self.moveSegment = NO;
    [self.container setContentOffset:CGPointMake(x, 0) animated:YES];
    [self changedToIndex:index];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.moveSegment = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.moveSegment && scrollView == self.container && self.pages.count > 1) {
        NSInteger curIndex = self.segmentedControl.selectedSegmentIndex;
        NSInteger index = 0;
        for (NSInteger i = 0; i < self.boundaries.count - 2;) {
            CGFloat left        = [(NSNumber*)[self.boundaries objectAtIndex:i] floatValue];
            CGFloat right       = [(NSNumber*)[self.boundaries objectAtIndex:++i] floatValue];
            CGFloat position    = scrollView.contentOffset.x;
            
            if (position > left && position < right) {
                break;
            }
            if (position > 0 && position < scrollView.contentSize.width) {
                index++;
            }
        }
        if (curIndex != index) {
            [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
            [self changedToIndex:index];
        }
    }
}

#pragma mark Private methods

- (void) changedToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithIndex:)]) {
        [self.delegate segmentedPager:self didSelectViewWithIndex:index];
    }
    
    NSString* title = [self.keys objectAtIndex:index];
    UIView* view = [self.pages objectAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithTitle:)]) {
        [self.delegate segmentedPager:self didSelectViewWithTitle:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectView:)]) {
        [self.delegate segmentedPager:self didSelectView:view];
    }
}

- (void)layoutContainer {
    
    CGFloat width = 0.f;
    
    NSMutableArray* boundaries = [NSMutableArray arrayWithObject:@0];
    for (NSInteger index = 0; index < self.pages.count; index++) {
        
        UIView* view = [self.pages objectAtIndex:index];
        [self.container addSubview:view];
        
        CGRect frame = (CGRect) {
            .origin.x = width,
            .origin.y = view.frame.origin.y,
            .size = view.frame.size
        };
        view.frame = frame;
        width += self.frame.size.width;
        
        CGFloat boundary = frame.origin.x + (frame.size.width / 2);
        [boundaries addObject:[NSNumber numberWithFloat:boundary]];
    }
    self.container.contentSize = CGSizeMake(width, self.containerSize.height);
    self.boundaries = boundaries;
}

- (void) layoutWithHeight:(CGFloat)height {
    CGRect subFrame = (CGRect) {
        .origin = CGPointZero,
        .size.width = self.frame.size.width,
        .size.height = height
    };
    self.segmentedControl.frame = subFrame;
    
    subFrame = (CGRect) {
        .origin.x = 0.f,
        .origin.y = height,
        .size.width = self.frame.size.width,
        .size.height = self.frame.size.height - height
    };
    self.container.frame = subFrame;
}

@end

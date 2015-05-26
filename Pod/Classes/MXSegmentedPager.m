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

@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong) UIScrollView* container;

@property (nonatomic, strong) NSArray   *boundaries;
@property (nonatomic, strong) NSArray   *pages;
@property (nonatomic, strong) NSArray   *titles;
@end

@implementation MXSegmentedPager {
    BOOL _moveSegment;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
    [self layoutIfNeeded];
}

- (void)reloadData {
    
    //Removes current pages
    for(UIView *view in self.pages) {
        [view removeFromSuperview];
    }
    
    //Gets the segmented control height
    CGFloat height = 44.f;
    if ([self.delegate respondsToSelector:@selector(heightForSegmentedControlInSegmentedPager:)]) {
        height = [self.delegate heightForSegmentedControlInSegmentedPager:self];
    }
    [self layoutWithHeight:height];
    
    //Gets the number of page
    NSInteger numberOfPages = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInSegmentedPager:)]) {
        numberOfPages = [self.dataSource numberOfPagesInSegmentedPager:self];
    }
    
    //Gets new data
    NSMutableArray* images  = [NSMutableArray array];
    NSMutableArray* titles  = [NSMutableArray array];
    NSMutableArray* pages   = [NSMutableArray array];
    
    for (NSInteger index = 0; index < numberOfPages; index++) {
        
        NSString* title = [NSString stringWithFormat:@"Page %ld", (long)index];
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:titleForSectionAtIndex:)]) {
            title = [self.dataSource segmentedPager:self titleForSectionAtIndex:index];
        }
        [titles addObject:title];
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:viewForPageAtIndex:)]) {
            UIView* view = [self.dataSource segmentedPager:self viewForPageAtIndex:index];
            [pages addObject:view];
        }
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:imageForSectionAtIndex:)]) {
            UIImage* image = [self.dataSource segmentedPager:self imageForSectionAtIndex:index];
            [images addObject:image];
        }
    }
    
    //Saves new data
    self.pages = pages;
    self.titles = titles;
    if (images.count > 0) {
        self.segmentedControl.sectionImages = images;
    }
    else {
        self.segmentedControl.sectionTitles = titles;
    }
    
    [self layoutContainer];
}

- (void) scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.segmentedControl setSelectedSegmentIndex:index animated:animated];
    
    CGFloat x = self.frame.size.width * index;
    [self.container setContentOffset:CGPointMake(x, 0) animated:animated];
}

#pragma mark Properties

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] init];
        [_segmentedControl addTarget:self
                              action:@selector(pageControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];
        self.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
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
        _container.alwaysBounceHorizontal = NO;
        _container.showsVerticalScrollIndicator = NO;
        _container.showsHorizontalScrollIndicator = NO;
        _container.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self addSubview:_container];
    }
    return _container;
}

- (UIView*) selectedPage {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (self.pages.count > index) {
         return [self.pages objectAtIndex:index];
    }
    return nil;
}

- (void)setSegmentedControlPosition:(MXSegmentedControlPosition)segmentedControlPosition {
    [self willChangeValueForKey:@"segmentedControlPosition"];
    _segmentedControlPosition = segmentedControlPosition;
    [self layoutWithHeight:self.segmentedControl.frame.size.height];
    [self didChangeValueForKey:@"segmentedControlPosition"];
}

- (void)setSegmentedControlEdgeInsets:(UIEdgeInsets)segmentedControlEdgeInsets {
    _segmentedControlEdgeInsets = segmentedControlEdgeInsets;
    [self reloadData];
}

#pragma mark HMSegmentedControl target

- (void)pageControlValueChanged:(HMSegmentedControl*)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    
    _moveSegment = NO;
    CGFloat x = self.frame.size.width * index;
    [self.container setContentOffset:CGPointMake(x, 0) animated:YES];
    
    [self changedToIndex:index];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.container) {
        _moveSegment = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.container && self.pages.count > 1 && _moveSegment) {
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
    
    NSString* title = [self.titles objectAtIndex:index];
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
    
    for (UIView* view in self.pages) {
            
        [self.container addSubview:view];
        
        CGRect frame = (CGRect){
            .origin.x   = width,
            .origin.y   = 0.f,
            .size.width     = self.container.frame.size.width,
            .size.height    = self.container.frame.size.height - self.segmentedControlEdgeInsets.top - self.segmentedControlEdgeInsets.bottom
        };
        view.frame = frame;
        width += self.frame.size.width;
        
        CGFloat boundary = frame.origin.x + (frame.size.width / 2);
        [boundaries addObject:[NSNumber numberWithFloat:boundary]];
    }
     self.boundaries = boundaries;
    
    self.container.contentSize = CGSizeMake(width, self.container.frame.size.height);
    
    //Adjusts the container's content offset
    CGFloat x = self.frame.size.width * self.segmentedControl.selectedSegmentIndex;
    [self.container setContentOffset:CGPointMake(x, 0) animated:NO];
}

- (void) layoutWithHeight:(CGFloat)height {
    
    CGPoint position = (self.segmentedControlPosition == MXSegmentedControlPositionTop)?
    CGPointMake(self.segmentedControlEdgeInsets.left, self.segmentedControlEdgeInsets.top) : CGPointMake(self.segmentedControlEdgeInsets.left, self.frame.size.height - height - self.segmentedControlEdgeInsets.bottom);
    
    CGRect subFrame = (CGRect) {
        .origin         = position,
        .size.width     = self.frame.size.width - self.segmentedControlEdgeInsets.left - self.segmentedControlEdgeInsets.right,
        .size.height    = height
    };
    self.segmentedControl.frame = subFrame;
    
    position = (self.segmentedControlPosition == MXSegmentedControlPositionTop)? CGPointMake(0, height + self.segmentedControlEdgeInsets.top + self.segmentedControlEdgeInsets.bottom) : CGPointZero;
    
    subFrame = (CGRect) {
        .origin         = position,
        .size.width     = self.frame.size.width,
        .size.height    = self.frame.size.height - height
    };
    self.container.frame = subFrame;
}

@end

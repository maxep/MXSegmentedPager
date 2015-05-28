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

@interface MXSegmentedPager () <MXPagerViewDelegate, MXPagerViewDataSource>

@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong) MXPagerView* pager;
@property (nonatomic, assign) NSInteger count;
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
    
    //Gets the segmented control height
    CGFloat height = 44.f;
    if ([self.delegate respondsToSelector:@selector(heightForSegmentedControlInSegmentedPager:)]) {
        height = [self.delegate heightForSegmentedControlInSegmentedPager:self];
    }
    [self layoutWithHeight:height];
    
    self.count = [self.dataSource numberOfPagesInSegmentedPager:self];
    
    //Gets new data
    NSMutableArray* images  = [NSMutableArray array];
    NSMutableArray* titles  = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.count; index++) {
        
        NSString* title = [NSString stringWithFormat:@"Page %ld", (long)index];
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:titleForSectionAtIndex:)]) {
            title = [self.dataSource segmentedPager:self titleForSectionAtIndex:index];
        }
        [titles addObject:title];
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:imageForSectionAtIndex:)]) {
            UIImage* image = [self.dataSource segmentedPager:self imageForSectionAtIndex:index];
            [images addObject:image];
        }
    }
    
    if (images.count > 0) {
        self.segmentedControl.sectionImages = images;
    }
    else {
        self.segmentedControl.sectionTitles = titles;
    }
    
    [self.pager reloadData];
}

- (void) scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.segmentedControl setSelectedSegmentIndex:index animated:animated];
    [self.pager showPageAtIndex:index animated:animated];
}

#pragma mark Properties

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] init];
        [_segmentedControl addTarget:self
                              action:@selector(pageControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];
        _moveSegment = YES;
        
        self.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _segmentedControl;
}

- (MXPagerView *)pager {
    if (!_pager) {
        _pager = [[MXPagerView alloc] init];
        _pager.delegate = self;
        _pager.dataSource = self;
        [self addSubview:_pager];
    }
    return _pager;
}

- (UIView*) selectedPage {
    return self.pager.selectedPage;
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
    _moveSegment = NO;
    [self.pager showPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
}

#pragma mark <MXPagerViewDelegate>

- (void)pagerView:(MXPagerView *)pagerView willMoveToPageAtIndex:(NSInteger)index {
    if (_moveSegment) {
        [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    }
}

- (void)pagerView:(MXPagerView *)pagerView didMoveToPageAtIndex:(NSInteger)index {
    [self.segmentedControl setSelectedSegmentIndex:index animated:NO];
    [self changedToIndex:index];
    _moveSegment = YES;
}

#pragma mark <MXPagerViewDataSource>

- (NSInteger)numberOfPagesInPagerView:(MXPagerView *)pagerView {
    return self.count;
}

- (UIView*) pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    return [self.dataSource segmentedPager:self viewForPageAtIndex:index];
}

#pragma mark Private methods

- (void) changedToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithIndex:)]) {
        [self.delegate segmentedPager:self didSelectViewWithIndex:index];
    }
    
    NSString* title = self.segmentedControl.sectionTitles[index];
    UIView* view = self.pager.selectedPage;
                    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithTitle:)]) {
        [self.delegate segmentedPager:self didSelectViewWithTitle:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectView:)]) {
        [self.delegate segmentedPager:self didSelectView:view];
    }
}

- (void) layoutWithHeight:(CGFloat)height {
    
    CGPoint position;
    if (self.segmentedControlPosition == MXSegmentedControlPositionTop) {
        position = CGPointMake(self.segmentedControlEdgeInsets.left,
                               self.segmentedControlEdgeInsets.top);
    }
    else {
        position = CGPointMake(self.segmentedControlEdgeInsets.left,
                               self.frame.size.height - height - self.segmentedControlEdgeInsets.bottom);
    }
    
    CGRect subFrame = (CGRect) {
        .origin         = position,
        .size.width     = self.frame.size.width - self.segmentedControlEdgeInsets.left - self.segmentedControlEdgeInsets.right,
        .size.height    = height
    };
    self.segmentedControl.frame = subFrame;
    
    if (self.segmentedControlPosition == MXSegmentedControlPositionTop) {
        position = CGPointMake(0, height + self.segmentedControlEdgeInsets.top + self.segmentedControlEdgeInsets.bottom);
    }
    else {
        position = CGPointZero;
    }
    
    subFrame = (CGRect) {
        .origin         = position,
        .size.width     = self.frame.size.width,
        .size.height    = self.frame.size.height - height - self.segmentedControlEdgeInsets.top - self.segmentedControlEdgeInsets.bottom
    };
    self.pager.frame = subFrame;
}

@end

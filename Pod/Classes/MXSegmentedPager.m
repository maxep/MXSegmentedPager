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
@property (nonatomic, strong) NSArray* boundaries;
@property (nonatomic, readwrite) BOOL moveSegment;
@property (nonatomic, strong) NSDictionary* pages;
@end

@implementation MXSegmentedPager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

- (CGSize)containerSize {
    return self.container.frame.size;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect subFrame = (CGRect) {
        .origin = CGPointZero,
        .size.width = self.frame.size.width,
        .size.height = 44.f
    };
    self.segmentedControl.frame = subFrame;
    
    subFrame = (CGRect) {
        .origin.x = 0.f,
        .origin.y = subFrame.size.height,
        .size.width = self.frame.size.width,
        .size.height = self.frame.size.height - subFrame.size.height
    };
    self.container.frame = subFrame;
    
    [self reloadData];
}

- (void) setPages:(NSDictionary *)pages {
    _pages = pages;
    CGFloat width = 0.f;
    
    NSMutableArray* boundaries = [NSMutableArray arrayWithObject:@0];
    for (NSString* title in pages) {
        
        UIView* view = [pages objectForKey:title];
        [self.container addSubview:view];
        
        CGRect frame = (CGRect) {
            .origin.x = view.frame.origin.x + width,
            .origin.y = view.frame.origin.y,
            .size = view.frame.size
        };
        view.frame = frame;
        width += view.frame.size.width;
        
        CGFloat boundary = frame.origin.x + (frame.size.width / 2);
        [boundaries addObject:[NSNumber numberWithFloat:boundary]];
    }
    self.container.contentSize = CGSizeMake(width, self.container.frame.size.height);
    self.segmentedControl.sectionTitles = [pages allKeys];
    self.boundaries = boundaries;
}

- (void)reloadData {
    NSInteger numberOfPages = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInSegmentedPager:)]) {
        numberOfPages = [self.dataSource numberOfPagesInSegmentedPager:self];
    }
    
    NSMutableDictionary* pages = [NSMutableDictionary dictionary];
    NSMutableArray* images = [NSMutableArray array];
    
    for (NSInteger index = 0; index < numberOfPages; index++) {
        NSString* key = [NSString stringWithFormat:@"Page %ld", (long)index];
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:titleForSectionAtIndex:)]) {
            key = [self.dataSource segmentedPager:self titleForSectionAtIndex:index];
        }
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:viewForPageAtIndex:)]) {
            UIView* view = [self.dataSource segmentedPager:self viewForPageAtIndex:index];
            [pages setObject:view forKey:key];
        }
        else if ([self.dataSource respondsToSelector:@selector(segmentedPager:imageForSectionAtIndex:)]) {
            UIImage* image = [self.dataSource segmentedPager:self imageForSectionAtIndex:index];
            [images addObject:image];
        }
    }
    
    self.pages = pages;
    if (images.count > 0) {
        self.segmentedControl.sectionImages = images;
    }
    else {
        self.segmentedControl.sectionTitles = [pages allKeys];
    }
}

#pragma -mark segmentedControl target
- (void)pageControlValueChanged:(id)sender {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    CGFloat x = 0.f;
    NSArray* keys = [self.pages allKeys];
    
    for (NSInteger i = 0; i < index; ++i) {
        NSString* key = [keys objectAtIndex:i];
        UIView* view = [self.pages objectForKey:key];
        
        x += view.frame.size.width;
    }

    self.moveSegment = NO;
//    CGFloat y = self.scrollView.contentOffset.y;
    [self.container setContentOffset:CGPointMake(x, 0) animated:YES];
    [self changedToIndex:index];
}

#pragma -mark <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.moveSegment = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.moveSegment) {
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

#pragma -mark private methods
- (void)createView {
    CGRect frame = (CGRect) {
        .origin = CGPointZero,
        .size.width = self.frame.size.width,
        .size.height = 44.f
    };
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:frame];
    [self.segmentedControl addTarget:self
                              action:@selector(pageControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentedControl];
    
    frame = (CGRect) {
        .origin.x = 0.f,
        .origin.y = frame.size.height,
        .size.width = self.frame.size.width,
        .size.height = self.frame.size.height - frame.size.height
    };
    
    self.container = [[UIScrollView alloc] initWithFrame:frame];
    self.container.delegate = self;
    self.container.scrollsToTop = NO;
    self.container.pagingEnabled = YES;
    self.container.directionalLockEnabled = YES;
    self.container.alwaysBounceVertical = NO;
    self.container.showsVerticalScrollIndicator = NO;
    self.container.showsHorizontalScrollIndicator = NO;
    self.container.keyboardDismissMode = YES;
    [self addSubview:self.container];
    
    self.moveSegment = YES;
}

- (void) changedToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithIndex:)]) {
        [self.delegate segmentedPager:self didSelectViewWithIndex:index];
    }
    
    NSString* title = [[self.pages allKeys] objectAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithTitle:)]) {
        [self.delegate segmentedPager:self didSelectViewWithTitle:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectView:)]) {
        [self.delegate segmentedPager:self didSelectView:[self.pages objectForKey:title]];
    }
}
@end

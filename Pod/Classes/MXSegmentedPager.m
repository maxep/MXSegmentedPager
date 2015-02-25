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
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSArray* boundaries;
@property (nonatomic, readwrite) BOOL moveSegment;
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

- (UIView *)container {
    return self.scrollView;
}

- (void)createView
{
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
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.keyboardDismissMode = YES;
    [self addSubview:self.scrollView];
    
    self.moveSegment = YES;
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
    self.scrollView.frame = subFrame;
}

- (void) setPages:(NSDictionary *)pages {
    _pages = pages;
    CGFloat width = 0.f;
    
    NSMutableArray* boundaries = [NSMutableArray arrayWithObject:@0];
    for (NSString* title in pages) {
        
        UIView* view = [pages objectForKey:title];
        [self.scrollView addSubview:view];
        
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
    self.scrollView.contentSize = CGSizeMake(width, self.frame.size.height);
    self.segmentedControl.sectionTitles = [pages allKeys];
    self.boundaries = boundaries;
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
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
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
        }
    }
}
@end

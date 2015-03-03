// MXSegmentedPager.h
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

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@class MXSegmentedPager;

@protocol MXSegmentedPagerDelegate <NSObject>

@optional
- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectView:(UIView*)view;
- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithTitle:(NSString*)title;
- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithIndex:(NSInteger)index;

@end

@protocol MXSegmentedPagerDataSource <NSObject>

@required
- (NSInteger) numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager;
- (UIView*) segmentedPager:(MXSegmentedPager*)segmentedPager viewForPageAtIndex:(NSInteger)index;

@optional
- (NSString*) segmentedPager:(MXSegmentedPager*)segmentedPager titleForSectionAtIndex:(NSInteger)index;
- (UIImage*) segmentedPager:(MXSegmentedPager*)segmentedPager imageForSectionAtIndex:(NSInteger)index;
@end

@interface MXSegmentedPager : UIView

@property (nonatomic, assign) id<MXSegmentedPagerDelegate> delegate;
@property (nonatomic, assign) id<MXSegmentedPagerDataSource> dataSource;

@property (nonatomic, readwrite) CGSize containerSize;

@property (nonatomic, strong) HMSegmentedControl* segmentedControl;
@property (nonatomic, strong) UIScrollView* container;

- (void) reloadData;

@end

// MXExampleViewController.m
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

#import "MXExampleViewController.h"
#import "MXSimpleViewController.h"
#import "MXParallaxViewController.h"

@implementation MXExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControlPosition = MXSegmentedControlPositionBottom;
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(12, 12, 0, 12);

    self.segmentedPager.pager.transitionStyle = MXPagerViewTransitionStyleTab;

    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.textColor = [UIColor blackColor];
    self.segmentedPager.segmentedControl.selectedTextColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControl.indicator.lineView.backgroundColor = [UIColor orangeColor];
}

#pragma mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"Simple", @"Parallax", @"Storyboard"][index];
}

@end

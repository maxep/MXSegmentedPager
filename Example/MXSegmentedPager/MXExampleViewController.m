// MXExampleViewController.m
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

#import "MXExampleViewController.h"
#import "MXSimpleViewController.h"
#import "MXParallaxViewController.h"

@interface MXExampleViewController ()
@property (nonatomic, strong) MXSimpleViewController    *simpleController;
@property (nonatomic, strong) MXParallaxViewController  *parallaxController;
@end

@implementation MXExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedPager.pager.transitionStyle = MXPagerViewTransitionStyleTab;
    
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor blackColor];
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    self.segmentedPager.segmentedControlPosition = MXSegmentedControlPositionBottom;
    
    
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];   
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedPager.segmentedControl.shouldAnimateUserSelection = NO;
    self.segmentedPager.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    self.segmentedPager.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    
    self.segmentedPager.segmentedControl.borderColor = [UIColor blueColor];
    self.segmentedPager.segmentedControl.borderType = HMSegmentedControlBorderTypeTop | HMSegmentedControlBorderTypeLeft | HMSegmentedControlBorderTypeBottom | HMSegmentedControlBorderTypeRight;
    self.segmentedPager.segmentedControl.layer.cornerRadius = 4;
    self.segmentedPager.segmentedControl.layer.borderColor = [UIColor blueColor].CGColor;
    self.segmentedPager.segmentedControl.layer.borderWidth = 2;
    
    self.segmentedPager.clipsToBounds = YES;
    self.segmentedPager.segmentedControl.clipsToBounds = YES;
    
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor blueColor];
    self.segmentedPager.segmentedControl.selectionIndicatorBoxOpacity = 1;
    
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
}

#pragma mark Properties

- (MXSimpleViewController *)simpleController {
    if (!_simpleController) {
        _simpleController = [[MXSimpleViewController alloc] init];
    }
    return _simpleController;
}

- (MXParallaxViewController *)parallaxController {
    if (!_parallaxController) {
        _parallaxController = [[MXParallaxViewController alloc] init];
    }
    return _parallaxController;
}

#pragma -mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index {
    
    return (index < 1)? self.simpleController : self.parallaxController;
}

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 2;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return (index < 1)? @"Simple": @"Parallax";
}

@end

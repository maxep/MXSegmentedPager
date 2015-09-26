// MXSegmentedPagerController.m
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

#import "MXSegmentedPagerController.h"

@interface MXSegmentedPagerController ()
@property (nonatomic,weak) UIViewController *pageViewController;
@property (nonatomic) NSInteger pageIndex;
@end

@implementation MXSegmentedPagerController

@synthesize segmentedPager = _segmentedPager;

- (void)loadView {
    self.view = self.segmentedPager;
}

#pragma mark Properties

- (UIView *)segmentedPager {
    if (!_segmentedPager) {
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

#pragma mark <MXSegmentedPagerControllerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    NSArray *segues = [self valueForKey:@"storyboardSegueTemplates"] ;
    return segues.count;
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    UIViewController *viewController = [self segmentedPager:segmentedPager viewControllerForPageAtIndex:index];
    
    if (viewController) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];

        return viewController.view;
    }
    return nil;
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index {
    if (self.storyboard) {
        @try {
            NSString *identifier = [self segmentedPager:segmentedPager segueIdentifierForPageAtIndex:index];
            self.pageIndex = index;
            [self performSegueWithIdentifier:identifier sender:nil];
            return self.pageViewController;
        }
        @catch(NSException *exception) {}
    }
    return nil;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager segueIdentifierForPageAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:MXSeguePageIdentifierFormat, (long)index];
}

@end

#pragma mark MXSegmentedPagerControllerPageSegue class

NSString * const MXSeguePageIdentifierFormat = @"mx_page_%ld";

@implementation MXPageSegue

@synthesize pageIndex = _pageIndex;

- (instancetype)initWithIdentifier:(nullable NSString *)identifier source:(MXSegmentedPagerController *)source destination:(UIViewController *)destination {
    if (self = [super initWithIdentifier:identifier source:source destination:destination]) {
        _pageIndex = source.pageIndex;
    }
    return self;
}

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[MXSegmentedPagerController class]]) {
        MXSegmentedPagerController *spc = self.sourceViewController;
        spc.pageViewController = self.destinationViewController;
    }
}

@end

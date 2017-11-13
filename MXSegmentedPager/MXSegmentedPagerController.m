// MXSegmentedPagerController.m
//
// Copyright (c) 2017 Maxime Epain
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

@interface MXSegmentedPagerController () <MXPageSegueSource>
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *pageViewControllers;
@end

@implementation MXSegmentedPagerController {
    NSInteger _pageIndex;
}

@synthesize segmentedPager = _segmentedPager;

#pragma mark Properties

- (UIView *)segmentedPager {
    if (!_segmentedPager) {
        _segmentedPager = [MXSegmentedPager new];
        _segmentedPager.translatesAutoresizingMaskIntoConstraints = NO;
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

- (NSMutableDictionary<NSNumber *,UIViewController *> *)pageViewControllers {
    if (!_pageViewControllers) {
        _pageViewControllers = [NSMutableDictionary new];
    }
    return _pageViewControllers;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.segmentedPager];

    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[
            [self.segmentedPager.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
            [self.segmentedPager.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
            [self.segmentedPager.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
            [self.segmentedPager.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        ]];
    } else {
        // Because the pod supports iOS 7, we use old APIs
        [self.view addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.segmentedPager attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:self.segmentedPager attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:self.segmentedPager attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:self.segmentedPager attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        ]];
    }
}

#pragma mark <MXSegmentedPagerControllerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    NSInteger count = 0;
    
    //Hack to get number of MXPageSegue
    NSArray *templates = [self valueForKey:@"storyboardSegueTemplates"];
    for (id template in templates) {
        NSString *segueClasseName = [template valueForKey:@"_segueClassName"];
        if ([segueClasseName isEqualToString:NSStringFromClass(MXPageSegue.class)]) {
            count++;
        }
    }
    return count;
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    UIViewController *viewController = [self segmentedPager:segmentedPager viewControllerForPageAtIndex:index];
    return viewController.view;
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index {
    UIViewController *pageViewController = self.pageViewControllers[@(index)];
    
    if (!pageViewController && self.storyboard) {
        NSString *identifier = [self segmentedPager:segmentedPager segueIdentifierForPageAtIndex:index];
        @try {
            _pageIndex = index;
            
            [self performSegueWithIdentifier:identifier sender:nil];
            return self.pageViewControllers[@(index)];
        }
        @catch(NSException *exception) {
            NSLog(@"Error while performing segue with identifier %@ from %@ : %@", identifier, self, exception);
        }
    }
    return pageViewController;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager segueIdentifierForPageAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:MXSeguePageIdentifierFormat, (long)index];
}

#pragma mark <MXPageSegueSource>

- (NSInteger)pageIndex {
    return _pageIndex;
}

- (void)setPageViewController:(__kindof UIViewController *)pageViewController atIndex:(NSInteger)index {
    self.pageViewControllers[@(index)] = pageViewController;
}

@end

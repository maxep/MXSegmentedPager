//
//  MXStoryboardViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 25/09/2016.
//  Copyright © 2016 Maxime Epain. All rights reserved.
//

#import "MXStoryboardViewController.h"
#import "MXNumberViewController.h"

@interface MXStoryboardViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@end

@implementation MXStoryboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Parallax Header
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 150;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.textColor = [UIColor blackColor];
    self.segmentedPager.segmentedControl.selectedTextColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControl.indicator.lineView.backgroundColor = [UIColor orangeColor];
    
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.segmentedPager.parallaxHeader.minimumHeight = self.view.safeAreaInsets.top;
}

#pragma mark Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(MXPageSegue *)segue sender:(id)sender {
    MXNumberViewController *numberViewController = segue.destinationViewController;
    numberViewController.number = segue.pageIndex;
}

#pragma mark <MXSegmentedPagerControllerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 10;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager segueIdentifierForPageAtIndex:(NSInteger)index {
    return @"number";
}

@end

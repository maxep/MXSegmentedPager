//
//  MXStoryboardViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 25/09/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXStoryboardViewController.h"
#import "MXNumberViewController.h"
#import "MXRefreshHeaderView.h"

@implementation MXStoryboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Parallax Header
    self.segmentedPager.parallaxHeader.view = [MXRefreshHeaderView instantiateFromNib];
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.segmentedPager.parallaxHeader.height = 150;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
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

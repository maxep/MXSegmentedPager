//
//  MXFancyViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 01/03/2015.
//  Copyright (c) 2015 Maxime Epain. All rights reserved.
//

#import "MXFancyViewController.h"
#import "MXFancyView.h"

@interface MXFancyViewController ()
@property (nonatomic, strong) MXFancyView* fancyView;
@end

@implementation MXFancyViewController

static NSString * const reuseCellIdentifier     = @"Cell";
static NSString * const reuseHeaderIdentifier   = @"Header";
static NSString * const reuseSectionIdentifier  = @"Section";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fancyView = [[MXFancyView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size = self.view.frame.size
    }];
    
    [self.view addSubview:self.fancyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MXNumberViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 25/09/2016.
//  Copyright © 2016 Maxime Epain. All rights reserved.
//

#import "MXNumberViewController.h"

@interface MXNumberViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation MXNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberLabel.text = [NSString stringWithFormat:@"Page %li", (long)self.number];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    self.numberLabel.text = [NSString stringWithFormat:@"Page %li", (long)self.number];
}

@end

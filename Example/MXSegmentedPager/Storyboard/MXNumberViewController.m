//
//  MXNumberViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 25/09/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

#import "MXNumberViewController.h"

@interface MXNumberViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation MXNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberLabel.text = [NSString stringWithFormat:@"Page %li", self.number];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

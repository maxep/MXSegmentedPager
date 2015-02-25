//
//  MXSegmentedPager.h
//  Pods
//
//  Created by Maxime Epain on 25/02/2015.
//
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface MXSegmentedPager : UIView

@property (nonatomic, strong) HMSegmentedControl* segmentedControl;

@property (nonatomic, strong) NSDictionary* pages;

@end

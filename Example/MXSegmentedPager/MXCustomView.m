//
//  MXCustomView.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 19/05/2015.
//  Copyright (c) 2015 Maxime Epain. All rights reserved.
//

#import "MXCustomView.h"
#import "MXSegmentedPager+ParallaxHeader.h"

@interface MXCustomView () <MXPageProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UITableView *table2;
@end

@implementation MXCustomView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.table1.frame = (CGRect){
        .origin         = CGPointZero,
        .size.width     = self.frame.size.width / 2,
        .size.height    = self.frame.size.height
    };
    
    self.table2.frame = (CGRect){
        .origin.x   = self.frame.size.width / 2,
        .origin.y   = 0.f,
        .size       = self.table1.frame.size
    };
}

- (UITableView *)table1 {
    if (!_table1) {
        _table1 = [[UITableView alloc] init];
        _table1.delegate    = self;
        _table1.dataSource  = self;
        [self addSubview:_table1];
    }
    return _table1;
}

- (UITableView *)table2 {
    if (!_table2) {
        _table2 = [[UITableView alloc] init];
        _table2.delegate    = self;
        _table2.dataSource  = self;
        [self addSubview:_table2];
    }
    return _table2;
}

#pragma -mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    
    return cell;
}

#pragma mark <MXPageProtocol>

- (BOOL)segmentedPager:(MXSegmentedPager *)segmentedPager shouldScrollWithView:(UIView *)view {
    if (view == self.table2) {
        return NO;
    }
    return YES;
}

@end

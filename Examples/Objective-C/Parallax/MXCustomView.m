// MXCustomView.m
//
// Copyright (c) 2019 Maxime Epain
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

#import <MXSegmentedPager/MXSegmentedPager.h>

#import "MXCustomView.h"

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

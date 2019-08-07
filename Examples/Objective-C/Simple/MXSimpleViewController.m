// MXSimpleViewController.m
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

#import <WebKit/WebKit.h>

#import "MXSimpleViewController.h"
#import "MXSegmentedPager.h"

@interface MXSimpleViewController () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) WKWebView         * webView;
@property (nonatomic, strong) UITextView        * textView;
@end

@implementation MXSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.segmentedPager];
    self.segmentedPager.segmentedControl.textColor = [UIColor blackColor];
    self.segmentedPager.segmentedControl.selectedTextColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControl.indicator.lineView.backgroundColor = [UIColor orangeColor];
    
    self.segmentedPager.pager.gutterWidth = 20;
    
    //Register UItableView as page
    [self.segmentedPager.pager registerClass:[UITextView class] forPageReuseIdentifier:@"TextPage"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.segmentedPager.frame = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets);
}

#pragma -mark Properties

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {
        
        // Set a segmented pager
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        //Add a table page
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (WKWebView *)webView {
    if (!_webView) {
        // Add a web page
        _webView = [[WKWebView alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://nshipster.com/"];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
    }
    return _webView;
}

- (UITextView *)textView {
    if (!_textView) {
        // Add a text page
        _textView = [[UITextView alloc] init];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
        _textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    return _textView;
}

#pragma -mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 10;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    if (index < 3) {
        return [@[@"Table", @"Web", @"Text"] objectAtIndex:index];
    }
    return [NSString stringWithFormat:@"Page %li", (long) index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    if (index < 3) {
        return @[self.tableView, self.webView, self.textView][index];
    }
    
    //Dequeue reusable page
    UITextView *page = [segmentedPager.pager dequeueReusablePageWithIdentifier:@"TextPage"];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
    page.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return page;
}

#pragma -mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = (indexPath.row % 2) + 1;
    [self.segmentedPager showPageAtIndex:index animated:YES];
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
    cell.textLabel.text = (indexPath.row % 2)? @"Text": @"Web";
    
    return cell;
}

@end

// MXViewController.m
//
// Copyright (c) 2015 Maxime Epain
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

#import "MXViewController.h"
#import "MXSegmentedPager.h"

@interface MXViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary* pages = [NSMutableDictionary dictionary];
    
    // Boundary between cover and segmented pager
    CGFloat boundary = self.view.frame.size.height / 3;
    
    // Set a cover on the top of the view
    UIImageView* cover = [[UIImageView alloc] initWithFrame:(CGRect){
        .origin         = CGPointZero,
        .size.width     = self.view.frame.size.width,
        .size.height    = boundary
    }];
    cover.contentMode = UIViewContentModeScaleAspectFill;
    cover.image = [UIImage imageNamed:@"success-baby"];
    [self.view addSubview:cover];
    
    // Set a segmented pager on the below the cover
    MXSegmentedPager* segmentedPager = [[MXSegmentedPager alloc] initWithFrame:(CGRect){
        .origin.x       = 0,
        .origin.y       = boundary,
        .size.width     = self.view.frame.size.width,
        .size.height    = 2 * boundary
    }];
    [self.view addSubview:segmentedPager];
    
    //Add a table page
    UITableView* tableView = [[UITableView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = segmentedPager.contentView.frame.size
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [pages setObject:tableView forKey:@"Table"];
    
    // Add a web page
    UIWebView* webView = [[UIWebView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = segmentedPager.contentView.frame.size
    }];
    NSString *strURL = @"http://nshipster.com/";
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [pages setObject:webView forKey:@"Web"];
    
    // Add a text page
    UITextView* textView = [[UITextView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = segmentedPager.contentView.frame.size
    }];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
    textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [pages setObject:textView forKey:@"Text"];
    
    // Set the pages in the segmented pager
    segmentedPager.pages = pages;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark <UITableViewDelegate>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

#pragma -mark <UITableViewDataSource>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    
    return cell;
}

@end
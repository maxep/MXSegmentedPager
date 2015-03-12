//
//  MXParallaxViewController.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 11/03/2015.
//  Copyright (c) 2015 Maxime Epain. All rights reserved.
//

#import "MXParallaxViewController.h"
#import "MXSegmentedPager+ParallaxHeader.h"

@interface MXParallaxViewController () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView       * cover;
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) UIWebView         * webView;
@property (nonatomic, strong) UITextView        * textView;
@end

@implementation MXParallaxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup the segmented pager properties
    self.segmentedPager.delegate = self;
    self.segmentedPager.dataSource = self;
    [self.segmentedPager setParallaxHeaderView:self.cover mode:VGParallaxHeaderModeFill height:150.f];
    
    [self.view addSubview:self.segmentedPager];
}

#pragma -mark private methods

- (UIImageView *)cover {
    if (!_cover) {
        // Boundary between cover and segmented pager
        CGFloat boundary = self.view.frame.size.height / 3;
        
        // Set a cover on the top of the view
        _cover = [[UIImageView alloc] initWithFrame:(CGRect){
            .origin         = CGPointZero,
            .size.width     = self.view.frame.size.width,
            .size.height    = boundary
        }];
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.image = [UIImage imageNamed:@"success-baby"];
    }
    return _cover;
}

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {
        
        // Set a segmented pager below the cover
        _segmentedPager = [[MXSegmentedPager alloc] initWithFrame:(CGRect){
            .origin = CGPointZero,
            .size   = self.view.frame.size
        }];
    }
    return _segmentedPager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        //Add a table page
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){
            .origin = CGPointZero,
            .size   = self.segmentedPager.containerSize
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIWebView *)webView {
    if (!_webView) {
        // Add a web page
        _webView = [[UIWebView alloc] initWithFrame:(CGRect){
            .origin = CGPointZero,
            .size   = self.segmentedPager.containerSize
        }];
        NSString *strURL = @"http://nshipster.com/";
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
    }
    return _webView;
}

- (UITextView *)textView {
    if (!_textView) {
        // Add a text page
        _textView = [[UITextView alloc] initWithFrame:(CGRect){
            .origin = CGPointZero,
            .size   = self.segmentedPager.containerSize
        }];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
        _textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    return _textView;
}

#pragma -mark <MXSegmentedPagerDataSource>
- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 3;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return [@[@"Table", @"Web", @"Text"] objectAtIndex:index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    return [@[self.tableView, self.webView, self.textView] objectAtIndex:index];
}

#pragma -mark <UITableViewDelegate>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MXParallaxViewController *parallaxViewController = [[MXParallaxViewController alloc] init];
    [self.navigationController pushViewController:parallaxViewController animated:YES];
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

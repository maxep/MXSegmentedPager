//
//  MXFancyView.m
//  MXSegmentedPager
//
//  Created by Maxime Epain on 02/03/2015.
//  Copyright (c) 2015 Maxime Epain. All rights reserved.
//

#import "MXFancyView.h"
#import "CSStickyHeaderFlowLayout.h"
#import "MXSegmentedPager.h"

@interface MXFancyView () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView* cover;
@property (nonatomic, strong) MXSegmentedPager* segmentedPager;
@end

@implementation MXFancyView

static NSString * const reuseCellIdentifier     = @"Cell";
static NSString * const reuseHeaderIdentifier   = @"Header";
static NSString * const reuseSectionIdentifier  = @"Section";

- (instancetype)init {
    self = [super init];
    if (self) {
        self.collectionViewLayout = [[CSStickyHeaderFlowLayout alloc] init];
        [self createView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewLayout = [[CSStickyHeaderFlowLayout alloc] init];
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CSStickyHeaderFlowLayout *layout= [[CSStickyHeaderFlowLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    // Register cell classes
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:reuseHeaderIdentifier];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSectionIdentifier];
    
        CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.frame.size.width, 200);
        layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
    }
    
    // Set a cover on the top of the view
    self.cover = [[UIImageView alloc] initWithFrame:(CGRect){
        .origin         = CGPointZero,
        .size.width     = self.frame.size.width,
        .size.height    = self.frame.size.height / 3
    }];
    self.cover.contentMode = UIViewContentModeScaleAspectFill;
    self.cover.image = [UIImage imageNamed:@"success-baby"];
    
    NSMutableDictionary* pages = [NSMutableDictionary dictionary];
    // Set a segmented pager on the below the cover
    self.segmentedPager = [[MXSegmentedPager alloc] initWithFrame:self.frame];
    
    //Add a table page
    UITableView* tableView = [[UITableView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = self.segmentedPager.contentView.frame.size
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [pages setObject:tableView forKey:@"Table"];
    
    // Add a web page
    UIWebView* webView = [[UIWebView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = self.segmentedPager.contentView.frame.size
    }];
    NSString *strURL = @"http://nshipster.com/";
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
    [pages setObject:webView forKey:@"Web"];
    
    // Add a text page
    UITextView* textView = [[UITextView alloc] initWithFrame:(CGRect){
        .origin = CGPointZero,
        .size   = self.segmentedPager.contentView.frame.size
    }];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
    textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [pages setObject:textView forKey:@"Text"];
    
    // Set the pages in the segmented pager
    self.segmentedPager.pages = pages;
    
//    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.cover.frame.size.height, 0, 0, 0);
    
    self.segmentedPager.contentView.frame = (CGRect){
        .origin = CGPointZero,
        .size = self.segmentedPager.contentView.frame.size
    };
    
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.segmentedPager.contentView.frame.size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.segmentedPager.segmentedControl.frame.size;
}

#pragma mark <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier
                                                                           forIndexPath:indexPath];
    [cell.contentView addSubview:self.segmentedPager.contentView];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:reuseSectionIdentifier
                                                                                   forIndexPath:indexPath];
        [cell addSubview:self.segmentedPager.segmentedControl];
        return cell;
        
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:reuseHeaderIdentifier
                                                                                   forIndexPath:indexPath];
        [cell addSubview:self.cover];
        return cell;
    }
    return nil;
}

#pragma -mark <UITableViewDelegate>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

#pragma -mark <UITableViewDataSource>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    
    return cell;
}

@end

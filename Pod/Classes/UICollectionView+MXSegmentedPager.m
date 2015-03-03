// UICollectionView+MXSegmentedPager.m
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

#import <objc/runtime.h>
#import "UICollectionView+MXSegmentedPager.h"
#import "CSStickyHeaderFlowLayout.h"

static NSString * const reuseCellIdentifier     = @"Cell";
static NSString * const reuseHeaderIdentifier   = @"Header";
static NSString * const reuseSectionIdentifier  = @"Section";

@implementation MXSegmentedPager (UICollectionView)

- (UIImageView *)header {
    return objc_getAssociatedObject(self, @selector(header));
}

- (void)setHeader:(UIImageView *)header {
    objc_setAssociatedObject(self, @selector(header), header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.containerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.segmentedControl.frame.size;
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    
    self.container.frame = (CGRect) {
        .origin = CGPointZero,
        .size   = self.containerSize
    };
    [self reloadData];
    [cell.contentView addSubview:self.container];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseSectionIdentifier forIndexPath:indexPath];
        [cell addSubview:self.segmentedControl];
        return cell;
        
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        [cell addSubview:self.header];
        return cell;
    }
    return nil;
}

@end

@interface UICollectionView () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>
@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;
@end

@implementation UICollectionView (MXSegmentedPager)

- (MXSegmentedPager *)segmentedPager {
    return objc_getAssociatedObject(self, @selector(segmentedPager));
}

- (void)setSegmentedPager:(MXSegmentedPager *)segmentedPager {
    objc_setAssociatedObject(self, @selector(segmentedPager), segmentedPager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (instancetype)initWithSegmentedPager:(MXSegmentedPager*)segmentedPager {
    self = [super init];
    if (self) {
        self.collectionViewLayout = [[CSStickyHeaderFlowLayout alloc] init];
        self.segmentedPager = segmentedPager;
        [self createView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder segmentedPager:(MXSegmentedPager*)segmentedPager {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.collectionViewLayout = [[CSStickyHeaderFlowLayout alloc] init];
        self.segmentedPager = segmentedPager;
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame segmentedPager:(MXSegmentedPager*)segmentedPager {
    CSStickyHeaderFlowLayout *layout= [[CSStickyHeaderFlowLayout alloc] init];
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.segmentedPager = segmentedPager;
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
    
    self.delegate = self.segmentedPager;
    self.dataSource = self.segmentedPager;
}

@end

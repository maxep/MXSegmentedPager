// MXSegmentedPager.m
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
#import "MXSegmentedPager.h"



@interface MXScrollView : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat minimumHeigth;
@property (nonatomic, strong) MXSegmentedPager *segmentedPager;
@property (nonatomic, strong) MXProgressBlock progressBlock;
@property (nonatomic, strong) NSMutableArray *observedViews;
@end


@interface MXSegmentedPager () <MXPagerViewDelegate, MXPagerViewDataSource>
@property (nonatomic, strong) MXScrollView          *contentView;
@property (nonatomic, strong) HMSegmentedControl    *segmentedControl;
@property (nonatomic, strong) MXPagerView           *pager;
@end

@implementation MXSegmentedPager {
    CGFloat     _controlHeight;
    NSInteger   _count;
    BOOL        _moveSegment;
}

- (void)layoutSubviews {
    if (_count <= 0) {
        [self reloadData];
    }
    
    CGRect frame = self.bounds;
    //Layout content view
    frame.origin = CGPointZero;
    self.contentView.frame = frame;
    
    //Layout control
    frame.origin = (self.segmentedControlPosition == MXSegmentedControlPositionTop)?
    CGPointMake(self.segmentedControlEdgeInsets.left, self.segmentedControlEdgeInsets.top) :
    CGPointMake(self.segmentedControlEdgeInsets.left, self.bounds.size.height - _controlHeight - self.segmentedControlEdgeInsets.bottom);
    frame.size.width = self.frame.size.width - self.segmentedControlEdgeInsets.left - self.segmentedControlEdgeInsets.right;
    frame.size.height = _controlHeight;

    self.segmentedControl.frame = frame;
    
    //Layout pager
    frame.origin = (self.segmentedControlPosition == MXSegmentedControlPositionTop)?
    CGPointMake(0, _controlHeight + self.segmentedControlEdgeInsets.top + self.segmentedControlEdgeInsets.bottom) : CGPointZero;
    
    frame.size.width = self.bounds.size.width;
    CGFloat height = self.contentView.frame.size.height - _controlHeight;
    height -= self.contentView.minimumHeigth;
    height -= self.segmentedControlEdgeInsets.top;
    height -= self.segmentedControlEdgeInsets.bottom;
    frame.size.height = height;
    
    self.pager.frame = frame;
    
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [super layoutSubviews];
}

- (void)reloadData {
    
    //Gets the segmented control height
    _controlHeight = 44.f;
    if ([self.delegate respondsToSelector:@selector(heightForSegmentedControlInSegmentedPager:)]) {
        _controlHeight = [self.delegate heightForSegmentedControlInSegmentedPager:self];
    }
    _count = [self.dataSource numberOfPagesInSegmentedPager:self];
    
    //Gets new data
    NSMutableArray* images  = [NSMutableArray array];
    NSMutableArray* titles  = [NSMutableArray array];
    
    for (NSInteger index = 0; index < _count; index++) {
        
        id title = [NSString stringWithFormat:@"Page %ld", (long)index];
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:titleForSectionAtIndex:)]) {
            title = [self.dataSource segmentedPager:self titleForSectionAtIndex:index];
        }
        else if ([self.dataSource respondsToSelector:@selector(segmentedPager:attributedTitleForSectionAtIndex:)]) {
            title = [self.dataSource segmentedPager:self attributedTitleForSectionAtIndex:index];
        }
        [titles addObject:title];
        
        if ([self.dataSource respondsToSelector:@selector(segmentedPager:imageForSectionAtIndex:)]) {
            UIImage* image = [self.dataSource segmentedPager:self imageForSectionAtIndex:index];
            [images addObject:image];
        }
    }
    
    self.segmentedControl.sectionImages = images;
    self.segmentedControl.sectionTitles = titles;
    
    [self.pager reloadData];
    [self layoutIfNeeded];
}

#pragma mark Properties

- (MXScrollView *)contentView {
    if (!_contentView) {
        
        // Create scroll-view
        _contentView = [[MXScrollView alloc] init];
        _contentView.segmentedPager = self;
        _contentView.scrollEnabled = NO;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] init];
        [_segmentedControl addTarget:self
                              action:@selector(pageControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_segmentedControl];
        _moveSegment = YES;
        
        self.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _segmentedControl;
}

- (MXPagerView *)pager {
    if (!_pager) {
        _pager = [[MXPagerView alloc] init];
        _pager.delegate = self;
        _pager.dataSource = self;
        [self.contentView addSubview:_pager];
    }
    return _pager;
}

- (UIView*) selectedPage {
    return self.pager.selectedPage;
}

- (void)setSegmentedControlPosition:(MXSegmentedControlPosition)segmentedControlPosition {
    _segmentedControlPosition = segmentedControlPosition;
    [self setNeedsLayout];
}

- (void)setSegmentedControlEdgeInsets:(UIEdgeInsets)segmentedControlEdgeInsets {
    _segmentedControlEdgeInsets = segmentedControlEdgeInsets;
    [self setNeedsLayout];
}

#pragma mark HMSegmentedControl target

- (void)pageControlValueChanged:(HMSegmentedControl*)segmentedControl {
    _moveSegment = NO;
    [self.pager showPageAtIndex:segmentedControl.selectedSegmentIndex animated:YES];
}

#pragma mark <MXPagerViewDelegate>

- (void)pagerView:(MXPagerView *)pagerView willMoveToPageAtIndex:(NSInteger)index {
    if (_moveSegment) {
        [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    }
}

- (void)pagerView:(MXPagerView *)pagerView didMoveToPageAtIndex:(NSInteger)index {
    [self.segmentedControl setSelectedSegmentIndex:index animated:NO];
    [self changedToIndex:index];
    _moveSegment = YES;
}

#pragma mark <MXPagerViewDataSource>

- (NSInteger)numberOfPagesInPagerView:(MXPagerView *)pagerView {
    return _count;
}

- (UIView*) pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    return [self.dataSource segmentedPager:self viewForPageAtIndex:index];
}

#pragma mark Private methods

- (void) changedToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithIndex:)]) {
        [self.delegate segmentedPager:self didSelectViewWithIndex:index];
    }
    
    NSString* title = self.segmentedControl.sectionTitles[index];
    UIView* view = self.pager.selectedPage;
                    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectViewWithTitle:)]) {
        [self.delegate segmentedPager:self didSelectViewWithTitle:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedPager:didSelectView:)]) {
        [self.delegate segmentedPager:self didSelectView:view];
    }
}

@end

@implementation MXSegmentedPager (ParallaxHeader)

#pragma mark VGParallaxHeader

- (void)setParallaxHeaderView:(UIView *)view mode:(VGParallaxHeaderMode)mode height:(CGFloat)height {
    [self.contentView setParallaxHeaderView:view mode:mode height:height];
    self.contentView.scrollEnabled = !!view;
}

- (VGParallaxHeader *)parallaxHeader {
    return self.contentView.parallaxHeader;
}

#pragma mark Properties

- (CGFloat)minimumHeaderHeight {
    return self.contentView.minimumHeigth;
}

- (void)setMinimumHeaderHeight:(CGFloat)minimumHeaderHeight {
    self.contentView.minimumHeigth = minimumHeaderHeight;
}

- (MXProgressBlock)progressBlock {
    return self.contentView.progressBlock;
}

- (void)setProgressBlock:(MXProgressBlock)progressBlock {
    self.contentView.progressBlock = progressBlock;
}

@end

@implementation MXScrollView {
    BOOL _isObserving;
    BOOL _lock;
}

static void * const kMXScrollViewKVOContext = (void*)&kMXScrollViewKVOContext;
static NSString* const kContentOffsetKeyPath = @"contentOffset";

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.bounces = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.contentMode = UIViewContentModeTopRight;
        self.minimumHeigth = 0;
    }
    return self;
}

#pragma mark Properties

- (NSMutableArray *)observedViews {
    if (!_observedViews) {
        _observedViews = [NSMutableArray array];
    }
    return _observedViews;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    [super setScrollEnabled:scrollEnabled];
    
    if (scrollEnabled) {
        [self addObserver:self forKeyPath:kContentOffsetKeyPath
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:kMXScrollViewKVOContext];
    }
    else {
        @try {
            [self removeObserver:self forKeyPath:kContentOffsetKeyPath];
        }
        @catch (NSException *exception) {}
    }
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((self.contentOffset.y >= -self.minimumHeigth)) {
        self.contentOffset = CGPointMake(self.contentOffset.x, -self.minimumHeigth);
    }
    
    [scrollView shouldPositionParallaxHeader];
    
    if (self.progressBlock) {
        self.progressBlock(scrollView.parallaxHeader.progress);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _lock = NO;
    [self removeObservedViews];
}

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        MXPanGestureDirection direction = [(UIPanGestureRecognizer*)gestureRecognizer directionInView:self];
        
        //Lock horizontal pan gesture.
        if (direction == MXPanGestureDirectionLeft || direction == MXPanGestureDirectionRight) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    UIView<MXPageProtocol> *page = (id) self.segmentedPager.pager.selectedPage;
    BOOL shouldScroll = YES;
    
    if ([page respondsToSelector:@selector(segmentedPager:shouldScrollWithView:)]) {
        shouldScroll = [page segmentedPager:self.segmentedPager shouldScrollWithView:otherGestureRecognizer.view];
    }
    
    if (shouldScroll) {
        [self addObservedView:otherGestureRecognizer.view];
    }
    return shouldScroll;
}

#pragma mark KVO

- (void) addObserverToView:(UIView *)view {
    _isObserving = NO;
    if ([view isKindOfClass:[UIScrollView class]]) {
        [view addObserver:self
               forKeyPath:kContentOffsetKeyPath
                  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                  context:kMXScrollViewKVOContext];
    }
    _isObserving = YES;
}

- (void) removeObserverFromView:(UIView *)view {
    @try {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view removeObserver:self
                      forKeyPath:kContentOffsetKeyPath
                         context:kMXScrollViewKVOContext];
        }
    }
    @catch (NSException *exception) {}
}

//This is where the magic happens...
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kMXScrollViewKVOContext && [keyPath isEqualToString:kContentOffsetKeyPath]) {
        
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        
        if (old.y == new.y) return;
        
        if (_isObserving && object == self) {
            //Adjust self scroll offset
            if ((old.y - new.y) > 0 && _lock) {
                [self scrollView:self setContentOffset:old];
            }
        }
        else if (_isObserving && [object isKindOfClass:[UIScrollView class]]) {
            
            //Adjust the observed scrollview's content offset
            UIScrollView *scrollView = object;
            _lock = !(scrollView.contentOffset.y <= -scrollView.contentInset.top);
            
            //Manage scroll up
            if (self.contentOffset.y < -self.minimumHeigth && _lock && (old.y - new.y) < 0) {
                [self scrollView:scrollView setContentOffset:old];
            }
            //Disable bouncing when scroll down
            if (!_lock) {
                [self scrollView:scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top)];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Scrolling views handlers

- (void) addObservedView:(UIView *)view {
    if (![self.observedViews containsObject:view]) {
        [self.observedViews addObject:view];
        [self addObserverToView:view];
    }
}

- (void) removeObservedViews {
    for (UIView *view in self.observedViews) {
        [self removeObserverFromView:view];
    }
    [self.observedViews removeAllObjects];
}

- (void) scrollView:(UIScrollView*)scrollView setContentOffset:(CGPoint)offset {
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


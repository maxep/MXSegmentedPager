// MXPagerView.m
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

#import "MXPagerView.h"

#define MXPagerViewLoadPage(index) { \
    [self loadPageAtIndex:index]; \
    if(self.behavior == MXPagerViewBehaviorSlide) { \
        [self loadPageAtIndex:(index - 1)]; \
        [self loadPageAtIndex:index]; \
        [self loadPageAtIndex:(index + 1)]; \
    } \
}

@interface MXPagerView ()
@property (nonatomic, strong) NSMutableDictionary *pages;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger count;
@end

@implementation MXPagerView

static void * const kMXPagerViewKVOContext = (void*)&kMXPagerViewKVOContext;

@dynamic delegate;

- (instancetype)init {
    self = [super init];
    if (self) {

        self.scrollsToTop = NO;
        self.pagingEnabled = YES;
        self.directionalLockEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.behavior = MXPagerViewBehaviorSlide;
        
        _index = 0;
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:kMXPagerViewKVOContext];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    for (NSNumber *key in self.pages) {
        UIView *page = self.pages[key];
        
        NSInteger index = [key integerValue];
        page.frame = (CGRect) {
            .origin.x   = rect.size.width * index,
            .origin.y   = 0.f,
            .size       = rect.size
        };
    }
    self.contentSize   = CGSizeMake(rect.size.width * self.count, rect.size.height);
    self.contentOffset = CGPointMake(rect.size.width * self.index, 0);
}

- (void) reloadData {
    
    for (NSNumber *key in self.pages) {
        UIView *page = self.pages[key];
        [page removeFromSuperview];
    }
    [self.pages removeAllObjects];
    
    self.count = [self.dataSource numberOfPagesInPagerView:self];
    
    MXPagerViewLoadPage(self.index);
    
    self.contentSize    = CGSizeMake(self.frame.size.width * self.count, self.frame.size.height);
    self.contentOffset  = CGPointMake(self.frame.size.width * self.index, 0);
}

- (void) showPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat x = self.frame.size.width * index;
    if (self.behavior == MXPagerViewBehaviorSlide) {
        [self setContentOffset:CGPointMake(x, 0) animated:animated];
    }
    else {
        self.contentOffset = CGPointMake(x, 0);
    }
}

#pragma mark Properties

- (void)setIndex:(NSInteger)index {
    _index = index;
    if ([self.delegate respondsToSelector:@selector(pagerView:didMoveToPageAtIndex:)]) {
        [self.delegate pagerView:self didMoveToPageAtIndex:index];
    }
}

- (NSMutableDictionary *)pages {
    if (!_pages) {
        _pages = [NSMutableDictionary dictionary];
    }
    return _pages;
}

- (UIView *)selectedPage {
    NSNumber *key = [NSNumber numberWithInteger:self.index];
    return self.pages[key];
}

- (void)setBehavior:(MXPagerViewBehavior)behavior {
    _behavior = behavior;
    self.scrollEnabled = (behavior == MXPagerViewBehaviorSlide);
}
#pragma Private Methods

- (void) didScrollFromPosition:(NSInteger)fromPosition ToPosition:(NSInteger)toPosition {

    for (NSInteger index = 0; index < self.count; index++) {
        NSInteger boundary = self.frame.size.width * ((double)index + 0.5);
        
        if (fromPosition <= boundary && toPosition > boundary) {
            [self willMovePageToIndex:(index + 1)];
            break;
        }
        else if (fromPosition > boundary && toPosition <= boundary) {
            [self willMovePageToIndex:index];
            break;
        }
        else if (toPosition == (self.frame.size.width * index)) {
            self.index = index;
        }
    }
}

- (void) willMovePageToIndex:(NSInteger) index {
    if (index != self.index) {
        if ([self.delegate respondsToSelector:@selector(pagerView:willMoveToPageAtIndex:)]) {
            [self.delegate pagerView:self willMoveToPageAtIndex:index];
        }
        MXPagerViewLoadPage(index);
    }
}

- (void) loadPageAtIndex:(NSInteger) index {
    NSNumber *key = [NSNumber numberWithInteger:index];
    
    if (!self.pages[key] && (index >= 0) && (index < self.count)) {
        UIView *page = [self.dataSource pagerView:self viewForPageAtIndex:index];
        page.frame = (CGRect) {
            .origin.x   = self.frame.size.width * index,
            .origin.y   = 0.f,
            .size       = self.frame.size
        };
        [self addSubview:page];
        [self.pages setObject:page forKey:key];
    }
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kMXPagerViewKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
        CGPoint new = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [change[NSKeyValueChangeOldKey] CGPointValue];
        
        if (new.x != old.x) {
            [self didScrollFromPosition:old.x ToPosition:new.x];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

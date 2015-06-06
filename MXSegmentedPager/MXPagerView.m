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

#import <objc/runtime.h>
#import "MXPagerView.h"

@interface UIView (ReuseIdentifier)
@property (nonatomic, copy) NSString *reuseIdentifier;
@end

@implementation UIView (ReuseIdentifier)

- (NSString *)reuseIdentifier {
    return objc_getAssociatedObject(self, @selector(reuseIdentifier));
}

- (void)setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
}

@end

@interface MXPagerView ()
@property (nonatomic, strong) NSMutableDictionary *pages;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSMutableDictionary   *registration;
@property (nonatomic, strong) NSMutableArray        *reuseQueue;
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
        self.transitionStyle = MXPagerViewTransitionStyleScroll;
        
        self.index = 0;
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:kMXPagerViewKVOContext];
        
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))
                  options:0
                  context:kMXPagerViewKVOContext];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self reloadData];
}

- (void) reloadData {
    
    // Removes all current pages.
    for (NSNumber *key in self.pages) {
        UIView *page = self.pages[key];
        [page removeFromSuperview];
    }
    [self.pages removeAllObjects];
    
    self.count = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPagerView:)]) {
        self.count = [self.dataSource numberOfPagesInPagerView:self];
    }
    
    //Loads the current selected page
    [self loadPageAtIndex:self.index];
    
    self.contentSize = CGSizeMake(self.bounds.size.width * self.count, self.bounds.size.height);
}

- (void) showPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat x = self.frame.size.width * index;
    
    //The tab behavior disable animation
    animated = (self.transitionStyle == MXPagerViewTransitionStyleTab)? NO : animated;
    
    [self willMovePageToIndex:index];
    [self setContentOffset:CGPointMake(x, 0) animated:animated];
}

#pragma mark Reusable Pages

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier {
    [self.registration setValue:nib forKey:identifier];
}

- (void)registerClass:(Class)pageClass forPageReuseIdentifier:(NSString *)identifier {
    [self.registration setValue:NSStringFromClass(pageClass) forKey:identifier];
}

- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    
    for (UIView *page in self.reuseQueue) {
        if (!page.superview && [page.reuseIdentifier isEqualToString:identifier]) {
            return page;
        }
    }
    
    id builder = self.registration[identifier];
    UIView *page = nil;
    
    if ([builder isKindOfClass:[UINib class]]) {
        page = [[(UINib*)builder instantiateWithOwner:nil options:nil] firstObject];
    }
    else if ([builder isKindOfClass:[NSString class]]) {
        page = [[NSClassFromString(builder) alloc] init];
    }
    else {
        page = [[UIView alloc] init];
    }
    
    if (page) {
        page.reuseIdentifier = identifier;
        [self.reuseQueue addObject:page];
    }
    
    return page;
}

#pragma mark Properties

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    if ([self.delegate respondsToSelector:@selector(pagerView:didMoveToPageAtIndex:)]) {
        [self.delegate pagerView:self didMoveToPageAtIndex:index];
    }
    
    //The page did change, now unload hidden pages
    [self unLoadHiddenPages];
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

- (void)setTransitionStyle:(MXPagerViewTransitionStyle)transitionStyle {
    _transitionStyle = transitionStyle;
    //the tab behavior disable the scroll
    self.scrollEnabled = (transitionStyle != MXPagerViewTransitionStyleTab);
}

- (NSMutableDictionary *)registration {
    if (!_registration) {
        _registration = [NSMutableDictionary dictionary];
    }
    return _registration;
}

- (NSMutableArray *)reuseQueue {
    if (!_reuseQueue) {
        _reuseQueue = [NSMutableArray array];
    }
    return _reuseQueue;
}

#pragma Private Methods

- (void) didScrollFromPosition:(NSInteger)fromPosition ToPosition:(NSInteger)toPosition {
    
    if (!(toPosition % (NSInteger)self.bounds.size.width)) {
        //the page did change.
        self.index = toPosition / (NSInteger)self.bounds.size.width;
    }
    else {
        for (NSInteger index = 0; index < self.count; index++) {
            NSInteger boundary = self.frame.size.width * ((double)index + 0.5);
            
            //If it passes half the page, it tells the delegate that the page will change.
            if (fromPosition <= boundary && toPosition > boundary) {
                [self willMovePageToIndex:(index + 1)];
                break;
            }
            else if (fromPosition > boundary && toPosition <= boundary) {
                [self willMovePageToIndex:index];
                break;
            }
        }
    }
}

- (void) willMovePageToIndex:(NSInteger) index {
    if (index != self.index) {
        [self loadPageAtIndex:index];
        
        if ([self.delegate respondsToSelector:@selector(pagerView:willMoveToPageAtIndex:)]) {
            [self.delegate pagerView:self willMoveToPageAtIndex:index];
        }
    }
}

- (void) loadPageAtIndex:(NSInteger) index {
    
    void(^loadPage)(NSInteger index) = ^(NSInteger index) {
        NSNumber *key = [NSNumber numberWithInteger:index];
        
        if (!self.pages[key] && (index >= 0) && (index < self.count)) {
            
            if ([self.dataSource respondsToSelector:@selector(pagerView:viewForPageAtIndex:)]) {
                
                UIView *page = [self.dataSource pagerView:self viewForPageAtIndex:index];
                page.frame = (CGRect) {
                    .origin.x   = self.bounds.size.width * index,
                    .origin.y   = 0.f,
                    .size       = self.bounds.size
                };
                [self addSubview:page];
                [self.pages setObject:page forKey:key];
            }
        }
    };
    
    loadPage(index);
    
    //In  case of slide behavior, its loads the neighbors as well.
    if (self.transitionStyle == MXPagerViewTransitionStyleScroll) {
        loadPage(index - 1);
        loadPage(index + 1);
    }
}

- (void) unLoadHiddenPages {
    
    NSMutableArray *toUnLoad = [NSMutableArray array];
    
    for (NSNumber *key in self.pages) {
        NSInteger index = [key integerValue];
        
        if (index != self.index) {
            
            //In case if slide behavior, it keeps the neighbors, otherwise it unloads all hidden pages.
            if ((self.transitionStyle == MXPagerViewTransitionStyleTab) ||
                ( (index != self.index-1) && (index != self.index+1) )) {
                
                UIView *page = self.pages[key];
                [page removeFromSuperview];
                [toUnLoad addObject:key];
            }
        }
    }
    [self.pages removeObjectsForKeys:toUnLoad];
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kMXPagerViewKVOContext) {
        
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
            
            CGPoint new = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint old = [change[NSKeyValueChangeOldKey] CGPointValue];
            
            if (new.x != old.x) {
                [self didScrollFromPosition:old.x ToPosition:new.x];
            }
        }
        else if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            self.contentOffset = CGPointMake(self.index * self.bounds.size.width, 0);
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kMXPagerViewKVOContext];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) context:kMXPagerViewKVOContext];
}

@end

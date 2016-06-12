// MXPagerView.m
//
// Copyright (c) 2016 Maxime Epain
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

@interface MXContentView : UIScrollView <UIGestureRecognizerDelegate>
@end

@interface MXPagerView () <UIScrollViewDelegate>
@property (nonatomic, strong) MXContentView         *contentView;
@property (nonatomic, strong) NSMutableDictionary   *pages;

@property (nonatomic, strong) NSMutableDictionary   *registration;
@property (nonatomic, strong) NSMutableArray        *reuseQueue;
@end

@implementation MXPagerView {
    CGFloat     _index;
    NSInteger   _count;
}

- (void)layoutSubviews {
    if (_count <= 0) {
        [self reloadData];
    }
    
    CGRect frame = self.bounds;
    //Layout content view
    frame.origin = CGPointZero;
    frame.size.width += self.gutterWidth;
    self.contentView.frame = frame;
    
    CGSize size = self.bounds.size;
    size.width = frame.size.width * _count;
    self.contentView.contentSize = size;
    [self setContentIndex:_index animated:NO];
    
    //Layout loaded pages
    frame.size = self.bounds.size;
    for (NSNumber *key in self.pages) {
        UIView *page = self.pages[key];
        frame.origin.x = self.contentView.bounds.size.width * [key integerValue];
        page.frame = frame;
    }
    
    [super layoutSubviews];
}

- (void)reloadData {
    
    // Removes all current pages.
    for (NSNumber *key in self.pages) {
        UIView *page = self.pages[key];
        [page removeFromSuperview];
    }
    [self.pages removeAllObjects];
    
    //Updates index and loads the current selected page
    if ( (_count = [self.dataSource numberOfPagesInPagerView:self]) > 0) {
        if (_index >= _count)
            _index = _count-1;
        
        [self loadPageAtIndex:_index];
        [self setNeedsLayout];
    }
}

- (void)showPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index >= 0 && index < _count) {
        //The tab behavior disable animation
        animated = (self.transitionStyle == MXPagerViewTransitionStyleTab)? NO : animated;
        
        [self willMovePageToIndex:index];
        [self setContentIndex:index animated:animated];
        if(!animated) {
            [self didMovePageToIndex:index];
        }
    }
}

- (UIView *) pageAtIndex:(NSInteger)index {
    NSNumber *key = [NSNumber numberWithInteger:index];
    return self.pages[key];
}

#pragma mark Reusable Pages

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier {
    [self.registration setValue:nib forKey:identifier];
}

- (void)registerClass:(Class)pageClass forPageReuseIdentifier:(NSString *)identifier {
    [self.registration setValue:NSStringFromClass(pageClass) forKey:identifier];
}

- (UIView *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    
    for (UIView *page in self.reuseQueue) {
        if (!page.superview && [page.reuseIdentifier isEqualToString:identifier]) {
            return page;
        }
    }
    
    id builder = self.registration[identifier];
    NSAssert(builder, @"unable to dequeue a page with identifier %@ - must register a nib or a class for the identifier", identifier);
    
    UIView *page = nil;
    
    if ([builder isKindOfClass:[UINib class]]) {
        page = [[(UINib*)builder instantiateWithOwner:nil options:nil] firstObject];
    }
    else if ([builder isKindOfClass:[NSString class]]) {
        page = [[NSClassFromString(builder) alloc] init];
    }
    
    objc_setAssociatedObject(page, @selector(reuseIdentifier), identifier, OBJC_ASSOCIATION_COPY);
    [page prepareForReuse];
    
    return page;
}

#pragma mark Properties

- (MXContentView *)contentView {
    if (!_contentView) {
        _contentView = [[MXContentView alloc] init];
        _contentView.delegate = self;
        _contentView.scrollsToTop = NO;
        _contentView.pagingEnabled = YES;
        _contentView.directionalLockEnabled = YES;
        _contentView.alwaysBounceVertical = NO;
        _contentView.alwaysBounceHorizontal = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (NSMutableDictionary *)pages {
    if (!_pages) {
        _pages = [NSMutableDictionary dictionary];
    }
    return _pages;
}

- (UIView *)selectedPage {
    NSNumber *key = [NSNumber numberWithInteger:_index];
    return self.pages[key];
}

- (NSInteger)indexForSelectedPage {
    return _index;
}

- (void)setTransitionStyle:(MXPagerViewTransitionStyle)transitionStyle {
    _transitionStyle = transitionStyle;
    //the tab behavior disable the scroll
    self.contentView.scrollEnabled = (transitionStyle != MXPagerViewTransitionStyleTab);
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

- (void)setGutterWidth:(CGFloat)gutterWidth {
    _gutterWidth = gutterWidth;
    [self setNeedsLayout];
}

- (BOOL)isScrollEnabled {
    return [self.contentView isScrollEnabled];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.contentView.scrollEnabled = scrollEnabled;
}

- (NSArray<UIView *> *)loadedPages {
    return [self.pages allValues];
}

#pragma mark Private Methods

- (void)willMovePageToIndex:(NSInteger)index {
    [self loadPageAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(pagerView:willMoveToPageAtIndex:)]) {
        [self.delegate pagerView:self willMoveToPageAtIndex:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(pagerView:willHidePage:)]) {
        UIView *page = [self pageAtIndex:_index];
        [self.delegate pagerView:self willHidePage:page];
    }
    
    if ([self.delegate respondsToSelector:@selector(pagerView:willShowPage:)]) {
        UIView *page = [self pageAtIndex:index];
        [self.delegate pagerView:self willShowPage:page];
    }
}

- (void)didMovePageToIndex:(NSInteger)index {
    if (index != _index) {
        
        if ([self.delegate respondsToSelector:@selector(pagerView:didHidePage:)]) {
            UIView *page = [self pageAtIndex:_index];
            [self.delegate pagerView:self didHidePage:page];
        }
        
        _index = index;

        if ([self.delegate respondsToSelector:@selector(pagerView:didMoveToPageAtIndex:)]) {
            [self.delegate pagerView:self didMoveToPageAtIndex:index];
        }
        
        if ([self.delegate respondsToSelector:@selector(pagerView:didShowPage:)]) {
            UIView *page = [self pageAtIndex:index];
            [self.delegate pagerView:self didShowPage:page];
        }
                
        //The page did change, now unload hidden pages
        [self unLoadHiddenPages];
    }
}

- (void)loadPageAtIndex:(NSInteger)index {
    
    void(^loadPage)(NSInteger index) = ^(NSInteger index) {
        NSNumber *key = [NSNumber numberWithInteger:index];
        
        if (!self.pages[key] && (index >= 0) && (index < _count)) {
            
            //Load page
            UIView *page = [self.dataSource pagerView:self viewForPageAtIndex:index];
            
            //Layout page
            CGRect frame = self.bounds;
            frame.origin = CGPointMake(self.contentView.bounds.size.width * index, 0);
            page.frame = frame;
            
            if ([self.delegate respondsToSelector:@selector(pagerView:willLoadPage:)]) {
                [self.delegate pagerView:self willLoadPage:page];
            }
            
            [self.contentView addSubview:page];
            
            //Save page
            [self.pages setObject:page forKey:key];
            if (page.reuseIdentifier) {
                [self.reuseQueue addObject:page];
            }
            
            if ([self.delegate respondsToSelector:@selector(pagerView:didLoadPage:)]) {
                [self.delegate pagerView:self didLoadPage:page];
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

- (void)unLoadHiddenPages {
    
    NSMutableArray *toUnLoad = [NSMutableArray array];
    
    for (NSNumber *key in self.pages) {
        NSInteger index = [key integerValue];
        
        if (index != _index) {
            
            //In case if slide behavior, it keeps the neighbors, otherwise it unloads all hidden pages.
            if ((self.transitionStyle == MXPagerViewTransitionStyleTab) ||
                ( (index != _index-1) && (index != _index+1) )) {
                
                UIView *page = self.pages[key];
                
                if ([self.delegate respondsToSelector:@selector(pagerView:willUnloadPage:)]) {
                    [self.delegate pagerView:self willUnloadPage:page];
                }
                
                [page removeFromSuperview];
                [toUnLoad addObject:key];
                
                if ([self.delegate respondsToSelector:@selector(pagerView:didUnloadPage:)]) {
                    [self.delegate pagerView:self didUnloadPage:page];
                }
            }
        }
    }
    [self.pages removeObjectsForKeys:toUnLoad];
}

- (void)setContentIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat x = self.contentView.bounds.size.width * index;
    [self.contentView setContentOffset:CGPointMake(x, 0) animated:animated];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger position  = scrollView.contentOffset.x;
    NSInteger width     = scrollView.bounds.size.width;
    
    NSInteger index = position / width;
    if (index >= 0) {
        [self didMovePageToIndex:index];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger position  = targetContentOffset->x;
    NSInteger width     = scrollView.bounds.size.width;
    
    NSInteger index = position / width;
    if (index >= 0) {
        [self willMovePageToIndex:index];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger position  = scrollView.contentOffset.x;
    NSInteger width     = scrollView.bounds.size.width;
    
    if (!(position % width)) {
        [self didMovePageToIndex:(position / width)];
    }
}

@end

@implementation UIView (ReuseIdentifier)

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self init]) {
        objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self initWithFrame:frame]) {
        objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self initWithCoder:aDecoder]) {
        objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (NSString *)reuseIdentifier {
    return objc_getAssociatedObject(self, @selector(reuseIdentifier));
}

- (void)prepareForReuse {
    
}

@end

@implementation MXContentView

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
        
        //Lock vertical pan gesture.
        if (fabs(velocity.x) < fabs(velocity.y)) {
            return NO;
        }
    }
    return YES;
}

@end

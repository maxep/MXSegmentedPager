//
//  MXSegmentedPager.m
//  Pods
//
//  Created by Maxime Epain on 25/02/2015.
//
//

#import "MXSegmentedPager.h"

static void * kMXScrollViewObservationContext = &kMXScrollViewObservationContext;
static NSString * const kMXScrollViewContentOffsetKeyPath = @"contentOffset";

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface MXSegmentedPager () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation MXSegmentedPager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    CGRect frame = (CGRect) {
        .origin = CGPointZero,
        .size.width = self.frame.size.width,
        .size.height = 44.f
    };
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:frame];
    [self.segmentedControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segmentedControl];
    
    frame = (CGRect) {
        .origin.x = 0.f,
        .origin.y = frame.size.height,
        .size.width = self.frame.size.width,
        .size.height = self.frame.size.height - frame.size.height
    };
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
//    [self.scrollView addObserver:self
//                  forKeyPath:kMXScrollViewContentOffsetKeyPath
//                     options:NSKeyValueObservingOptionNew
//                     context:kMXScrollViewObservationContext];
    
    [self addSubview:self.scrollView];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect subFrame = (CGRect) {
        .origin = CGPointZero,
        .size.width = self.frame.size.width,
        .size.height = 44.f
    };
    self.segmentedControl.frame = subFrame;
    
    subFrame = (CGRect) {
        .origin.x = 0.f,
        .origin.y = subFrame.size.height,
        .size.width = self.frame.size.width,
        .size.height = self.frame.size.height - subFrame.size.height
    };
    self.scrollView.frame = subFrame;
}

- (void) setPages:(NSDictionary *)pages {
    _pages = pages;
    CGFloat width = 0.f;
    for (NSString* title in pages) {
        
        UIView* view = [pages objectForKey:title];
        [self.scrollView addSubview:view];
        
        CGRect frame = (CGRect) {
            .origin.x = view.frame.origin.x + width,
            .origin.y = view.frame.origin.y,
            .size = view.frame.size
        };
        view.frame = frame;
        width += view.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(width, self.frame.size.height);
    
    self.segmentedControl.sectionTitles = [pages allKeys];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kMXScrollViewObservationContext && [keyPath isEqualToString:kMXScrollViewContentOffsetKeyPath]) {

//        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
//        CGPoint currentOffset = self.scrollView.l;
//            
//        CGFloat x = 0.f;
//        NSArray* keys = [self.pages allKeys];
//        NSInteger index = 1;
//            
////        for (; x >= contentOffset.x; index++) {
////           
////            NSString* key = [keys objectAtIndex:index];
////            UIView* upView = [self.pages objectForKey:key];
////            
////            x += upView.frame.size.width;
////        }
//        [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma -mark segmentedControl target
- (void)pageControlValueChanged:(id)sender {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    CGFloat x = 0.f;
    NSArray* keys = [self.pages allKeys];
    
    for (NSInteger i = 0; i < index; ++i) {
        NSString* key = [keys objectAtIndex:i];
        UIView* view = [self.pages objectForKey:key];
        
        x += view.frame.size.width;
    }

//    CGFloat y = self.scrollView.contentOffset.y;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    ScrollDirection scrollDirection = ScrollDirectionNone;
    if (self.lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionRight;
    else if (self.lastContentOffset < scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionLeft;
    self.lastContentOffset = scrollView.contentOffset.x;
    
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    
    if (scrollDirection == ScrollDirectionLeft) {
        index++;
        
        if (index > 0 && index < self.pages.count) {
            NSString* key = [[self.pages allKeys] objectAtIndex:index];
            UIView* view = [self.pages objectForKey:key];
            
            if (view.frame.origin.x > scrollView.contentOffset.x) {
                [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
            }
        }
    }
    else if (scrollDirection == ScrollDirectionRight) {
        index--;
        
        if (index >= 0 && index < self.pages.count) {
            NSString* key = [[self.pages allKeys] objectAtIndex:index];
            UIView* view = [self.pages objectForKey:key];
            
            if (view.frame.origin.x < scrollView.contentOffset.x) {
                [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
            }
        }
    }
}
@end

//
//  HFPageView.m
//  HFFoundation
//
//  Created by HeHongling on 11/8/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "HFPageView.h"
#import <objc/runtime.h>

@interface HFPageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *frontCV, *curCV, *behindCV;
@property (nonatomic, assign) BOOL initialize; ///< 是否初始化了三个contentView
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Class contentViewClass; ///< 内容视图class

@end

@implementation HFPageView

#pragma mark- lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame contentClass:[UIView class]];
}

- (instancetype)initWithContentClass:(Class)contentClass {
    return [self initWithFrame:CGRectZero contentClass:contentClass];
}

- (instancetype)initWithFrame:(CGRect)frame contentClass:(Class)contenClass {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.contentViewClass = contenClass;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        scrollView;
    });
    [self addSubview:_scrollView];
    
    _frontCV = [self contentViewForDisplay];
    [self.scrollView addSubview:_frontCV];
    
    _curCV = [self contentViewForDisplay];
    [self.scrollView addSubview:_curCV];
    
    _behindCV = [self contentViewForDisplay];
    [self.scrollView addSubview:_behindCV];
}

- (UIView *)contentViewForDisplay {
    UIView *CV = [[self.contentViewClass alloc] init];
    CV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTappedAction:)];
    [CV addGestureRecognizer:tap];
    return CV;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;

    if (_initialize == NO) {
        self.frontCV.frame = CGRectMake(0* self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        self.curCV.frame = CGRectMake(1* self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        self.behindCV.frame = CGRectMake(2* self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self reloadData];
        _initialize = YES;
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark- action handle

- (void)itemTappedAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectedItemAtIndex:)]) {
        [self.delegate pageView:self didSelectedItemAtIndex:self.curPage];
    }
}

- (void)timerFireAction:(NSTimer *)timer {
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(2* self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}


#pragma mark- UIScrollViewDelegate

///MARK: 拖动时停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

///MARK: 停止拖动，开始定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

///MARK: 停止滚动时，计算页面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    if (offsetX >= 1.5 * self.frame.size.width) {
        self.curPage = self.curPage + 1;
    } else if (offsetX <= 0.5 * self.frame.size.width) {
        self.curPage--;
    }
    
    [self refreshDisplay];
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

#pragma mark- public M

///MARK: 更新数据
- (void)reloadData {
    self.numberOfPages = [self.dataSource numberOfItemInPageView:self];
    self.scrollInterval = self.scrollInterval?: 2;
    self.curPage = self.defalutPage?: 0;
    
    if (self.numberOfPages <= 0) {
        return;
    } else if (self.numberOfPages == 1 && self.stopForSinglePage == YES) {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        self.scrollView.contentSize = CGSizeMake(3* self.frame.size.width, self.frame.size.height);
        self.scrollView.contentOffset = CGPointMake(1* self.frame.size.width, 0);
    }
    
    [self refreshDisplay];
    [self setupTimer];
}

#pragma mark- private M

///MARK: 设置定时器
- (void)setupTimer {
    [self.timer invalidate];
    if (self.autoScroll == NO
        || (self.stopForSinglePage == YES && self.numberOfPages == 1)) {
        return;
    }
    
    _timer = [NSTimer timerWithTimeInterval:self.scrollInterval target:self selector:@selector(timerFireAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

///MARK: 更新图片
- (void)refreshDisplay {
    NSInteger frontPage = (self.numberOfPages+ self.curPage - 1) % self.numberOfPages;
    NSInteger behindPage = (self.curPage + 1) % self.numberOfPages;
    
    [self.dataSource configContentView:self.frontCV forItemAtIndex:frontPage];
    [self.dataSource configContentView:self.curCV forItemAtIndex:self.curPage];
    [self.dataSource configContentView:self.behindCV forItemAtIndex:behindPage];
    
    if ([self.delegate respondsToSelector:@selector(pageView:didDisplayItemAtIndex:)]) {
        [self.delegate pageView:self didDisplayItemAtIndex:self.curPage];
    }
}

#pragma mark- setter & getter

- (void)setCurPage:(NSInteger)curPage {
    _curPage = (self.numberOfPages+ curPage) % self.numberOfPages;
}

- (void)setContentViewClass:(Class)contentViewClass {
    _contentViewClass = contentViewClass;
    NSAssert(![contentViewClass.self isKindOfClass:[UIView class]], @"contentViewClass must inherit UIView");
}

@end


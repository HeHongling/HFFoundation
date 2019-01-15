//
//  HFSlideMenu.m
//  HFFoundation
//
//  Created by HeHongling on 10/11/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "HFSlideMenu.h"
#import "UIView+HFFoundation.h"

static CGFloat const minMargin = 15;
static CGFloat const indicatorHeight = 3;

@interface HFSlideMenu ()
/*
 fdfdfdk
 */
@property (nonatomic, assign) CGFloat labelMargin; ///< label间距
@property (nonatomic, assign) NSInteger numberOfItems; ///< label 数量
@property (nonatomic, assign) CGFloat totalWidth; ///< width 之和
@property (nonatomic, strong) UIView *lineView; ///< 灰色横线
@property (nonatomic, strong) UIView *indicatorView; ///< 指示器
@property (nonatomic, strong) UIScrollView *scrollView; ///< 容器
@property (nonatomic, strong) UILabel *selectedLabel; ///< 当前选中的label
@property (nonatomic, strong) NSMutableArray *labels; ///< label数组
@property (nonatomic, strong) NSMutableArray *widths; ///< label宽度数组
@property (nonatomic, assign) BOOL didReload; ///< 是否加载了数据
@property (nonatomic, assign) BOOL didInitialize; ///< 是否进行了初始化

@end


@implementation HFSlideMenu

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self setupSubviews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.lineView];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.indicatorView];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    
    // 第一次加载到窗口，主动调用ReloadData
    if (!_didReload) {
        [self reloadData];
        return;
    }
    
    // 在加载到窗口之前主动调用了ReloadData，则进行默认选中
    if (!_didInitialize && [self.dataSource numberOfItemsInSlideMenu:self] != 0) {
        [self selectLabelAtIndex:0];
        _didInitialize = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.frame.size.height- 1, self.frame.size.width, 1);
    [self layoutLabels];
}

#pragma mark- public M

- (void)reloadData {
    // 1. 移除之前所有的label
    [self.labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.labels removeAllObjects];
    self.widths = [NSMutableArray array];
    self.totalWidth = 0;
    
    // 1.1 验证有无数据
    _numberOfItems = [self.dataSource numberOfItemsInSlideMenu:self];
    if (_numberOfItems == 0) {
        return;
    }
    
    // 1.2 更新设置信息
    self.titleFont = self.titleFont?: [UIFont systemFontOfSize:19];
    self.norColor = self.norColor?: [UIColor blackColor];
    self.selColor = self.selColor?: [UIColor redColor];
    
    self.indicatorView.backgroundColor = self.selColor;
    
    self.didInitialize = NO;
    
    // 2. 重新添加所有label
    for (NSUInteger i = 0; i < _numberOfItems; i++) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.textColor = self.norColor;
        titleLable.highlightedTextColor = self.selColor;
        titleLable.font = self.titleFont;
        titleLable.text = [self.dataSource slideMenu:self titleForItemAtIndex:i];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.tag = i;
        titleLable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelDidClick:)];
        [titleLable addGestureRecognizer:tap];
        
        CGFloat labelW = [self labelWidthWithMaxHeight:CGFLOAT_MAX Text:titleLable.text];
        self.totalWidth += labelW;
        [self.widths addObject:@(labelW)];
        
        [self.scrollView addSubview:titleLable];
        [self.labels addObject:titleLable];
    }
    
    // 3. 重新布局
    [self layoutLabels];
    
    // 4. 默认选中
    if (self.window) {
        [self selectLabelAtIndex:0];
        _didInitialize = YES;
    }
    
    // 5. 设置flag
    _didReload = YES;
}

- (void)layoutLabels {
    if (self.labels.count == 0) {
        return;
    }

    _labelMargin = MAX(minMargin, (self.frame.size.width - _totalWidth) / _numberOfItems);
    
    CGFloat labelX = _labelMargin * 0.5;
    CGFloat labelY = 0;
    CGFloat labelH = self.frame.size.height - indicatorHeight;
    CGFloat labelW;
    for (NSUInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        labelW = [self.widths[i] floatValue];
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        labelX += labelW + _labelMargin;
    }

    self.scrollView.contentSize = CGSizeMake(labelX- _labelMargin * 0.5, self.frame.size.height);

    UILabel *firstLabel = self.labels[0];
    CGFloat indicatorW = firstLabel.hf_width + _labelMargin;
    CGFloat indicatorH = indicatorHeight;
//    CGFloat indicatorX = firstLabel.hf_x;
    CGFloat indicatorY = self.hf_height - indicatorH;
    self.indicatorView.frame = CGRectMake(0, indicatorY, indicatorW, indicatorH);
}

- (void)reloadItemAtIndex:(NSInteger)index {
    UILabel *label = self.labels[index];
    label.text = [self.dataSource slideMenu:self titleForItemAtIndex:index];;
}

#pragma mark- event handling

- (void)titleLabelDidClick:(UITapGestureRecognizer *)tap {
    UILabel *selLabel = (UILabel *)tap.view;
    [self selectLabelAtIndex:selLabel.tag];
}

- (void)selectLabelAtIndex:(NSInteger)index {
    UILabel *selLabel = self.labels[index];
    
    // change label color
    _selectedLabel.highlighted = NO;
    selLabel.highlighted = YES;
    _selectedLabel = selLabel;
    
    // indicatorView
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.hf_width = selLabel.hf_width + _labelMargin;
        self.indicatorView.hf_centerX = selLabel.hf_centerX;
    }];

    // make selLabel center
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetX = selLabel.center.x - screenW * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.frame.size.width;
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    offsetX = MIN(offsetX, maxOffsetX);
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    // inform delegate
    if ([self.delegate respondsToSelector:@selector(slideMenu:didSelectedItemAtIndex:)]) {
        [self.delegate slideMenu:self didSelectedItemAtIndex:index];
    }
}



#pragma mark- privateM

- (CGFloat)labelWidthWithMaxHeight:(CGFloat)height Text:(NSString *)text {
    CGRect labelBounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.titleFont}
                                            context:nil];
    
    return labelBounds.size.width;
}

#pragma mark- setter & getter

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}

- (NSMutableArray *)labels {
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

@end

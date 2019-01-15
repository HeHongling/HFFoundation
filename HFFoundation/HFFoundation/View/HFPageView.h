//
//  HFPageView.h
//  HFFoundation
//
//  Created by HeHongling on 11/8/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

/**
 待修改，将 pageContentView 使用注册类方式传入
 */

#import <UIKit/UIKit.h>
@class HFPageContentView, HFPageView;

@protocol HFPageViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemInPageView:(HFPageView *)pageView;
- (void)configContentView:(UIView *)contentView forItemAtIndex:(NSInteger)index;

@end


@protocol HFPageViewDelegate <NSObject>

@optional
- (void)pageView:(HFPageView *)pageView didDisplayItemAtIndex:(NSInteger)index;
- (void)pageView:(HFPageView *)pageView didSelectedItemAtIndex:(NSInteger)index;

@end


@interface HFPageView : UIView

@property (nonatomic, weak) id<HFPageViewDataSource> dataSource; ///< 数据源
@property (nonatomic, weak) id<HFPageViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoScroll; ///< 是否自动滚动
@property (nonatomic, assign) NSTimeInterval scrollInterval; ///< 自动滚动时间间隔
@property (nonatomic, assign) BOOL stopForSinglePage; ///< 单独一页时是否滚动
@property (nonatomic, assign) NSInteger defalutPage;

- (instancetype)initWithContentClass:(Class)contentClass;
- (instancetype)initWithFrame:(CGRect)frame contentClass:(Class)contenClass;

- (void)reloadData;

@end


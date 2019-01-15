//
//  HFSlideMenu.h
//  HFFoundation
//
//  Created by HeHongling on 10/11/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Attention:
 self.automaticallyAdjustsScrollViewInsets = NO;
 */

typedef NS_ENUM(NSInteger, HFSlideMenuAlignment) {
    HFSlideMenuAlignmentLeft,
    HFSlideMenuAlignmentDistribute,
};

@class HFSlideMenu;

@protocol HFSlideMenuDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInSlideMenu:(HFSlideMenu *)slideMenu;
- (NSString *)slideMenu:(HFSlideMenu *)slideMenu titleForItemAtIndex:(NSInteger)index;

@end


@protocol HFSlideMenuDelegate <NSObject>

@optional
- (void)slideMenu:(HFSlideMenu *)slideMenu didSelectedItemAtIndex:(NSInteger)index;

@end


@interface HFSlideMenu : UIView

@property (nonatomic, weak) IBOutlet id<HFSlideMenuDataSource> dataSource; ///< 数据源
@property (nonatomic, weak) IBOutlet id<HFSlideMenuDelegate> delegate; ///< 代理
@property (nonatomic, strong) UIColor *selColor; ///< 选中颜色
@property (nonatomic, strong) UIColor *norColor; ///< 非选中颜色
@property (nonatomic, strong) UIFont *titleFont; ///< 标题字体

/**
 *  更新数据
 */
- (void)reloadData;

/**
 *  刷新其中一项标题
 *
 *  @param index 待刷新的序号
 */
- (void)reloadItemAtIndex:(NSInteger)index;

/**
 *  选中某一个label
 *
 *  @param index <#index description#>
 */
- (void)selectLabelAtIndex:(NSInteger)index;

@end

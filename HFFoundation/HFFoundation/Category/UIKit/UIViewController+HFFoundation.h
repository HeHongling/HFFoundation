//
//  UIViewController+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 11/1/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (HFFoundation)

///MARK: 当前显示 view 的 controller
+ (instancetype _Nullable )hf_topViewController;


/// 返回到上一个控制器
- (BOOL)hf_backToPreviousControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

@end

//
//  UIViewController+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 11/1/16.
//
//

#import "UIViewController+HFFoundation.h"

@implementation UIViewController (HFFoundation)

+ (instancetype)hf_topViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}


+(UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (BOOL)hf_backToPreviousControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion {
    
    if (self.navigationController) {
        if ([self.navigationController.viewControllers[0] isEqual:self]) { // root view controller
            return [self.navigationController hf_backToPreviousControllerAnimated:flag completion:completion];
        } else {
            [self.navigationController popViewControllerAnimated:flag];
            if (completion) {completion();}
            return YES;
        }
    } else {
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:completion];
            return YES;
        } else {
            return NO;
        }
    }
}

@end

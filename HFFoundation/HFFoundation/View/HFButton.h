//
//  HFButton.h
//  HFFoundation
//
//  Created by HeHongling on 11/15/16.
//
//

#import <UIKit/UIKit.h>

@interface HFButton : UIButton

@end


@interface HFButton (StateBackgroundColor)

- (void)hf_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)hf_backgroundColorForState:(UIControlState)state;

@end

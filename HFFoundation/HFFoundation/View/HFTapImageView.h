//
//  HFTapImageView.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapAction)(id obj);

@interface HFTapImageView : UIImageView

- (void)addTapBlock:(tapAction)tapAction;

@end

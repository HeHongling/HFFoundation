//
//  HFTapImageView.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "HFTapImageView.h"

@interface HFTapImageView ()

@property (nonatomic, copy) tapAction tapAction; ///< 点击回调

@end


@implementation HFTapImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.userInteractionEnabled = YES;
    return self;
}

- (void)addTapBlock:(tapAction)tapAction {
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    if (self.tapAction) {
        self.tapAction(self);
    }
}

@end

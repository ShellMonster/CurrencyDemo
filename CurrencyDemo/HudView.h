//
//  HudView.h
//  CurrencyDemo
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionBlock)();

@interface HudView : UIView

- (void)setHudViewImage:(UIImage *)image text:(NSString *)text;
- (void)dismissHudViewAfterDelay:(double) seconds completion:(completionBlock) block;

@end

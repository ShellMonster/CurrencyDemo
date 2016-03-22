//
//  HudView.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "HudView.h"

@interface HudView ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation HudView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 绘制框型
    CGRect boxRect = CGRectMake(rect.size.width / 2 - 50, rect.size.height / 2 - 50, 100, 100);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:10];
    UIColor *fillColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    [fillColor setFill];
    [path fill];
    
    // 绘制示意图
    if (_image != nil) {
        CGPoint imagePoint = CGPointMake(self.center.x - _image.size.width / 2 , self.center.y - _image.size.height / 2 - 10);
        [_image drawAtPoint:imagePoint];
        // 把圈圈隐藏起来
        [_indicator stopAnimating];
        [_indicator setHidden:YES];
    }
    
    // 绘制文字
    NSDictionary *attribs = @{
                              NSFontAttributeName: [UIFont systemFontOfSize:16],
                              NSForegroundColorAttributeName: [UIColor whiteColor]
                              };
    CGSize textSize = [_text sizeWithAttributes:attribs];
    CGPoint textPoint = CGPointMake(self.center.x - textSize.width / 2, self.center.y + 20);
    [_text drawAtPoint:textPoint withAttributes:attribs];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.center.x - 25, self.center.y - 25 - 10, 50, 50)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:_indicator];
        [_indicator startAnimating];
        
        _text = @"Loading...";
    }
    return self;
}

// 设置示意图和文字，若image为nil，则显示圈圈
- (void)setHudViewImage:(UIImage *)image text:(NSString *)text {
    _image = image;
    _text = text;
}

// 消失hudView
- (void)dismissHudViewAfterDelay:(double)seconds completion:(completionBlock)block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        if (block != nil) {
            block();
        }
    });
}


@end








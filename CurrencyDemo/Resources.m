//
//  Resources.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "Resources.h"

@implementation Resources

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"list.resources": @"currencyArray"
                                 }];
}

@end

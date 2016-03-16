//
//  Currency.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "Currency.h"

@implementation Currency

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"resource.fields.symbol": @"name",
                                 @"resource.fields.price": @"price",
                                 }];
}

@end

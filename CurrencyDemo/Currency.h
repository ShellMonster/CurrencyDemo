//
//  Currency.h
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "JSONModel.h"

@protocol Currency

@end

@interface Currency : JSONModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) double price;
@property (strong, nonatomic) NSString<Optional> *fullName;
@property (strong, nonatomic) NSString<Optional> *chineseName;

@end

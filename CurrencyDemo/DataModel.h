//
//  DataModel.h
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Resources;
@class Currency;

@interface DataModel : NSObject

@property (strong, nonatomic) Resources *resources;
@property (strong, nonatomic) NSMutableArray *displayArray;

+ (id)sharedInstance;

- (void)startFetchData;
- (void)addDisplayCurrencyName:(NSString *)name;
- (void)removeDisplayCurrencyName:(NSString *)name;

@end

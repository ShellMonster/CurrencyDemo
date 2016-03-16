//
//  Resources.h
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "JSONModel.h"

#import "Currency.h"

@interface Resources : JSONModel

@property (strong, nonatomic) NSArray<Currency> *currencyArray;

@end

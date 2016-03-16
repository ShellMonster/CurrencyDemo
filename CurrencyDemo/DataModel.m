//
//  DataModel.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "DataModel.h"

#import "Resources.h"
#import "Currency.h"

#import <AFNetworking.h>

@implementation DataModel

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    static DataModel *instant = nil;
    dispatch_once(&onceToken, ^{
        instant = [[DataModel alloc] init];
    });
    return instant;
}

- (instancetype)init {
    if (self = [super init]) {
        _displayArray = [[NSMutableArray alloc] initWithCapacity:200];
    }
    return self;
}

- (void)startFetchData {
    // Weak-strong dance
    __weak typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:@"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // Weak-strong dance
             typeof(weakSelf) strongSelf = weakSelf;
             NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:responseObject];
             [strongSelf manageData:dic];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@", error);
         }];
}

- (void)manageData:(NSDictionary *)dic {
    self.resources = [[Resources alloc] initWithDictionary:dic error:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Names" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *namesDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (Currency *tempCurrency in self.resources.currencyArray) {
        NSRange range = NSMakeRange(0, 3);
        NSString *name = [tempCurrency.name substringWithRange:range];
        tempCurrency.name = name;
        
        NSArray *array = namesDic[tempCurrency.name];
        tempCurrency.fullName = array[0];
        tempCurrency.chineseName = array[1];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataDone" object:nil userInfo:nil];
}

- (void)addDisplayCurrencyName:(NSString *)name {
    // 防止多线程重复添加
    @synchronized(self) {
        if ([_displayArray indexOfObject:name] == NSNotFound) {
            [_displayArray addObject:name];
        }
    }
}

- (void)removeDisplayCurrencyName:(NSString *)name {
    // 防止多线程多次删除
    @synchronized(self) {
        if ([_displayArray indexOfObject:name] != NSNotFound) {
            [_displayArray removeObject:name];
        }
    }
}

@end













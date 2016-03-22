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

@interface DataModel ()

@end

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
        _allCurrencyDic = [[NSMutableDictionary alloc] initWithCapacity:200];
        [self loadDisplay];
        [self initLocalData];
    }
    return self;
}

// 读取文件
- (void)loadDisplay {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Data.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _displayArray = [unarchiver decodeObjectForKey:@"displayArray"];
        [unarchiver finishDecoding];
    }
}

// 保存文件
- (void)saveDisplay {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Data.plist"];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:300];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_displayArray forKey:@"displayArray"];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

- (void)initLocalData {
    // 初始化本地数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Names" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *namesDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *tempArray = [[NSArray alloc] initWithArray:[namesDic allKeys] copyItems:YES];
    _namesArray = [tempArray sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    _fullNamesArray = [[NSMutableArray alloc] initWithCapacity:200];
    _chineseNamesArray = [[NSMutableArray alloc] initWithCapacity:200];
    
    for (NSString *name in _namesArray) {
        NSArray *array = namesDic[name];
        [_fullNamesArray addObject:array[0]];
        [_chineseNamesArray addObject:array[1]];
    }
}

- (void)startFetchData {
    // Weak-strong dance
    __weak typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 7.0;
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
    Resources *resources = [[Resources alloc] initWithDictionary:dic error:nil];
    
    // 设置货币中文名称和英文全称
    for (Currency *tempCurrency in resources.currencyArray) {
        NSRange range = NSMakeRange(0, 3);
        NSString *name = [tempCurrency.name substringWithRange:range];
        tempCurrency.name = name;
        
        NSUInteger index = [_namesArray indexOfObject:name];
        if (index != NSNotFound) {
            tempCurrency.fullName = _fullNamesArray[index];
            tempCurrency.chineseName = _chineseNamesArray[index];
        }
        
        [_allCurrencyDic setObject:tempCurrency forKey:name];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataDone" object:nil userInfo:nil];
}

// 添加自选货币，name是货币缩写
- (void)addDisplayCurrencyName:(NSString *)name {
    // 防止多线程重复添加
    @synchronized(self) {
        if ([_displayArray indexOfObject:name] == NSNotFound) {
            [_displayArray addObject:name];
        }
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:name forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Add" object:self userInfo:userInfo];
    [self saveDisplay];
}

// 删除自选货币，name是货币缩写
- (void)removeDisplayCurrencyName:(NSString *)name {
    // 防止多线程多次删除
    @synchronized(self) {
        if ([_displayArray indexOfObject:name] != NSNotFound) {
            [_displayArray removeObject:name];
        }
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:name forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Remove" object:self userInfo:userInfo];
    [self saveDisplay];
}

@end













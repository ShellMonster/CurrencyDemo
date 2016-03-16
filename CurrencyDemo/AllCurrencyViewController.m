//
//  AllCurrencyViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/16.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "AllCurrencyViewController.h"

#import "DataModel.h"

@interface AllCurrencyViewController ()

@property (strong, nonatomic) NSArray *namesArray;
@property (strong, nonatomic) NSMutableArray *fullNamesArray;
@property (strong, nonatomic) NSMutableArray *chineseNamesArray;

@end

@implementation AllCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _namesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell" forIndexPath:indexPath];
    
    // 设置Cell属性
    UIImageView *imageView = [cell viewWithTag:200];
    [imageView setImage:[UIImage imageNamed:_namesArray[indexPath.row]]];
    
    UILabel *nameLabel = [cell viewWithTag:201];
    nameLabel.text = _namesArray[indexPath.row];
    
    UILabel *chineseNameLabel = [cell viewWithTag:202];
    chineseNameLabel.text = _chineseNamesArray[indexPath.row];
    
    UILabel *fullNameLabel = [cell viewWithTag:203];
    fullNameLabel.text = _fullNamesArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end











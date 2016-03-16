//
//  MyChoiceViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "MyChoiceViewController.h"

#import "DataModel.h"

@interface MyChoiceViewController ()

@property (strong, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) NSMutableArray *displayingArray;
@property (strong, nonatomic) NSArray *fullNamesArray;
@property (strong, nonatomic) NSArray *chineseNamesArray;

@end

@implementation MyChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // DataModel单例
    _dataModel = [DataModel sharedInstance];
    
    // 自选数组
    _displayingArray = [[NSMutableArray alloc] initWithArray:_dataModel.displayArray copyItems:YES];
    
    _fullNamesArray = [NSArray arrayWithArray:_dataModel.fullNamesArray];
    _chineseNamesArray = [NSArray arrayWithArray:_dataModel.chineseNamesArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChoiceCell" forIndexPath:indexPath];
    
    // 设置Cell
    NSString *name = _displayingArray[indexPath.row];
    
    UIImageView *imageView = [cell viewWithTag:100];
    [imageView setImage:[UIImage imageNamed:name]];
    
    UILabel *nameLabel = [cell viewWithTag:101];
    nameLabel.text = name;
    
    UILabel *chineseNameLabel = [cell viewWithTag:102];
    chineseNameLabel.text = _chineseNamesArray[indexPath.row];
    
    UILabel *fullNameLabel = [cell viewWithTag:103];
    fullNameLabel.text = _fullNamesArray[indexPath.row];
    
    return cell;
}

@end











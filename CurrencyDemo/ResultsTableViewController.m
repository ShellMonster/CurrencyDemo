//
//  ResultsTableViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/24.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ResultsTableViewController.h"

#import "DataModel.h"

@interface ResultsTableViewController ()

@property (strong, nonatomic) DataModel *dataModel;

@end

@implementation ResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 用于存放搜索结果
    _resultsArray = [NSMutableArray arrayWithCapacity:200];
    
    _dataModel = [DataModel sharedInstance];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsCell" forIndexPath:indexPath];
    
    NSString *result = _resultsArray[indexPath.row];
    NSInteger index = [_dataModel.namesArray indexOfObject:result];
    
    UIImageView *imageView = [cell viewWithTag:300];
    [imageView setImage:[UIImage imageNamed:result]];
    
    UILabel *nameLabel = [cell viewWithTag:301];
    nameLabel.text = result;
    
    UILabel *chineseNameLabel = [cell viewWithTag:302];
    chineseNameLabel.text = _dataModel.chineseNamesArray[index];
    
    UILabel *fullNameLabel = [cell viewWithTag:303];
    fullNameLabel.text = _dataModel.fullNamesArray[index];
    
    UIView *maskView = [cell viewWithTag:304];
    if ([_dataModel.displayArray indexOfObject:result] != NSNotFound) {
        maskView.alpha = 0.5;
        cell.userInteractionEnabled = NO;
    } else {
        maskView.alpha = 0;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *maskView = [cell viewWithTag:304];
    maskView.alpha = 0.5;
    cell.userInteractionEnabled = NO;
    
    NSString *displayCurrencyName = _resultsArray[indexPath.row];
    [_dataModel addDisplayCurrencyName:displayCurrencyName];
}

- (void)dealloc {
    
}

@end











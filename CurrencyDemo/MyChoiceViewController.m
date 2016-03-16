//
//  MyChoiceViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "MyChoiceViewController.h"

#import "DataModel.h"
#import "Currency.h"
#import "Resources.h"

@interface MyChoiceViewController ()

@property (strong, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) NSArray *displayingArray;
@property (strong, nonatomic) NSArray *fullNamesArray;
@property (strong, nonatomic) NSArray *chineseNamesArray;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) NSMutableDictionary *textFieldDic;

@end

@implementation MyChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // DataModel单例
    _dataModel = [DataModel sharedInstance];
    
    // 自选数组
    _displayingArray = [[NSArray alloc] initWithArray:_dataModel.displayArray copyItems:NO];
    
    _fullNamesArray = [NSArray arrayWithArray:_dataModel.fullNamesArray];
    _chineseNamesArray = [NSArray arrayWithArray:_dataModel.chineseNamesArray];
    
    // 注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCurrencyChangeWithUserInfo:) name:@"Add" object:nil];
    
    UIView *blankView = [[UIView alloc] init];
    self.tableView.tableFooterView = blankView;
    
//    // 设置手势，点击其他地方收起键盘
//    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//    _tapGesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:_tapGesture];
//    _tapGesture.enabled = NO;
    
    // 当前自选货币的textField
    _textFieldDic = [[NSMutableDictionary alloc] initWithCapacity:200];
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
    NSInteger index = [_dataModel.namesArray indexOfObject:name];
    
    UIImageView *imageView = [cell viewWithTag:100];
    [imageView setImage:[UIImage imageNamed:name]];
    
    UILabel *nameLabel = [cell viewWithTag:101];
    nameLabel.text = name;
    
    UILabel *chineseNameLabel = [cell viewWithTag:102];
    chineseNameLabel.text = _chineseNamesArray[index];
    
    UILabel *fullNameLabel = [cell viewWithTag:103];
    fullNameLabel.text = _fullNamesArray[index];
    
    UITextField *textField = [cell viewWithTag:104];
    Currency *currency = [_dataModel.allCurrencyDic objectForKey:name];
    textField.placeholder = [NSString stringWithFormat:@"%.2lf", currency.price];
    
    // 保存textField
    [_textFieldDic setObject:textField forKey:name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = [cell viewWithTag:104];
    [textField becomeFirstResponder];
//    _tapGesture.enabled = YES;
}

- (void)singleTap:(UITapGestureRecognizer *) recognizer {
//    [_textField resignFirstResponder];
//    _tapGesture.enabled = NO;
}

- (void)displayCurrencyChangeWithUserInfo:(NSDictionary *) userInfo {
    _displayingArray = _dataModel.displayArray;
    [self.tableView reloadData];
}

- (void)dealloc {
    
}

@end











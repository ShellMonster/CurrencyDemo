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
@property (strong, nonatomic) NSMutableDictionary *priceDic;
@property (strong, nonatomic) UITextField *editingTextField;

@property (assign, nonatomic) NSInteger editingRow;
//@property (assign, nonatomic) NSNumber *arrayCount;

@property (strong, nonatomic) UIButton *addButton;

@end

@implementation MyChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // DataModel单例
    _dataModel = [DataModel sharedInstance];
    
    // 自选数组
    _displayingArray = [[NSArray alloc] initWithArray:_dataModel.displayArray copyItems:NO];
//    _arrayCount = [NSNumber numberWithInteger:_displayingArray.count];
//    [self addObserver:self forKeyPath:@"arrayCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    _fullNamesArray = [NSArray arrayWithArray:_dataModel.fullNamesArray];
    _chineseNamesArray = [NSArray arrayWithArray:_dataModel.chineseNamesArray];
    
    // 注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCurrencyChangeWithNotice:) name:@"Add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrice) name:@"DataDone" object:nil];
    
    // UI
    _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _addButton.frame = CGRectMake(0, 0, screenWidth, 100);
    [_addButton setTitle:@"添加自选" forState:UIControlStateNormal];
    [_addButton setBackgroundColor:[UIColor yellowColor]];
    
    // 设置手势，点击其他地方收起键盘
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapGesture];
    _tapGesture.enabled = NO;
    
    // 记录换算结果
    _priceDic = [[NSMutableDictionary alloc] initWithCapacity:200];
    for (NSString *name in _displayingArray) {
        [_priceDic setObject:@"" forKey:name];
    }
    
    // 默认没有任何在编辑
    _editingRow = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    double amount = [[_priceDic objectForKey:name] doubleValue];
    if (amount > 0.0) {
        textField.text = [NSString stringWithFormat:@"%.2lf", amount];
    } else {
        textField.text = @"";
    }
    // 设置textField回调
    [textField addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _editingRow = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = [cell viewWithTag:104];
    textField.userInteractionEnabled = YES;
    [textField becomeFirstResponder];
    _editingTextField = textField;
    _editingTextField.delegate = self;
    _tapGesture.enabled = YES;
    
}

// 滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *name = _displayingArray[indexPath.row];
        [_dataModel removeDisplayCurrencyName:name];
        [_priceDic removeObjectForKey:name];
        _displayingArray = _dataModel.displayArray;
//        _arrayCount = [NSNumber numberWithInteger:_displayingArray.count];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"hhh");
}

#pragma mark - Gesture Methods
- (void)singleTap:(UITapGestureRecognizer *) recognizer {
    [_editingTextField resignFirstResponder];
    _editingTextField.userInteractionEnabled = NO;
    _tapGesture.enabled = NO;
}

#pragma mark - Notice Methods
// Add
- (void)displayCurrencyChangeWithNotice:(NSNotification *) notice {
    _displayingArray = _dataModel.displayArray;
    NSDictionary *userInfo = notice.userInfo;
    NSString *newCurrency = [userInfo objectForKey:@"name"];
    [_priceDic setObject:@"" forKey:newCurrency];
    [self.tableView reloadData];
//    _arrayCount = [NSNumber numberWithInteger:_displayingArray.count];
}

// DataDone
- (void)updatePrice {
    [self.tableView reloadData];
//    _arrayCount = [NSNumber numberWithInteger:_displayingArray.count];
}

#pragma mark ------------------
- (void)updatePriceFromCurrencyName:(NSString *) name {
    Currency *fromCurrency = [_dataModel.allCurrencyDic objectForKey:name];
    double fromPrice = fromCurrency.price;
    double fromAmout = [_editingTextField.text doubleValue];
    
    // 储存所有textField对应的key
    NSArray *array = [_priceDic allKeys];
    for (NSString *toName in array) {
        if (![toName isEqualToString:name]) {
            Currency *toCurrency = [_dataModel.allCurrencyDic objectForKey:toName];
            double toPrice = toCurrency.price;
            double rate = toPrice / fromPrice;
            double toAmount = fromAmout * rate;
            if (toAmount > 0.0) {
                [_priceDic setObject:@(toAmount) forKey:toName];
            } else {
                [_priceDic setObject:@"" forKey:toName];
            }
            NSInteger row = [_displayingArray indexOfObject:toName];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            if (fromAmout > 0.0) {
                [_priceDic setObject:@(fromAmout) forKey:name];
            } else {
                [_priceDic setObject:@"" forKey:name];
            }
        }
    }
}

#pragma mark - textField text change
- (void)textFieldDidChangeText:(UITextField *)textField {
    NSString *name = _displayingArray[_editingRow];
    [self updatePriceFromCurrencyName:name];
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *editedText = textField.text;
    double textValue = [editedText doubleValue];
    if (textValue > 0.0) {
        textField.text = [NSString stringWithFormat:@"%.2lf", textValue];
    } else {
        textField.text = @"";
    }
    
}

@end











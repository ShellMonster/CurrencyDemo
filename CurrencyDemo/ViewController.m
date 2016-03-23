//
//  ViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ViewController.h"

#import "DataModel.h"

#import "MyChoiceViewController.h"
#import "AllCurrencyViewController.h"
#import "HudView.h"

#define kMyChoiceViewController 0
#define kAllCurrencyViewController 1

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *controllersArray;
@property (assign, nonatomic) NSInteger currentView;

// HUDView
@property (strong, nonatomic) HudView *hudView;

// 刷新按钮
@property (strong, nonatomic) UIButton *refreshButton;

// DataModel
@property (strong, nonatomic) DataModel *dataModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 结合configureLayouts，让tableView不被遮挡
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 存放controllers的数组
    _controllersArray = [[NSMutableArray alloc] initWithCapacity:10];
    // 使用storyboard初始化VC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyChoiceViewController *myChoiceVC = [storyboard instantiateViewControllerWithIdentifier:@"MyChoiceViewController"];
    [_controllersArray addObject:myChoiceVC];
    [self addChildViewController:myChoiceVC];
    [self.view addSubview:myChoiceVC.view];
    [myChoiceVC didMoveToParentViewController:self];
    [self configureLayouts:myChoiceVC];
    //
    AllCurrencyViewController *allVC = [storyboard instantiateViewControllerWithIdentifier:@"AllCurrencyViewController"];
    [_controllersArray addObject:allVC];
    
    // 默认View为自选
    _currentView = kMyChoiceViewController;
    
    //
    _dataModel = [DataModel sharedInstance];
    [_dataModel loadDisplay];
    [_dataModel startFetchData];
    
    // 显示HudView
    [self showHudView];
    
    // 接收通知，当数据获取完毕后隐藏hudView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDone) name:@"DataDone" object:nil];
    // 超时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataTimeOut) name:@"TimeOut" object:nil];
    
    // 刷新按钮
    _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _refreshButton.frame = CGRectMake(0, 0, 30, 20);
    [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_refreshButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 切换View
- (void)segmentChange:(id)sender {
    
    UITableViewController *currentVC = [_controllersArray objectAtIndex:_currentView];
    
    UITableViewController *toVC = nil;
    
    UISegmentedControl *segment = sender;
    NSInteger selectedView = segment.selectedSegmentIndex;
    
    if (selectedView == kMyChoiceViewController) {
        toVC = [_controllersArray objectAtIndex:kMyChoiceViewController];
    } else {
        toVC = [_controllersArray objectAtIndex:kAllCurrencyViewController];
    }
    
    [self addChildViewController:toVC];
    [self.view insertSubview:toVC.view atIndex:0];
    [toVC didMoveToParentViewController:self];
    [self configureLayouts:toVC];
    [currentVC willMoveToParentViewController:nil];
    [currentVC.view removeFromSuperview];
    [currentVC removeFromParentViewController];
    
    _currentView = selectedView;
}

// 设置布局
- (void)configureLayouts:(UIViewController *)viewController {
    NSDictionary *dic = @{
                          @"view": viewController.view,
                          };
    [viewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[view]-0-|" options:0 metrics:nil views:dic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:dic]];
}

// hudView
- (void)showHudView {
    NSInteger count = _dataModel.displayArray.count;
    if (count > 0) {
        _hudView = [[HudView alloc] initWithFrame:self.view.frame];
        self.navigationController.view.userInteractionEnabled = NO;
        _refreshButton.enabled = NO;
        [self.view addSubview:_hudView];
    }

}

// 接收通知，当数据获取完毕后隐藏hudView
- (void)dataDone {
    if (_hudView != nil) {
        [_hudView setHudViewImage:[UIImage imageNamed:@"checkmark"] text:@"Done"];
        [_hudView setNeedsDisplay];
        [_hudView dismissHudViewAfterDelay:0.7 completion:^{
            self.navigationController.view.userInteractionEnabled = YES;
            _refreshButton.enabled = YES;
            _hudView = nil;
        }];
    }
}

- (void)dataTimeOut {
    if (_hudView != nil) {
        [_hudView setHudViewImage:[UIImage imageNamed:@"cross"] text:@"Time Out"];
        [_hudView setNeedsDisplay];
        [_hudView dismissHudViewAfterDelay:0.7 completion:^{
            self.navigationController.view.userInteractionEnabled = YES;
            _refreshButton.enabled = YES;
            _hudView = nil;
        }];
    }
}

- (void)requestData {
    [_dataModel startFetchData];
    [self showHudView];
}

- (void)dealloc {
    
}

@end











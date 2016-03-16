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

#define kMyChoiceViewController 0
#define kAllCurrencyViewController 1

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *controllersArray;
@property (assign, nonatomic) NSInteger currentView;

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
    
    AllCurrencyViewController *allVC = [storyboard instantiateViewControllerWithIdentifier:@"AllCurrencyViewController"];
    [_controllersArray addObject:allVC];
    
    // 默认View为自选
    _currentView = kMyChoiceViewController;
    
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
    [self.view addSubview:toVC.view];
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

- (void)dealloc {
    
}

@end











//
//  ViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/15.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ViewController.h"

#import "DataModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notictTest) name:@"DataDone" object:nil];
    
    DataModel *model = [DataModel sharedInstance];
    [model startFetchData];
}

- (void)notictTest {
    NSLog(@"All data done!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end











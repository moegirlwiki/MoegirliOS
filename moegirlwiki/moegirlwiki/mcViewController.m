//
//  mcViewController.m
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcViewController.h"

@interface mcViewController ()

@end

@implementation mcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self visualInit];
}

- (void)viewDidAppear:(BOOL)animated
{
    _mainPageScrollView = [moegirlMainPageScrollView new];
    [_mainPageScrollView setFrame:_MasterInitial.frame];
    [_MainView addSubview:_mainPageScrollView];
    [_mainPageScrollView setDelegate:_mainPageScrollView];
    [_mainPageScrollView setTargetURL:@"http://zh.moegirl.org/Mainpage?action=render"];
    [_mainPageScrollView loadMainPage:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)visualInit
{
    _SearchBox.layer.cornerRadius = 5;
    _SearchBox.layer.masksToBounds = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         /*----------------------*/
                         [_mainPageScrollView setFrame:_MasterInitial.frame];
                         [_mainPageScrollView refreshScrollView];
                         
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         NSLog(@"didRotate");
                     }];
}

@end

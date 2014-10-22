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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)visualInit
{
    // 搜索框的圆角
    _SearchBox.layer.cornerRadius = 5;
    _SearchBox.layer.masksToBounds = YES;
    
    // 搜索建议框
    _searchSuggestionsTableView = [moegirlSearchSuggestionsTableView new];
    [_searchSuggestionsTableView setFrame:_MasterInitial.frame];
    [_searchSuggestionsTableView setDataSource:_searchSuggestionsTableView];
    [_searchSuggestionsTableView setDelegate:_searchSuggestionsTableView];
    [_searchSuggestionsTableView setRowHeight:40];
    [_searchSuggestionsTableView setTargetURL:@"http://zh.moegirl.org"];
    [_MainView addSubview:_searchSuggestionsTableView];

    
    // 首页
    _mainPageScrollView = [moegirlMainPageScrollView new];
    [_mainPageScrollView setFrame:_MasterInitial.frame];
    [_MainView addSubview:_mainPageScrollView];
    [_mainPageScrollView setDelegate:_mainPageScrollView];
    [_mainPageScrollView setTargetURL:@"http://zh.moegirl.org"];
    [_mainPageScrollView loadMainPage:YES];
    
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

- (IBAction)searchFieldEditChange:(id)sender
{
    if ([_SearchTextField.text isEqual:@""]) {
        [_MainView sendSubviewToBack:_searchSuggestionsTableView];
        return;
    }
    NSString * Keyword = _SearchTextField.text;
    NSRange rangeA = [Keyword rangeOfString:@" "];
    if (rangeA.location != NSNotFound) {
        Keyword = [Keyword substringToIndex:rangeA.location];
    }
    [_searchSuggestionsTableView checkSuggestions:Keyword];
    [_MainView bringSubviewToFront:_searchSuggestionsTableView];
}

@end

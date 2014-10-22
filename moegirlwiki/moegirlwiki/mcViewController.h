//
//  mcViewController.h
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moegirlMainPageScrollView.h"
#import "moegirlSearchSuggestionsTableView.h"

@interface mcViewController : UIViewController<moegirlMainPageScrollViewDekegate,moegirlSearchSuggestionsTableViewDelegate>
{
    
}
//代码创建元件
@property (strong, nonatomic) moegirlMainPageScrollView * mainPageScrollView;
@property (strong, nonatomic) moegirlSearchSuggestionsTableView * searchSuggestionsTableView;


//xib元件
@property (weak, nonatomic) IBOutlet UIView *SearchBox;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *MasterInitial;
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;


//过程
- (void)visualInit;//初始化视觉效果
- (void)resetSizes;//重置元件尺寸


//xib过程
- (IBAction)searchFieldEditChange:(id)sender;

@end

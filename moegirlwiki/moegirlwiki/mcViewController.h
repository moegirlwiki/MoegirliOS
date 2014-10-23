//
//  mcViewController.h
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcAppDelegate.h"
#import "moegirlMainPageScrollView.h"
#import "moegirlSearchSuggestionsTableView.h"
#import "moegirlWebView.h"

@interface mcViewController : UIViewController<moegirlMainPageScrollViewDekegate,moegirlSearchSuggestionsTableViewDelegate,mcAppDelegate,moegirlWebViewDelegate>
{
    @private
    int webViewListPosition;
}
//代码创建元件
@property (strong, nonatomic) moegirlMainPageScrollView * mainPageScrollView;
@property (strong, nonatomic) moegirlSearchSuggestionsTableView * searchSuggestionsTableView;
@property (weak, nonatomic) mcAppDelegate * appDelegate;
@property (strong, nonatomic) NSMutableArray * webViewList;

//xib元件
@property (weak, nonatomic) IBOutlet UIView *SearchBox;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *MasterInitial;
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;


//过程
- (void)visualInit;//初始化视觉效果
- (void)resetSizes;//重置元件尺寸
- (void)createMoeWebView:(NSString *)target;


//xib过程
- (IBAction)searchFieldEditChange:(id)sender;

@end

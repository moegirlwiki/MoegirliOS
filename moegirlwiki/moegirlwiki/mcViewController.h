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
#import "moegirlSideControlTableView.h"
#import "moegirlRandom.h"

#import "mcLeftDrag.h"
#import "mcRightDrag.h"
#import "mcAnalytics.h"

@interface mcViewController : UIViewController
<
moegirlMainPageScrollViewDekegate,
moegirlSearchSuggestionsTableViewDelegate,
mcAppDelegate,
moegirlWebViewDelegate,
mcLeftDragDelegate,mcRightDragDelegate,
moegirlSideControlTableViewDelegate,
moegirlRandomDelegate
>
{
    @private
    int webViewListPosition;
    bool menuSituation;
    bool firstLaunch;
    
}
//代码创建元件
@property (strong, nonatomic) moegirlMainPageScrollView * mainPageScrollView;
@property (strong, nonatomic) moegirlSearchSuggestionsTableView * searchSuggestionsTableView;
@property (strong, nonatomic) moegirlSideControlTableView * sideControlTableView;
@property (weak, nonatomic) mcAppDelegate * appDelegate;
@property (strong, nonatomic) mcLeftDrag * leftPanel;
@property (strong, nonatomic) mcRightDrag * rightPanel;
@property (strong, nonatomic) moegirlRandom * randomFunction;
@property (strong, nonatomic) mcAnalytics * analyticView;
@property (strong, nonatomic) UIButton * resetButton;

@property (strong, nonatomic) NSMutableArray * webViewList;
@property (strong, nonatomic) NSMutableArray * webViewTitles;
@property (strong, nonatomic) UIActivityViewController *activityController;

//xib元件
@property (weak, nonatomic) IBOutlet UIView *SearchBox;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *MasterInitial;
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;
@property (weak, nonatomic) IBOutlet UIView *LeftPanelInitialPosition;
@property (weak, nonatomic) IBOutlet UIView *RightPanelInitialPosition;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressBar;
@property (weak, nonatomic) IBOutlet UIView *NavigationBar;
@property (weak, nonatomic) IBOutlet UIView *StatusBar;


//过程
- (void)visualInit;//初始化视觉效果
- (void)resetSizes;//重置元件尺寸
- (void)createMoeWebView:(NSString *)target;
- (void)presentMenu;
- (void)resetMenu;


//xib过程
- (IBAction)searchFieldEditChange:(id)sender;
- (IBAction)menuButtonClick:(id)sender;
- (IBAction)TextFieldSearchButton:(id)sender;

@end

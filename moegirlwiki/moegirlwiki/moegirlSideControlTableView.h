//
//  moegirlSideControlTableView.h
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol moegirlSideControlTableViewDelegate<NSObject>

- (void)cancelKeyboard;
- (void)ctrlPanelCallMainpage;
- (void)ctrlPanelCallRefresh;
- (void)ctrlPanelCallEditor;
- (void)ctrlPanelCallSettings;
- (void)ctrlPanelCallAbout;

@end

@interface moegirlSideControlTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id<moegirlSideControlTableViewDelegate> hook;

@end

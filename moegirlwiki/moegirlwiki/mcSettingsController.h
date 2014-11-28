//
//  mcSettingsController.h
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcUpdate.h"
#import "moegirlConnectionLogin.h"

@interface mcSettingsController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,mcUpdateDelegate,moegirlConnectionLoginDelegate>
{
    @private
    bool updateInProgress;
    bool onHelp;
    int pagecount;
    long long folderSize;
    mcUpdate *updateThread;
    moegirlConnectionLogin * moegirlLogin;
}

@property (strong, nonatomic) UIView * updateView;
@property (strong, nonatomic) UIView * loginView;
@property (strong, nonatomic) UITextField * usernameField;
@property (strong, nonatomic) UITextField * passwordField;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIView * protectView;
@property (strong, nonatomic) UILabel * statueLabel;
@property (strong, nonatomic) UIActivityIndicatorView * updateIndicator;

@property (weak, nonatomic) IBOutlet UITableView *SettingsTable;
@property (weak, nonatomic) IBOutlet UIView *MainInitViewRuler;
@property (weak, nonatomic) IBOutlet UIWebView *HelpWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *HelpIndicator;



- (long long) fileSizeAtPath:(NSString*) filePath;
- (IBAction)goBackButtonClick:(id)sender;

@end

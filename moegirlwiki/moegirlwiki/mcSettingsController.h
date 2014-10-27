//
//  mcSettingsController.h
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcUpdate.h"

@interface mcSettingsController : UIViewController<UITableViewDataSource,UITableViewDelegate,mcUpdateDelegate>
{
    @private
    bool updateInProgress;
    int pagecount;
    long long folderSize;
    mcUpdate *updateThread;
}

@property (strong, nonatomic) UIView * updateView;
@property (strong, nonatomic) UIView * protectView;
@property (strong, nonatomic) UILabel * statueLabel;
@property (strong, nonatomic) UIActivityIndicatorView * updateIndicator;
@property (weak, nonatomic) IBOutlet UITableView *SettingsTable;

- (long long) fileSizeAtPath:(NSString*) filePath;
- (IBAction)goBackButtonClick:(id)sender;

@end

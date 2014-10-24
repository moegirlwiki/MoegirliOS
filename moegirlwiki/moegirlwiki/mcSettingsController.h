//
//  mcSettingsController.h
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcSettingsController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *SettingsTable;
- (IBAction)goBackButtonClick:(id)sender;

@end

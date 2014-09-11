//
//  mcSettingsController.h
//  moegirlwiki
//
//  Created by Michael Chan on 14-8-29.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcSettingsController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{}

@property (strong, nonatomic) NSString *rtitle;
@property (strong, nonatomic) NSString *rcontent;
@property (strong, nonatomic) NSString *rerror;


@end

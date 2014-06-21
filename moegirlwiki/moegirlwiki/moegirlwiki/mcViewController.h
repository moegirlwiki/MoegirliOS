//
//  mcViewController.h
//  moegirlwiki
//
//  Created by Chen Junlin on 14-6-19.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcViewController : UIViewController<UIWebViewDelegate>{}
@property (weak, nonatomic) IBOutlet UIWebView *MasterWebView;

@end

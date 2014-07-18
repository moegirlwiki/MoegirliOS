//
//  mcViewController.h
//  moegirlwiki
//
//  Created by Chen Junlin on 14-7-15.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mcViewController : UIViewController<UIWebViewDelegate,UISearchBarDelegate>{}
@property (weak, nonatomic) IBOutlet UIWebView *MasterWebView;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBox;

@end

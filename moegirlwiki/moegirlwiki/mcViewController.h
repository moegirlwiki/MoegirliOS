//
//  mcViewController.h
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moegirlMainPageScrollView.h"

@interface mcViewController : UIViewController
{
    
}
//代码创建元件
@property (strong, nonatomic) moegirlMainPageScrollView * mainPageScrollView;


//xib元件
@property (weak, nonatomic) IBOutlet UIView *SearchBox;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *MasterInitial;


//过程
- (void)visualInit;//初始化视觉效果

@end

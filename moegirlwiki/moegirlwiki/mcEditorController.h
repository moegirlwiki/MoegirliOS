//
//  mcEditorController.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moegirlEditorInit.h"

@interface mcEditorController : UIViewController<moegirlEditorInitDelegate>
{
    @private
    NSTimer *timerForIndicator;
    moegirlEditorInit *initProcess;
}
//自创建元件


//xib 元件
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *prepareView;
@property (weak, nonatomic) IBOutlet UITextView *statusText;
@property (weak, nonatomic) IBOutlet UIImageView *sellMoeIndicator;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)cancelButtonAction:(id)sender;

@end

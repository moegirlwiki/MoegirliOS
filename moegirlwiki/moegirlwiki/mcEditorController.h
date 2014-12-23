//
//  mcEditorController.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moegirlEditorInit.h"
#import "moegirlEditorSubmit.h"

@interface mcEditorController : UIViewController<moegirlEditorInitDelegate,moegirlEditorSubmitDelegate>
{
    @private
    float keyboardHeight;
    NSTimer *timerForIndicator;
    moegirlEditorInit *initProcess;
    moegirlEditorSubmit *submitProcess;
}
//自创建元件
@property (strong, nonatomic) UITextView * contentEditor;
@property (strong, nonatomic) UIMenuController * popoutMenu;



//菜单元件
@property (strong, nonatomic) UIMenuItem * itemCancelEdit;
@property (strong, nonatomic) UIMenuItem * itemHeadline;
@property (strong, nonatomic) UIMenuItem * itemColon;
@property (strong, nonatomic) UIMenuItem * itemSeprater;
@property (strong, nonatomic) UIMenuItem * itemBracket1;
@property (strong, nonatomic) UIMenuItem * itemBracket2;
@property (strong, nonatomic) UIMenuItem * itemBracket3;
@property (strong, nonatomic) UIMenuItem * itemStrong;
@property (strong, nonatomic) UIMenuItem * itemSubmitEdit;

//xib 元件
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *prepareView;
@property (weak, nonatomic) IBOutlet UITextView *statusText;
@property (weak, nonatomic) IBOutlet UIImageView *sellMoeIndicator;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)menuClick:(id)sender;

@end

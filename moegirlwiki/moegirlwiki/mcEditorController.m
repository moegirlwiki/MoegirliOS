//
//  mcEditorController.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcEditorController.h"

@interface mcEditorController ()

@end

@implementation mcEditorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timerForIndicator =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loaderAnimate) userInfo:nil repeats:YES];
    
    [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_cancelButton setTitleColor:[UIColor colorWithRed:0.08 green:0.88 blue:0.07 alpha:1.0] forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor clearColor]];
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = [[UIColor colorWithRed:0.878 green:0.98 blue:0.851 alpha:1] CGColor];
    _cancelButton.layer.cornerRadius = 3;
    _cancelButton.layer.masksToBounds = YES;
    
    keyboardHeight = 0;
    
    _contentEditor = [UITextView new];
    [_contentEditor setFrame:CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height - keyboardHeight)];
    [_containerView addSubview:_contentEditor];
    [_containerView sendSubviewToBack:_contentEditor];
    
    [self installMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)KeyboardChanged:(NSNotification *)notification
{
    //NSLog(@"Keyboard");
    NSDictionary *info = [notification userInfo];
    
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    
    keyboardHeight = keyboardSize.height;
    [self resizeViews];
}

- (void)resizeViews
{
    if (_prepareView.alpha != 1) {
        [_contentEditor setFrame:CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height - keyboardHeight)];
        [_menuButton setFrame:CGRectMake(_containerView.frame.size.width - 42, _containerView.frame.size.height - keyboardHeight - 41, 42, 41)];
        [_menuButton setAlpha:1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_prepareView setAlpha:1];
    [_menuButton setAlpha:0];
    [_statusText setText:@"正在准备编辑器......\n"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardChanged:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    initProcess = [moegirlEditorInit new];
    [initProcess setHook:self];
    NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
    [initProcess setTargetTitle:[defaultdata objectForKey:@"lastmotification"]];
    [initProcess fetchToken];
}

- (void)loaderAnimate
{
    [UIView animateWithDuration:0.8
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_sellMoeIndicator setAlpha:0];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         [UIView animateWithDuration:0.8
                                               delay:0
                                             options:    UIViewAnimationOptionOverrideInheritedCurve
                                          animations:^{
                                              /*----------------------*/
                                              [_sellMoeIndicator setAlpha:1];
                                              /*----------------------*/
                                          }
                                          completion:^(BOOL finished){
                                              /*----------------------*/
                                              /*----------------------*/
                                          }];
                         /*----------------------*/
                     }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addStatus:(NSString *)statusText
{
    [_statusText setText:[_statusText.text stringByAppendingString:statusText]];
}

- (void)initSuccess
{
    
    [UIView animateWithDuration:0.8
                          delay:1
                        options:    UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         /*----------------------*/
                         [_prepareView setAlpha:0];
                         [_contentEditor setText:initProcess.targetContent];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         [_contentEditor becomeFirstResponder];
                         /*----------------------*/
                     }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [initProcess cancelRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)menuClick:(id)sender {
    [_menuButton becomeFirstResponder];
    
    [_popoutMenu setTargetRect:CGRectMake(20, 0, 0, 0) inView:_menuButton];
    [_popoutMenu setMenuVisible:YES animated:YES];
}

#pragma  菜单相关
- (void)installMenu
{
        _popoutMenu = [UIMenuController sharedMenuController];
        
        _itemCancelEdit = [[UIMenuItem alloc] initWithTitle:@"退出编辑❗️" action:@selector(menuCancelEdit)];
        _itemHeadline = [[UIMenuItem alloc] initWithTitle:@"==" action:@selector(menuHeadline)];
        _itemColon = [[UIMenuItem alloc] initWithTitle:@":" action:@selector(menuColon)];
        _itemSeprater = [[UIMenuItem alloc] initWithTitle:@"|" action:@selector(menuSeprater)];
        _itemBracket1 = [[UIMenuItem alloc] initWithTitle:@"{{}}" action:@selector(menuBracket1)];
        _itemBracket2 = [[UIMenuItem alloc] initWithTitle:@"[[]]" action:@selector(menuBracket2)];
        _itemBracket3 = [[UIMenuItem alloc] initWithTitle:@"()" action:@selector(menuBracket3)];
        _itemStrong  = [[UIMenuItem alloc] initWithTitle:@"'''" action:@selector(menuStrong)];
        _itemSubmitEdit = [[UIMenuItem alloc] initWithTitle:@"  ☑️提交   " action:@selector(menuSubmitEdit)];
        
        [_popoutMenu setMenuItems:[NSArray arrayWithObjects:
                                   _itemSubmitEdit,
                                   _itemHeadline,
                                   _itemColon,
                                   _itemSeprater,
                                   _itemBracket1,
                                   _itemBracket2,
                                   _itemStrong,
                                   _itemBracket3,
                                   _itemCancelEdit, nil]];
}

-(void)menuCancelEdit
{
    NSLog(@"CancelEdit");
    UIAlertView * cancelConfirm = [[UIAlertView alloc]initWithTitle:@"确定要退出编辑吗？"
                                                           message:@"你将丢失你当前编辑过的所有内容！"
                                                          delegate:self
                                                 cancelButtonTitle:@"返回编辑"
                                                 otherButtonTitles:@"退出", nil];
    [cancelConfirm show];
    
}

-(void)menuSubmitEdit
{
    NSLog(@"SubmitEdit");
    UIAlertView * submitConfirm = [[UIAlertView alloc]initWithTitle:@"确定要提交编辑吗？"
                                                            message:@"当前仅支持[自动确认用户]提交编辑"
                                                           delegate:self
                                                  cancelButtonTitle:@"返回编辑"
                                                  otherButtonTitles:@"提交", nil];
    [submitConfirm show];
}

-(void)menuHeadline
{
    NSRange selectRange = [_contentEditor selectedRange];
    if (selectRange.length == 0) {
        [_contentEditor setText:[NSString stringWithFormat:@"%@====%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringFromIndex:selectRange.location]]];
        selectRange.location += 2;
        selectRange.length = 0;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    } else {
        [_contentEditor setText:[NSString stringWithFormat:@"%@\n==%@==\n%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringWithRange:selectRange],
                                 [_contentEditor.text substringFromIndex:selectRange.location+selectRange.length]]];
        selectRange.location += 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }
}

-(void)menuColon
{
    NSRange selectRange = [_contentEditor selectedRange];
    [_contentEditor setText:[NSString stringWithFormat:@"%@:%@",
                             [_contentEditor.text substringToIndex:selectRange.location],
                             [_contentEditor.text substringFromIndex:selectRange.location]]];
    selectRange.location += 1;
    selectRange.length = 0;
    [_contentEditor setSelectedRange:selectRange];
    [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
}

-(void)menuSeprater
{
    NSRange selectRange = [_contentEditor selectedRange];
    [_contentEditor setText:[NSString stringWithFormat:@"%@|%@",
                             [_contentEditor.text substringToIndex:selectRange.location],
                             [_contentEditor.text substringFromIndex:selectRange.location]]];
    selectRange.location += 1;
    selectRange.length = 0;
    [_contentEditor setSelectedRange:selectRange];
    [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
}

-(void)menuBracket1
{
    NSRange selectRange = [_contentEditor selectedRange];
    if (selectRange.length == 0) {
        [_contentEditor setText:[NSString stringWithFormat:@"%@{{黑幕|}}%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringFromIndex:selectRange.location]]];
        selectRange.location += 2;
        selectRange.length = 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }else{
        [_contentEditor setText:[NSString stringWithFormat:@"%@{{黑幕|%@}}%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringWithRange:selectRange],
                                 [_contentEditor.text substringFromIndex:selectRange.location+selectRange.length]]];
        selectRange.location += 2;
        selectRange.length = 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }
}

-(void)menuBracket2
{
    NSRange selectRange = [_contentEditor selectedRange];
    if (selectRange.length == 0) {
        [_contentEditor setText:[NSString stringWithFormat:@"%@[[分类:]]%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringFromIndex:selectRange.location]]];
        selectRange.location += 2;
        selectRange.length = 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }else{
        [_contentEditor setText:[NSString stringWithFormat:@"%@[[分类:%@]]%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringWithRange:selectRange],
                                 [_contentEditor.text substringFromIndex:selectRange.location+selectRange.length]]];
        selectRange.location += 2;
        selectRange.length = 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }
}

-(void)menuBracket3
{
    NSRange selectRange = [_contentEditor selectedRange];
    if (selectRange.length == 0) {
        [_contentEditor setText:[NSString stringWithFormat:@"%@()%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringFromIndex:selectRange.location]]];
        selectRange.location += 1;
        selectRange.length = 0;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }else{
        [_contentEditor setText:[NSString stringWithFormat:@"%@(%@)%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringWithRange:selectRange],
                                 [_contentEditor.text substringFromIndex:selectRange.location+selectRange.length]]];
        selectRange.location += 1;
        selectRange.length = 0;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }
}

-(void)menuStrong
{
    NSRange selectRange = [_contentEditor selectedRange];
    if (selectRange.length == 0) {
        [_contentEditor setText:[NSString stringWithFormat:@"%@'''粗体字'''%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringFromIndex:selectRange.location]]];
        selectRange.location += 3;
        selectRange.length = 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }else{
        [_contentEditor setText:[NSString stringWithFormat:@"%@'''%@'''%@",
                                 [_contentEditor.text substringToIndex:selectRange.location],
                                 [_contentEditor.text substringWithRange:selectRange],
                                 [_contentEditor.text substringFromIndex:selectRange.location+selectRange.length]]];
        selectRange.location += 3;
        [_contentEditor setSelectedRange:selectRange];
        [_contentEditor scrollRangeToVisible:_contentEditor.selectedRange];
    }
}

#pragma mark AlertViewAction

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * btnText = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"退出"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([btnText isEqualToString:@"提交"]) {
        [UIView animateWithDuration:0.8
                              delay:0
                            options:    UIViewAnimationOptionOverrideInheritedCurve
                         animations:^{
                             /*----------------------*/
                             [_contentEditor resignFirstResponder];
                             [_menuButton resignFirstResponder];
                             [_statusText setText:@""];
                             [_prepareView setAlpha:1];
                             /*----------------------*/
                         }
                         completion:^(BOOL finished){
                             /*----------------------*/
                             [self addStatus:@"正在准备数据\n"];
                             if (submitProcess != nil) {
                                 [submitProcess cancelRequest];
                             }
                             submitProcess = [moegirlEditorSubmit new];
                             
                             [submitProcess setHook:self];
                             [submitProcess setWikiTextString:_contentEditor.text];
                             [submitProcess setEdit_pageid:initProcess.edit_pageid];
                             [submitProcess setEdit_startTime:initProcess.edit_startTime];
                             [submitProcess setEdit_title:initProcess.edit_title];
                             [submitProcess setEdit_token:initProcess.edit_token];
                             [submitProcess setEdit_touchedTime:initProcess.edit_touchedTime];
                             
                             [submitProcess submitRequest];
                             /*----------------------*/
                         }];
        
    }
}



@end

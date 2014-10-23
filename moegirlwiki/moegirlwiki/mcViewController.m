//
//  mcViewController.m
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcViewController.h"

@interface mcViewController ()

@end

@implementation mcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _webViewList = [NSMutableArray new];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    [_appDelegate setHook:self];
    
    webViewListPosition = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self visualInit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self resetSizes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)visualInit
{
    // 搜索框的圆角
    _SearchBox.layer.cornerRadius = 5;
    _SearchBox.layer.masksToBounds = YES;
    
    // 搜索建议框
    _searchSuggestionsTableView = [moegirlSearchSuggestionsTableView new];
    [_searchSuggestionsTableView setFrame:_MasterInitial.frame];
    [_searchSuggestionsTableView setDataSource:_searchSuggestionsTableView];
    [_searchSuggestionsTableView setDelegate:_searchSuggestionsTableView];
    [_searchSuggestionsTableView setHook:self];
    [_searchSuggestionsTableView setRowHeight:40];
    [_searchSuggestionsTableView setTargetURL:@"http://zh.moegirl.org"];
    [_MainView addSubview:_searchSuggestionsTableView];

    
    // 首页
    _mainPageScrollView = [moegirlMainPageScrollView new];
    [_mainPageScrollView setFrame:_MasterInitial.frame];
    [_mainPageScrollView setDelegate:_mainPageScrollView];
    [_mainPageScrollView setHook:self];
    [_mainPageScrollView setTargetURL:@"http://zh.moegirl.org"];
    [_mainPageScrollView loadMainPage:YES];
    [_MainView addSubview:_mainPageScrollView];
    
    
    _leftPanel = [mcLeftDrag new];
    [_leftPanel setHook:self];
    [_leftPanel setBackgroundColor:[UIColor clearColor]];
    [_MainView addSubview:_leftPanel];
    
    _rightPanel = [mcRightDrag new];
    [_rightPanel setHook:self];
    [_rightPanel setBackgroundColor:[UIColor clearColor]];
    [_MainView addSubview:_rightPanel];
    
}

- (void)resetSizes
{
    [_leftPanel setFrame:_LeftPanelInitialPosition.frame];
    [_rightPanel setFrame:_RightPanelInitialPosition.frame];
    
    [_mainPageScrollView setFrame:_MasterInitial.frame];
    [_mainPageScrollView refreshScrollView];
    
    [_searchSuggestionsTableView setFrame:_MasterInitial.frame];
    
    for (int i = 0 ; i < _webViewList.count; i++) {
        [[_webViewList objectAtIndex:i] setFrame:_MasterInitial.frame];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         /*----------------------*/
                         [self resetSizes];
                         /*----------------------*/
                     }
                     completion:^(BOOL finished){
                         /*----------------------*/
                         
                         /*----------------------*/
                     }];
}

- (void)cancelKeyboard
{
    [_SearchTextField resignFirstResponder];
}

- (void)urlSchemeCall:(NSString *)target
{
    NSLog(@"%@",target);
    NSRange rangeA = [target rangeOfString:@"?w="];
    if (rangeA.location != NSNotFound) {
        target = [target substringFromIndex:rangeA.location + 3];
        [self createMoeWebView:target];
    }
}

- (void)createMoeWebView:(NSString *)target
{
    moegirlWebView * webView = [moegirlWebView new];
    [webView setFrame:CGRectMake(_MasterInitial.frame.origin.x + _MasterInitial.frame.size.width,
                                 _MasterInitial.frame.origin.y,
                                 _MasterInitial.frame.size.width,
                                 _MasterInitial.frame.size.height)];
    [webView setTargetURL:@"http://zh.moegirl.org"];
    [webView setDelegate:webView];
    [webView setHook:self];
    [webView loadContentWithEncodedKeyWord:target useCache:YES];
    [_MainView addSubview:webView];
    [_webViewList insertObject:webView atIndex:webViewListPosition];
    webViewListPosition ++;
    for (int i = webViewListPosition; i < _webViewList.count ; i++) {
        [_webViewList removeObjectAtIndex:i];
    }
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [webView setFrame:_MasterInitial.frame];
                     }
                     completion:^(BOOL finished){
                         [_MainView bringSubviewToFront:_leftPanel];
                         [_MainView bringSubviewToFront:_rightPanel];
                     }];
}

- (IBAction)searchFieldEditChange:(id)sender
{
    if ([_SearchTextField.text isEqual:@""]) {
        [_MainView sendSubviewToBack:_searchSuggestionsTableView];
        return;
    }
    NSString * Keyword = _SearchTextField.text;
    NSRange rangeA = [Keyword rangeOfString:@" "];
    if (rangeA.location != NSNotFound) {
        Keyword = [Keyword substringToIndex:rangeA.location];
    }
    [_searchSuggestionsTableView checkSuggestions:Keyword];
    [_MainView bringSubviewToFront:_searchSuggestionsTableView];
}

- (void)newWebViewRequestFormWebView:(NSString *)decodedKeyword
{
    [self createMoeWebView:decodedKeyword];
}

- (void)newWebViewRequestFormSuggestions:(NSString *)keyword
{
    [self createMoeWebView:keyword];
    [_SearchTextField setText:[keyword stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [_MainView sendSubviewToBack:_searchSuggestionsTableView];
    [self cancelKeyboard];
}

- (void)MoveMainViewByLeftBegan
{
    if (webViewListPosition == 1) {
        [_MainView insertSubview:_mainPageScrollView belowSubview:[_webViewList objectAtIndex:webViewListPosition - 1]];
    }else if (webViewListPosition > 1){
        [_MainView insertSubview:[_webViewList objectAtIndex:webViewListPosition - 2] belowSubview:[_webViewList objectAtIndex:webViewListPosition - 1]];
    }
}

- (void)MoveMainViewByRightBegan
{
    if (_webViewList.count > webViewListPosition) {
        if (webViewListPosition == 0) {
            [_MainView insertSubview:[_webViewList objectAtIndex:webViewListPosition] belowSubview:_mainPageScrollView];
        }else{
            [_MainView insertSubview:[_webViewList objectAtIndex:webViewListPosition] belowSubview:[_webViewList objectAtIndex:webViewListPosition - 1]];
        }
    }
}

- (void)MoveMainViewByLeft:(float)Position
{
    if (webViewListPosition > 0) {
        moegirlWebView * tempWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
        [tempWebView setFrame:CGRectMake(tempWebView.frame.origin.x + Position,
                                         tempWebView.frame.origin.y,
                                         tempWebView.frame.size.width,
                                         tempWebView.frame.size.height)];
    }
}

- (void)MoveMainViewByRight:(float)Position
{
    if (_webViewList.count > webViewListPosition) {
        if (webViewListPosition == 0) {
            [_mainPageScrollView setFrame:CGRectMake(_mainPageScrollView.frame.origin.x + Position,
                                                     _mainPageScrollView.frame.origin.y,
                                                     _mainPageScrollView.frame.size.width,
                                                     _mainPageScrollView.frame.size.height)];
        }else{
            moegirlWebView * tempWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
            [tempWebView setFrame:CGRectMake(tempWebView.frame.origin.x + Position,
                                             tempWebView.frame.origin.y,
                                             tempWebView.frame.size.width,
                                             tempWebView.frame.size.height)];
        }
    }
}

- (void)MoveMainViewByLeftEnded:(BOOL)Dismiss
{
    if (webViewListPosition > 0) {
        float deviation = _leftPanel.frame.origin.x - _LeftPanelInitialPosition.frame.origin.x;
        moegirlWebView * tempWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
        if ((Dismiss&&(deviation > 20))||(deviation>150)) {
            //移除View
            [_MainView sendSubviewToBack:_leftPanel];
            [_MainView sendSubviewToBack:_rightPanel];
            webViewListPosition --;
            [UIView animateWithDuration:0.2
                                  delay:0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 [tempWebView setFrame:CGRectMake(_MasterInitial.frame.origin.x + _MasterInitial.frame.size.width + 10,
                                                                  _MasterInitial.frame.origin.y,
                                                                  _MasterInitial.frame.size.width,
                                                                  _MasterInitial.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 [_MainView sendSubviewToBack:tempWebView];
                                 [tempWebView setFrame:_MasterInitial.frame];
                                 [_MainView bringSubviewToFront:_leftPanel];
                                 [_MainView bringSubviewToFront:_rightPanel];
                             }];
            
        }else{
            //保留View
            [UIView animateWithDuration:0.2
                                  delay:0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 [tempWebView setFrame:_MasterInitial.frame];
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
    [_leftPanel setFrame:_LeftPanelInitialPosition.frame];
}

- (void)MoveMainViewByRightEnded:(BOOL)Dismiss
{
    if (_webViewList.count > webViewListPosition) {
        if (webViewListPosition == 0) {
            float deviation = _RightPanelInitialPosition.frame.origin.x - _rightPanel.frame.origin.x;
            if ((Dismiss&&(deviation > 20))||(deviation>150)) {
                //移除View
                [_MainView sendSubviewToBack:_leftPanel];
                [_MainView sendSubviewToBack:_rightPanel];
                webViewListPosition ++;
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [_mainPageScrollView setFrame:CGRectMake(_MasterInitial.frame.origin.x - _MasterInitial.frame.size.width - 10,
                                                                              _MasterInitial.frame.origin.y,
                                                                              _MasterInitial.frame.size.width,
                                                                              _MasterInitial.frame.size.height)];
                                 }
                                 completion:^(BOOL finished){
                                     [_MainView sendSubviewToBack:_mainPageScrollView];
                                     [_mainPageScrollView setFrame:_MasterInitial.frame];
                                     [_MainView bringSubviewToFront:_leftPanel];
                                     [_MainView bringSubviewToFront:_rightPanel];
                                 }];
            }else{
                //保留View
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [_mainPageScrollView setFrame:_MasterInitial.frame];
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
        }else{
            float deviation = _RightPanelInitialPosition.frame.origin.x - _rightPanel.frame.origin.x;
            moegirlWebView * tempWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
            if ((Dismiss&&(deviation > 20))||(deviation>150)) {
                [_MainView sendSubviewToBack:_leftPanel];
                [_MainView sendSubviewToBack:_rightPanel];
                webViewListPosition ++;
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [tempWebView setFrame:CGRectMake(_MasterInitial.frame.origin.x - _MasterInitial.frame.size.width - 10,
                                                                      _MasterInitial.frame.origin.y,
                                                                      _MasterInitial.frame.size.width,
                                                                      _MasterInitial.frame.size.height)];
                                 }
                                 completion:^(BOOL finished){
                                     [_MainView sendSubviewToBack:tempWebView];
                                     [tempWebView setFrame:_MasterInitial.frame];
                                     [_MainView bringSubviewToFront:_leftPanel];
                                     [_MainView bringSubviewToFront:_rightPanel];
                                 }];
            }else{
                //保留View
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [tempWebView setFrame:_MasterInitial.frame];
                                 }
                                 completion:^(BOOL finished){
                                 }];
                
            }
        }
    }
    [_rightPanel setFrame:_RightPanelInitialPosition.frame];
}



@end

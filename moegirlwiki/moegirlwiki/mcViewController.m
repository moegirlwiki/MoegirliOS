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
    _webViewTitles = [NSMutableArray new];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    [_appDelegate setHook:self];
    
    webViewListPosition = 0;
    firstLaunch = YES;
    NSLog(@"1st");
}

- (void)viewWillAppear:(BOOL)animated
{
    if (firstLaunch) {
        [self visualInit];
        firstLaunch = NO;
    }
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

#pragma mark MainMethods

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
    [_searchSuggestionsTableView setScrollsToTop:NO];
    [_searchSuggestionsTableView setTargetURL:@"http://zh.moegirl.org"];
    [_MainView addSubview:_searchSuggestionsTableView];

    // 菜单栏
    menuSituation = NO;
    
    
    _resetButton = [UIButton new];
    [_resetButton setFrame:CGRectMake(_NavigationBar.frame.origin.x,
                                      _NavigationBar.frame.origin.y - 20,
                                      _NavigationBar.frame.size.width,
                                      _NavigationBar.frame.size.height + _MainView.frame.size.height + 20)];
    [_resetButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [_resetButton addTarget:self action:@selector(resetMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetButton];
    [_resetButton setAlpha:0];
    
    
    _sideControlTableView = [moegirlSideControlTableView new];
    [_sideControlTableView setFrame:CGRectMake(_NavigationBar.frame.origin.x + _NavigationBar.frame.size.width,
                                               _NavigationBar.frame.origin.y - 20,
                                               200,
                                               _NavigationBar.frame.size.height + _MainView.frame.size.height + 20)];
    [_sideControlTableView setDataSource:_sideControlTableView];
    [_sideControlTableView setDelegate:_sideControlTableView];
    [_sideControlTableView setHook:self];
    [_sideControlTableView setBounces:NO];
    [_sideControlTableView setScrollsToTop:NO];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [_sideControlTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_sideControlTableView];
    [_sideControlTableView setAlpha:0];
    
    
    
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
    menuSituation = NO;
    [_resetButton setFrame:CGRectMake(_NavigationBar.frame.origin.x,
                                      _NavigationBar.frame.origin.y - 20,
                                      _NavigationBar.frame.size.width,
                                      _NavigationBar.frame.size.height + _MainView.frame.size.height + 20)];
    [_sideControlTableView setFrame:CGRectMake(_NavigationBar.frame.origin.x + _NavigationBar.frame.size.width,
                                               _NavigationBar.frame.origin.y - 20,
                                               200,
                                               _NavigationBar.frame.size.height + _MainView.frame.size.height + 20)];
    [_sideControlTableView reloadData];
    [_resetButton setAlpha:0];
    [_sideControlTableView setAlpha:0];
    
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
                        options:    UIViewAnimationOptionOverrideInheritedCurve|
                                    UIViewAnimationOptionAllowAnimatedContent
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:    UIViewAnimationOptionOverrideInheritedCurve|
     UIViewAnimationOptionAllowAnimatedContent
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

#pragma mark CreateNewWebView

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
    if (webViewListPosition == 0) {
        [_mainPageScrollView setScrollsToTop:NO];
    } else {
        moegirlWebView * currentView = [_webViewList objectAtIndex:webViewListPosition - 1];
        [currentView.scrollView setScrollsToTop:NO];
    }
    
    [_SearchTextField setText:[target stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    moegirlWebView * webView = [moegirlWebView new];
    [webView setFrame:CGRectMake(_MasterInitial.frame.origin.x + _MasterInitial.frame.size.width,
                                 _MasterInitial.frame.origin.y,
                                 _MasterInitial.frame.size.width,
                                 _MasterInitial.frame.size.height)];
    [webView setTargetURL:@"http://zh.moegirl.org"];
    [webView setDelegate:webView];
    [webView setHook:self];
    [webView loadContentWithEncodedKeyWord:target useCache:YES];
    [webView.scrollView setScrollsToTop:YES];
    [_MainView addSubview:webView];
    [_webViewList insertObject:webView atIndex:webViewListPosition];
    [_webViewTitles insertObject:_SearchTextField.text atIndex:webViewListPosition];
    webViewListPosition ++;
    for (int i = webViewListPosition; i < _webViewList.count ; i++) {
        [[_webViewList objectAtIndex:i] removeFromSuperview];
    }
    [_webViewList removeObjectsInRange:NSMakeRange(webViewListPosition, _webViewList.count - webViewListPosition)];
    [_webViewTitles removeObjectsInRange:NSMakeRange(webViewListPosition, _webViewList.count - webViewListPosition)];
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

- (void)newWebViewRequestFormWebView:(NSString *)decodedKeyword
{
    [self createMoeWebView:decodedKeyword];
}

- (void)newWebViewRequestFormSuggestions:(NSString *)keyword
{

    [self createMoeWebView:keyword];
    [_MainView sendSubviewToBack:_searchSuggestionsTableView];
    [self cancelKeyboard];
}


#pragma mark SearchSuggestion

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

#pragma mark MainViewSwitcher


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
                                 if (webViewListPosition == 0) {
                                     [_SearchTextField setText:@""];
                                 }else{
                                     [_SearchTextField setText:[_webViewTitles objectAtIndex:webViewListPosition -1]];
                                 }
                             }
                             completion:^(BOOL finished){
                                 [_MainView sendSubviewToBack:tempWebView];
                                 [tempWebView setFrame:_MasterInitial.frame];
                                 [_MainView bringSubviewToFront:_leftPanel];
                                 [_MainView bringSubviewToFront:_rightPanel];
                                 
                                 [tempWebView.scrollView setScrollsToTop:NO];
                                 if (webViewListPosition == 0) {
                                     [_mainPageScrollView setScrollsToTop:YES];
                                 }else{
                                     moegirlWebView * currentWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
                                     [currentWebView.scrollView setScrollsToTop:YES];
                                 }
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
                                     [_SearchTextField setText:[_webViewTitles objectAtIndex:webViewListPosition -1]];
                                 }
                                 completion:^(BOOL finished){
                                     [_MainView sendSubviewToBack:_mainPageScrollView];
                                     [_mainPageScrollView setFrame:_MasterInitial.frame];
                                     [_MainView bringSubviewToFront:_leftPanel];
                                     [_MainView bringSubviewToFront:_rightPanel];
                                     
                                     [_mainPageScrollView setScrollsToTop:NO];
                                     moegirlWebView * currentWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
                                     [currentWebView.scrollView setScrollsToTop:YES];
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
                                     [_SearchTextField setText:[_webViewTitles objectAtIndex:webViewListPosition -1]];
                                 }
                                 completion:^(BOOL finished){
                                     [_MainView sendSubviewToBack:tempWebView];
                                     [tempWebView setFrame:_MasterInitial.frame];
                                     [_MainView bringSubviewToFront:_leftPanel];
                                     [_MainView bringSubviewToFront:_rightPanel];
                                     
                                     [tempWebView.scrollView setScrollsToTop:NO];
                                     moegirlWebView * currentWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
                                     [currentWebView.scrollView setScrollsToTop:YES];
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

#pragma mark ProgressBarAndStatusLabel

- (void)progressAndStatusShowUp
{
    [_StatusLabel setText:@"开始加载"];
    [_ProgressBar setProgress:0];
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_StatusLabel setAlpha:1];
                         [_ProgressBar setAlpha:1];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)progressAndStatusHide
{
    [_StatusLabel setText:@"加载完成 !"];
    [_ProgressBar setProgress:1 animated:YES];
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_StatusLabel setAlpha:0];
                         [_ProgressBar setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [_ProgressBar setProgress:0];
                         
                     }];
}

- (void)progressAndStatusMakeStep:(float)step info:(NSString *)info
{
    step = (step / 100) + _ProgressBar.progress;
    [_ProgressBar setProgress:step animated:YES];
    if (info != nil) {
        [_StatusLabel setText:info];
    }
}

- (void)progressAndStatusSetToValue:(float)step info:(NSString *)info
{
    step = (step / 100);
    [_ProgressBar setProgress:step animated:YES];
    if (info != nil) {
        [_StatusLabel setText:info];
    }
}


#pragma mark SideMenuControl

- (void)presentMenu
{
    [self cancelKeyboard];
    menuSituation = YES;
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_resetButton setAlpha:1];
                         [_sideControlTableView setAlpha:1];
                         [_sideControlTableView setFrame:CGRectMake(_NavigationBar.frame.origin.x + _NavigationBar.frame.size.width - 200,
                                                                    _NavigationBar.frame.origin.y - 20,
                                                                    200,
                                                                    _NavigationBar.frame.size.height + _MainView.frame.size.height + 20)];
                         [_MainView setFrame:CGRectMake(_MainView.frame.origin.x - 200,
                                                        _MainView.frame.origin.y,
                                                        _MainView.frame.size.width,
                                                        _MainView.frame.size.height)];
                         [_NavigationBar setFrame:CGRectMake(_NavigationBar.frame.origin.x - 200,
                                                             _NavigationBar.frame.origin.y,
                                                             _NavigationBar.frame.size.width,
                                                             _NavigationBar.frame.size.height)];
                         
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)resetMenu
{
    menuSituation = NO;
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [_resetButton setAlpha:0];
                         [_sideControlTableView setAlpha:0];
                         [_MainView setFrame:CGRectMake(0,
                                                        _MainView.frame.origin.y,
                                                        _MainView.frame.size.width,
                                                        _MainView.frame.size.height)];
                         [_NavigationBar setFrame:CGRectMake(0,
                                                             _NavigationBar.frame.origin.y,
                                                             _NavigationBar.frame.size.width,
                                                             _NavigationBar.frame.size.height)];
                         [_sideControlTableView setFrame:CGRectMake(_NavigationBar.frame.origin.x + _NavigationBar.frame.size.width,
                                                                    _NavigationBar.frame.origin.y - 20,
                                                                    200,
                                                                    _NavigationBar.frame.size.height + _MainView.frame.size.height + 20)];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)menuButtonClick:(id)sender {
    if (menuSituation) {
        [self resetMenu];
    }else{
        [self presentMenu];
    }
}


- (void)ctrlPanelCallMainpage
{
    [self resetMenu];
    [_MainView bringSubviewToFront:_mainPageScrollView];    
    [_mainPageScrollView setFrame:CGRectMake(_MasterInitial.frame.origin.x - _MasterInitial.frame.size.width,
                                             _MasterInitial.frame.origin.y,
                                             _MasterInitial.frame.size.width,
                                             _MasterInitial.frame.size.height)];
    if (webViewListPosition != 0) {
        moegirlWebView * tmpWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
        [tmpWebView.scrollView setScrollsToTop:NO];
        webViewListPosition = 0;
    }
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                                    [_mainPageScrollView setFrame:_MasterInitial.frame];
                                 }
                                 completion:^(BOOL finished){
                                     [_MainView bringSubviewToFront:_leftPanel];
                                     [_MainView bringSubviewToFront:_rightPanel];
                                     [_mainPageScrollView setScrollsToTop:YES];
                                     [_SearchTextField setText:@""];
                                 }];
    
}

- (void)ctrlPanelCallRefresh
{
    [self resetMenu];
    if (webViewListPosition == 0) {
        [_mainPageScrollView loadMainPage:NO];
    } else {
        moegirlWebView * tmpWebView = [_webViewList objectAtIndex:webViewListPosition - 1];
        [tmpWebView loadContentWithEncodedKeyWord:[[_webViewTitles objectAtIndex:webViewListPosition -1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                         useCache:NO];
    }
}

- (void)ctrlPanelCallShare
{
    [self resetMenu];
    if (webViewListPosition == 0) {
        UIImage * shareImage = [self getImageFromView:_mainPageScrollView];
        NSURL * shareURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/meng-niang-bai-ke/id892053828"];
        NSString * shareText = @"我正在使用萌娘百科iOS客户端浏览万物皆可萌的百科全书——萌娘百科！你也快来试试吧！";
        [self shareText:shareText andImage:shareImage andUrl:shareURL];
    }else{
        UIImage * shareImage = [self getImageFromView:[_webViewList objectAtIndex:webViewListPosition - 1]];
        NSURL * shareURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/meng-niang-bai-ke/id892053828"];
        NSString * keyword = [_webViewTitles objectAtIndex:webViewListPosition -1];
        NSString * shareText = [NSString stringWithFormat:@"#萌娘百科iOS客户端#【%@】http://zh.moegirl.org/%@ ",keyword,[keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self shareText:shareText andImage:shareImage andUrl:shareURL];
    }
}

- (void)ctrlPanelCallSettings
{
    [self resetMenu];
    [self performSegueWithIdentifier:@"GoSettings" sender:nil];
}

- (void)ctrlPanelCallAbout
{
    [self resetMenu];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (UIImage *)getImageFromView:(UIView *)orgView{
        CGSize imageSize = [[UIScreen mainScreen] bounds].size;
        if (NULL != UIGraphicsBeginImageContextWithOptions)
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        else
            UIGraphicsBeginImageContext(imageSize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Iterate over every window from back to front
        for (UIWindow *window in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the coordinate space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                // Apply the window's transform about the anchor point
                CGContextConcatCTM(context, [window transform]);
                // Offset by the portion of the bounds left of and above the anchor point
                CGContextTranslateCTM(context,
                                      -[window bounds].size.width * [[window layer] anchorPoint].x,
                                      -[window bounds].size.height * [[window layer] anchorPoint].y);
                
                // Render the layer hierarchy to the current context
                [[window layer] renderInContext:context];
                
                // Restore the context
                CGContextRestoreGState(context);
            }
        }
        
        // Retrieve the screenshot image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image;
}

@end

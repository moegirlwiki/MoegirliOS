//
//  mcViewController.m
//  moegirlwiki
//
//  Created by Chen Junlin on 14-7-15.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcViewController.h"

@interface mcViewController ()


@property (strong,nonatomic) NSMutableData *RecievePool;
@property (strong,nonatomic) NSMutableDictionary *HistoryPool;
@property (strong,nonatomic) NSMutableDictionary *NamePool;
@property (strong,nonatomic) NSMutableDictionary *PositionPool;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *BackwardButton;
@property (weak, nonatomic) IBOutlet UIButton *ForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *HomepageButton;
@property (weak, nonatomic) IBOutlet UIButton *ReportButton;
@property (weak, nonatomic) IBOutlet UIView *popoutView;
@property (weak, nonatomic) IBOutlet UIButton *HideMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *RefreshButton;
@property (weak, nonatomic) IBOutlet UIView *aboutView;


- (IBAction)MenuButton:(id)sender;
- (IBAction)BackToTop:(id)sender;
- (IBAction)HideMenu:(id)sender;
- (IBAction)GoBackward:(id)sender;
- (IBAction)GoForward:(id)sender;
- (IBAction)GoHomePage:(id)sender;
- (IBAction)SendReport:(id)sender;
- (IBAction)AboutApp:(id)sender;
- (IBAction)GoRefresh:(id)sender;

- (void)ProgressReset;
- (void)ProgressGo:(float)step;
- (void)MainMission;
- (void)SendToInterface:(NSString *)content;
- (NSString *)PrepareContent:(NSString *)content;


@end


@implementation mcViewController

NSString * baseID = @"moegirl-app-1.2";//用于GoogleAnalytics等统计工具识别   (15个字符)
NSString * homepagelink = @"https://masterchan.me/moegirlwiki/index1.2.php";//主页所在的位置

NSString * API = @"http://zh.moegirl.org/%@";//用于获取页面的主要链接

NSString * DefaultPage =@"<!DOCTYPE html><html lang=\"zh-CN\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><link rel=\"stylesheet\" type=\"text/css\" href=\"https://masterchan.me/moegirlwiki/style.css\"></head><body><div id=\"content\"><h3>请接入互联网</h3></div></body></html>";

NSString * tempError = @"";
NSURL * tempURL;

CGPoint PagePosition;

NSTimeInterval RequestTimeOutSec = 20;

NSInteger jumptotarget = 0;
NSInteger pointer_max = 0;
NSInteger pointer_current =0;

NSURLConnection * RequestConnection;




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //监听UIWebView 的事件
    [_MasterWebView setDelegate:self];
    
    
    //监听UISearchBar 的事件
    [_SearchBox setDelegate:self];
    
    //调整进度条的大小
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 20.0f);
    [_progressBar setTransform:transform];
    
    //圆角设置
    _BackwardButton.layer.cornerRadius = 3;
    _ForwardButton.layer.cornerRadius = 3;
    _HomepageButton.layer.cornerRadius = 3;
    _ReportButton.layer.cornerRadius = 3;
    _RefreshButton.layer.cornerRadius = 3;
    _popoutView.layer.cornerRadius = 5;
    _aboutView.layer.cornerRadius = 5;
    _BackwardButton.layer.masksToBounds = YES;
    _ForwardButton.layer.masksToBounds = YES;
    _HomepageButton.layer.masksToBounds = YES;
    _ReportButton.layer.masksToBounds = YES;
    _RefreshButton.layer.masksToBounds = YES;
    _popoutView.layer.masksToBounds = YES;
    _aboutView.layer.masksToBounds = YES;
    
    //初始化历史记录
    _NamePool = [[NSMutableDictionary alloc] init];
    _HistoryPool = [[NSMutableDictionary alloc] init];
    _PositionPool = [[NSMutableDictionary alloc] init];
    pointer_current = 0;
    pointer_max = 0;
    
    //初始化页面
    [self MainMission];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_NamePool removeAllObjects];
    [_HistoryPool removeAllObjects];
    [_PositionPool removeAllObjects];
    pointer_current = 0;
    pointer_max = 0;
}

//得到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (connection==RequestConnection) {
        _RecievePool = [NSMutableData data];
        NSLog(@"[Request] 得到服务器的响应");
    }
}

//开始接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection==RequestConnection) {
        [_RecievePool appendData:data];
        NSLog(@"[Request] 接收到了服务器传回的数据");
        [self ProgressGo:0.1];
    }
}

//错误处理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection==RequestConnection) {
        NSLog(@"[Request] 发生错误！");
        [self SendToInterface:DefaultPage];
    }
    NSLog(@"%@",error);
    tempError = [error localizedDescription];
}

//结束接收数据
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection==RequestConnection) {
        NSLog(@"[Request] 数据接收完成！");
        [self SendToInterface:[[NSString alloc] initWithData:_RecievePool encoding:NSUTF8StringEncoding]];
    }
}

//完成绘制标识事件
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"页面完成绘制！");
    [self ProgressReset];
    if (jumptotarget != 0) {
        jumptotarget = 0;
        UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
        [scrollView setContentOffset:PagePosition animated:YES];
    }
}

//页面绘制错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"页面绘制出错！");
}

//页面绘制事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSString *link = [[request URL] absoluteString];
        if ([link hasPrefix:[NSString stringWithFormat:@"https://masterchan.me/%@/",baseID]]) {
            link = [link substringFromIndex:38];
            [_SearchBox setText:[link stringByRemovingPercentEncoding]];
            [self MainMission];
            return NO;
        } else if ([link hasPrefix:@"http://zh.moegirl.org/"]){
            link = [link substringFromIndex:22];
            if ([link hasPrefix:baseID]) {//如果带有统计标签的，需要将其移除
                link = [link substringFromIndex:16];
            }
            if ([link hasPrefix:@"index.php"]) {
                //提示用户该页面无法渲染，是否打开浏览器
                NSString *Title = @"本程序无法渲染该页面，是否在Safari中打开 ？";
                UIAlertView *PageWarning=[[UIAlertView alloc] initWithTitle:Title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
                PageWarning.alertViewStyle=UIAlertViewStyleDefault;
                [PageWarning show];
                tempURL = [request URL];
                return NO;
            }else if([link hasPrefix:[NSString stringWithFormat:@"%@#",[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]){//如果是目录的页面内部链接 则直接交给WebView
                return YES;
            }else{
                [_SearchBox setText:[link stringByRemovingPercentEncoding]];
                [self MainMission];
                return NO;
            }
        }else{
            //提示用户该连接是外链，是否打开浏览器
            NSString *Title = @"这是一个外链，您确定要打开这个链接吗？";
            UIAlertView *OutlinkWarning=[[UIAlertView alloc] initWithTitle:Title message:[[request URL] absoluteString] delegate:self cancelButtonTitle:@"打开链接" otherButtonTitles:@"取消",nil];
            OutlinkWarning.alertViewStyle=UIAlertViewStyleDefault;
            tempURL = [request URL];
            [OutlinkWarning show];
            return NO;
        }
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * tmpstring=[alertView buttonTitleAtIndex:buttonIndex];
    if ([tmpstring isEqualToString:@"确定"]) {
        [[UIApplication sharedApplication] openURL:tempURL];
    }else if ([tmpstring isEqualToString:@"打开链接"]){
        [[UIApplication sharedApplication] openURL:tempURL];
    }
}

- (IBAction)MenuButton:(id)sender
{
    if ([_popoutView isHidden]) {
        [_popoutView setHidden:NO];
        [_aboutView setHidden:YES];
        [_HideMenuButton setHidden:NO];
    } else {
        [_popoutView setHidden:YES];
        [_HideMenuButton setHidden:YES];
        [_aboutView setHidden:YES];
    }
}

- (IBAction)BackToTop:(id)sender
{
    if ([_MasterWebView subviews]) {
        UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    [_aboutView setHidden:YES];
}

- (IBAction)HideMenu:(id)sender {
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    [_aboutView setHidden:YES];
}

- (IBAction)GoBackward:(id)sender {
    NSLog(@"往后");
    if (pointer_current > 1) {
        [self ProgressGo:0.8];
        UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
        [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%d",pointer_current]];
        pointer_current --;
        [_SearchBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]]];
        NSString *baselink;
        if (![_SearchBox.text isEqualToString:@"首页"]) {
            baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        } else {
            baselink = [NSString stringWithFormat:@"https://masterchan.me/%@/",baseID];
        }
        [_MasterWebView loadHTMLString:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]] baseURL:[NSURL URLWithString:baselink]];
        PagePosition = CGPointFromString([_PositionPool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]]);
        jumptotarget = 1;
        if (pointer_current == 1) {
            [_BackwardButton setEnabled:NO];
        }
        if (pointer_current < pointer_max) {
            [_ForwardButton setEnabled:YES];
        }
    }
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
}

- (IBAction)GoForward:(id)sender {
    NSLog(@"往前");
    if (pointer_current < pointer_max) {
        [self ProgressGo:0.8];
        UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
        [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%d",pointer_current]];
        pointer_current ++;
        [_SearchBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]]];
        NSString *baselink;
        if (![_SearchBox.text isEqualToString:@"首页"]) {
            baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        } else {
            baselink = [NSString stringWithFormat:@"https://masterchan.me/%@/",baseID];
        }
        [_MasterWebView loadHTMLString:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]] baseURL:[NSURL URLWithString:baselink]];
        PagePosition = CGPointFromString([_PositionPool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]]);
        jumptotarget = 1;
        if (pointer_current == pointer_max) {
            [_ForwardButton setEnabled:NO];
        }
        if (pointer_current > 1) {
            [_BackwardButton setEnabled:YES];
        }
    }
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
}

- (IBAction)GoHomePage:(id)sender {
    [_SearchBox setText:@"首页"];
    [self MainMission];
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
}

- (IBAction)SendReport:(id)sender {
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    //发送错误报告
    NSString *RequestURL = [NSString stringWithFormat:@"https://masterchan.me/moegirlwiki/debug/send1.1.php"];
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
    [TheRequest setHTTPMethod:@"POST"];
    NSData * data = [[NSString stringWithFormat:@"page=%@&error=%@",_SearchBox.text,tempError] dataUsingEncoding:NSUTF8StringEncoding];
    [TheRequest setHTTPBody:data];
    RequestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:nil];
    //提示信息
    NSString *Title = @" 谢谢！";
    UIAlertView *ReportWarning=[[UIAlertView alloc] initWithTitle:Title message:@"报告已经发送，我们将会尽快处理！" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    ReportWarning.alertViewStyle=UIAlertViewStyleDefault;
    [ReportWarning show];
}

- (IBAction)AboutApp:(id)sender {
    [_aboutView setHidden:NO];
    [_popoutView setHidden:YES];
}

- (IBAction)GoRefresh:(id)sender {
    [self MainMission];
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    [self MainMission];
}

-(void)ProgressReset
{
    [_progressBar setProgress:0];
}

- (void)ProgressGo:(float)step
{
    float t = step + _progressBar.progress;
    if (t > 1) {
        [_progressBar setProgress:1];
    } else {
        [_progressBar setProgress:t];
    }
}

- (void)MainMission
{
    NSLog(@"开始任务");
    
    NSString *ItemName = [_SearchBox text];
    
    if ([[ItemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        //空白字符串不执行任务
        NSLog(@"空白字符串不进行工作");
    } else {
        if ([ItemName isEqualToString:@"首页"]) {
            //开始加载首页
            NSLog(@"检索 首页");
            
            [self ProgressGo:0.35];
            
            NSString *RequestURL = homepagelink;
            
            NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOutSec];
            [TheRequest setHTTPMethod:@"GET"];
            RequestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
        } else {
            //开始加载词条
            NSLog(@"检索 %@",ItemName);
            
            [self ProgressGo:0.1];
            
            NSString *RequestURL = [NSString stringWithFormat:API,[ItemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:RequestTimeOutSec];
            [TheRequest setHTTPMethod:@"GET"];
            RequestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
        }
        NSLog(@"程序已经发送请求，等待响应中");
    }
}

- (void)SendToInterface:(NSString *)content
{
    [self ProgressGo:0.15];
    NSString *baselink;
    if (![_SearchBox.text isEqualToString:@"首页"]) {
        NSLog(@"开始处理页面");
        content = [self PrepareContent:content];
        baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        baselink = [NSString stringWithFormat:@"https://masterchan.me/%@/",baseID];
    }
    
    //取得页面阅读到的位置
    UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
    [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%d",pointer_current]];
    
    //NSLog(@"%@",[NSValue valueWithCGPoint:scrollView.contentOffset]);
    
    if (pointer_current< 10) {
        pointer_current ++;
        [_HistoryPool setObject:content forKey:[NSString stringWithFormat:@"%d",pointer_current]];
        [_NamePool setObject:_SearchBox.text forKey:[NSString stringWithFormat:@"%d",pointer_current]];
        
        [_ForwardButton setEnabled:NO];
        if (pointer_current != 1) {
            [_BackwardButton setEnabled:YES];
        }
    }else{
        NSInteger i;
        for (i=2; i<=10; i++) {
            [_HistoryPool setObject:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",(i-1)]];
            [_NamePool setObject:[_NamePool objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",(i-1)]];
            [_PositionPool setObject:[_PositionPool objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",(i-1)]];
        }
        [_HistoryPool setObject:content forKey:[NSString stringWithFormat:@"%d",10]];
        [_NamePool setObject:_SearchBox.text forKey:[NSString stringWithFormat:@"%d",10]];
        
        [_ForwardButton setEnabled:NO];
        [_BackwardButton setEnabled:YES];
    }
    pointer_max = pointer_current;
    [_MasterWebView loadHTMLString:content baseURL:[NSURL URLWithString:baselink]];
    NSLog(@"发送页面到界面");
}


- (NSString *)PrepareContent:(NSString *)content
{
    
    [self ProgressGo:0.05];
    NSString *regexstr = @"<div id=\"siteSub\">.*?</div>";
    NSRange range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    
    [self ProgressGo:0.05];
    regexstr = @"<div id=\"mw-page-base\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self ProgressGo:0.05];
    regexstr = @"<div id=\"mw-head-base\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self ProgressGo:0.05];
    regexstr = @"<div id=\"jump-to-nav\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self ProgressGo:0.05];
    regexstr = @"<div id=\'mw-data-after-content\'>[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self ProgressGo:0.05];
    regexstr = @"<div id=\"mw-navigation\">[\\s\\S]*?<div style=\"clear:both\"></div>[\\s\\S]*?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self ProgressGo:0.05];
    regexstr = @" id=\"content\"";
    range = [content rangeOfString:regexstr];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    
    
    [self ProgressGo:0.05];
    regexstr = @"<div id=\"siteNotice\">[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    
    [self ProgressGo:0.05];
    //添加定制样式
    regexstr = @"</body>";
    range = [content rangeOfString:regexstr];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        NSString *style= @"<style> body{padding:10px !important;overflow-x:hidden !important;} p{clear:both !important;} #mw-content-text{ max-width: 100%; overflow: hidden;} .wikitable, table.navbox{ display:block; overflow-y:scroll;} .nowraplinks.mw-collapsible{width:300% !important; font-size:10px !important;} .navbox-title span{font-size:10px !important;} .backToTop{display:none !important;} </style> ";
        content = [NSString stringWithFormat:@"%@%@%@",[content substringWithRange:NSMakeRange(0, range.location)],style,[content substringWithRange:NSMakeRange(range.location, (content.length - range.location))]];
    }
    

    return content;
}

@end

//
//  mcViewController.m
//  moegirlwiki
//
//  Created by Chen Junlin on 14-7-15.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcViewController.h"

@interface mcViewController ()


@property (strong,nonatomic) NSMutableData *RecievePool;//提供给 页面加载 专用
@property (strong,nonatomic) NSMutableData *RecievePool2;//提供给 摇一摇  专用
@property (strong,nonatomic) NSMutableData *RecievePool3;//提供给 Mainpage  专用
@property (strong,nonatomic) NSMutableDictionary *HistoryPool;
@property (strong,nonatomic) NSMutableDictionary *NamePool;
@property (strong,nonatomic) NSMutableDictionary *PositionPool;
@property (strong,nonatomic) NSMutableDictionary *RandomPool;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *BackwardButton;
@property (weak, nonatomic) IBOutlet UIButton *ForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *HomepageButton;
@property (weak, nonatomic) IBOutlet UIButton *ReportButton;
@property (weak, nonatomic) IBOutlet UIView *popoutView;
@property (weak, nonatomic) IBOutlet UIButton *HideMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *RefreshButton;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UIButton *RandomButton;
@property (weak, nonatomic) IBOutlet UIButton *BackToTopButton;
@property (weak, nonatomic) IBOutlet UIButton *versionbutton;
@property (weak, nonatomic) IBOutlet UILabel *GoBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *ForwardLabel;
@property (weak, nonatomic) IBOutlet UIButton *SettingButton;


- (IBAction)MenuButton:(id)sender;
- (IBAction)BackToTop:(id)sender;
- (IBAction)HideMenu:(id)sender;
- (IBAction)GoBackward:(id)sender;
- (IBAction)GoForward:(id)sender;
- (IBAction)GoHomePage:(id)sender;
- (IBAction)SendReport:(id)sender;
- (IBAction)GoRandom:(id)sender;
- (IBAction)AboutApp:(id)sender;
- (IBAction)GoRefresh:(id)sender;
- (IBAction)SwipeBack:(id)sender;
- (IBAction)SwipeForward:(id)sender;
- (IBAction)SettingButton:(id)sender;


- (void)ProgressReset;
- (void)ProgressGo:(float)step;
- (void)MainMission;
- (void)SendToInterface:(NSString *)content;
- (NSString *)PrepareContent:(NSString *)content;
- (void)PrepareRandomPopout:(NSString *)content;
- (void)SendRandomRequest;
- (void)PrepareHomepage;
- (void)CallFromScheme;

@end


@implementation mcViewController

NSString * baseID = @"moegirl-app-1.5";//用于GoogleAnalytics等统计工具识别   (15个字符)
NSString * homepagelink = @"https://masterchan.me/moegirlwiki/index1.5.php";//主页所在的位置

NSString * API = @"http://zh.moegirl.org/%@";//用于获取页面的主要链接

NSString * APIrandom = @"https://masterchan.me/moegirlwiki/random1.5.php";//获取随机页面的API
//如果摇晃后再向服务器调用数据，反应将会过于缓慢，于是多获取几个以备不时之需


NSString * DefaultPage =@"<!DOCTYPE html><html lang='zh-CN'><head>	<!--%@-->	<meta charset='UTF-8'>	<meta name='viewport' content='width=device-width, initial-scale=1'></head><body>	<style type='text/css'>	ul{padding-left: 20px;} body{		font-size: 11px;	}	</style>	<div id='content'>		<h3>出现了点问题哎~~!</h3>		<p>错误信息: <strong>%@</strong></p>		<p>您可以做的事情有：</p>		<ul>			<li>提交此页面的错误报告，帮助我们改进程序</li>			<li>到网络环境更好的地方再试一试</li>			<li>使用黑科技保护您的手机与萌百服务器之间的连接</li>		</ul>	</div></body></html>";

NSString * tempError = @"";
NSString * r18l = @"off";
NSURL * tempURL;
NSString * tempTitle;

CGPoint PagePosition;

NSTimeInterval RequestTimeOutSec = 20;

NSInteger jumptotarget = 0;
NSInteger pointer_max = 0;
NSInteger pointer_current = 0;
NSInteger isRefresh = 0;

NSInteger InstanceLock = 0; //进程同步锁

NSURLConnection * RequestConnection;
NSURLConnection * RequestConnectionForRandom;
NSURLConnection * RequestConnectionForMainpage;




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //监听UIWebView 的事件
    [_MasterWebView setDelegate:self];
    
    
    //监听UISearchBar 的事件
    [_SearchBox setDelegate:self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
    
    //调整进度条的大小
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 20.0f);
    [_progressBar setTransform:transform];
    
    //圆角设置
    _BackwardButton.layer.cornerRadius = 3;
    _ForwardButton.layer.cornerRadius = 3;
    _HomepageButton.layer.cornerRadius = 3;
    _ReportButton.layer.cornerRadius = 3;
    _RefreshButton.layer.cornerRadius = 3;
    _RandomButton.layer.cornerRadius = 3;
    _SettingButton.layer.cornerRadius = 3;
    _GoBackLabel.layer.cornerRadius = 3;
    _popoutView.layer.cornerRadius = 5;
    _aboutView.layer.cornerRadius = 5;
    _BackwardButton.layer.masksToBounds = YES;
    _ForwardButton.layer.masksToBounds = YES;
    _HomepageButton.layer.masksToBounds = YES;
    _ReportButton.layer.masksToBounds = YES;
    _RefreshButton.layer.masksToBounds = YES;
    _RandomButton.layer.masksToBounds = YES;
    _SettingButton.layer.masksToBounds = YES;
    _GoBackLabel.layer.masksToBounds = YES;
    _popoutView.layer.masksToBounds = YES;
    _aboutView.layer.masksToBounds = YES;
    
    }else{
        //[_progressBar setHidden:YES];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 8.0f);
        [_progressBar setTransform:transform];
        [_BackToTopButton setHidden:YES];
        [_versionbutton setHidden:YES];
        
    }
    
    //初始化历史记录
    _NamePool = [[NSMutableDictionary alloc] init];
    _HistoryPool = [[NSMutableDictionary alloc] init];
    _PositionPool = [[NSMutableDictionary alloc] init];
    _RandomPool = [[NSMutableDictionary alloc] init];
    pointer_current = 0;
    pointer_max = 0;
    
    //初始化页面
    [self MainMission];
    
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    if ([[defaultdata objectForKey:@"version"] isEqualToString:baseID]) {
        [_RandomPool setObject:[defaultdata objectForKey:@"ran0"] forKey:@"0"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran1"] forKey:@"1"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran2"] forKey:@"2"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran3"] forKey:@"3"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran4"] forKey:@"4"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran5"] forKey:@"5"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran6"] forKey:@"6"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran7"] forKey:@"7"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran8"] forKey:@"8"];
        [_RandomPool setObject:[defaultdata objectForKey:@"ran9"] forKey:@"9"];
        r18l = [defaultdata objectForKey:@"retl"];
    }else{
        [self SendRandomRequest];
        [defaultdata setObject:@"off" forKey:@"retl"];
        [defaultdata setObject:@"SwipeMode" forKey:@"ON"];
        [defaultdata setObject:@"NoImgMode" forKey:@"OFF"];
        [defaultdata synchronize];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CallFromScheme)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
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
    }else if (connection==RequestConnectionForRandom){
        _RecievePool2 = [NSMutableData data];
        NSLog(@"[Random] 得到服务器的响应");
    }else if (connection==RequestConnectionForMainpage){
        _RecievePool3 = [NSMutableData data];
        NSLog(@"[Mainpage] 得到服务器的响应");
    }
}

//开始接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection==RequestConnection) {
        [_RecievePool appendData:data];
        NSLog(@"[Request] 接收到了服务器传回的数据");
        [self ProgressGo:0.038];
    }else if (connection==RequestConnectionForRandom){
        [_RecievePool2 appendData:data];
        NSLog(@"[Random] 接收到了服务器传回的数据");
    }else if (connection==RequestConnectionForMainpage){
        [_RecievePool3 appendData:data];
    }
}

//错误处理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString * errorinfo;
    if (connection==RequestConnection) {
        NSLog(@"[Request] 发生错误！");
        errorinfo = [NSString stringWithFormat:@"\n%@\n%@\n",
                                [error localizedDescription],
                                [[error userInfo] objectForKey:NSURLErrorFailingURLErrorKey]
                                ];
        [self SendToInterface:[NSString stringWithFormat:DefaultPage,errorinfo,[error localizedDescription]]];
    }else if (connection==RequestConnectionForMainpage){
        NSLog(@"[Mainpage] 发生错误！");
        //NSLog(@"%@",error);
        if ([error code]!=-1009) {
            //如果萌百服务器处于某种原因不能够打开则弹出错误提示
            NSString *Title = @"萌百服务器似乎无法连接?!?!";
            UIAlertView *PageWarning=[[UIAlertView alloc] initWithTitle:Title message:@"服务器可能暂时下线了，请留意各媒体上更新姬发布的消息，为您带来的不便敬请谅解" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            PageWarning.alertViewStyle=UIAlertViewStyleDefault;
            [PageWarning show];
        }
        _RecievePool3 = nil;
        InstanceLock ++;
        [self PrepareHomepage];
    }
    //NSLog(@"%@",errorinfo);
    tempError = [error localizedDescription];
}

//结束接收数据
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection==RequestConnection) {
        NSLog(@"[Request] 数据接收完成！");
        if ([_SearchBox.text isEqualToString:@"首页"]) {
            InstanceLock ++;
            [self PrepareHomepage];
        }else{
            [self SendToInterface:[[NSString alloc] initWithData:_RecievePool encoding:NSUTF8StringEncoding]];
        }
    }else if (connection==RequestConnectionForRandom) {
        NSLog(@"[Random] 数据接收完成！");
        //NSLog(@"%@",[[NSString alloc] initWithData:_RecievePool2 encoding:NSUTF8StringEncoding]);
        [self PrepareRandomPopout:[[NSString alloc] initWithData:_RecievePool2 encoding:NSUTF8StringEncoding]];
        
    }else if (connection==RequestConnectionForMainpage) {
        NSLog(@"[Mainpage] 数据接收完成！");
        InstanceLock ++;
        [self PrepareHomepage];
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
            [_SearchBox setText:[link stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
                [_SearchBox setText:[link stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    if ([tmpstring isEqualToString:@"确定"]) {//你是否在Safari里面看网页
        [[UIApplication sharedApplication] openURL:tempURL];
    }else if ([tmpstring isEqualToString:@"打开链接"]){//你是否打开外链
        [[UIApplication sharedApplication] openURL:tempURL];
    }else if ([tmpstring isEqualToString:@"查看"]){//你摇到了 xxx
        [_SearchBox setText:tempTitle];
        [self MainMission];
    }else if ([tmpstring isEqualToString:@"否"]){//你是否已经年满18周岁

            [self ProgressGo:0.45];
            UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
            [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
            pointer_current --;
            [_SearchBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]]];
            NSString *baselink;
            if (![_SearchBox.text isEqualToString:@"首页"]) {
                baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            } else {
                baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/",baseID];
            }
            [_MasterWebView loadHTMLString:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]] baseURL:[NSURL URLWithString:baselink]];
            PagePosition = CGPointFromString([_PositionPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]]);
            jumptotarget = 1;
            if (pointer_current == 1) {
                [_BackwardButton setEnabled:NO];
            }
            pointer_max --;
            if (pointer_current < pointer_max) {
                [_ForwardButton setEnabled:YES];
            }

    }
}

- (IBAction)MenuButton:(id)sender
{
    if ([_popoutView isHidden]) {
        [_popoutView setHidden:NO];
        [_aboutView setHidden:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0) {
            [_HideMenuButton setHidden:NO];
        }
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
        [self ProgressGo:0.45];
        UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
        [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
        pointer_current --;
        [_SearchBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]]];
        NSString *baselink;
        if (![_SearchBox.text isEqualToString:@"首页"]) {
            baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        } else {
            baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/",baseID];
        }
        [_MasterWebView loadHTMLString:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]] baseURL:[NSURL URLWithString:baselink]];
        PagePosition = CGPointFromString([_PositionPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]]);
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
        [self ProgressGo:0.45];
        UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
        [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
        pointer_current ++;
        [_SearchBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]]];
        NSString *baselink;
        if (![_SearchBox.text isEqualToString:@"首页"]) {
            baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        } else {
            baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/",baseID];
        }
        [_MasterWebView loadHTMLString:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]] baseURL:[NSURL URLWithString:baselink]];
        PagePosition = CGPointFromString([_PositionPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]]);
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    UIViewController * theview = segue.destinationViewController;
    
    NSString * reportTitle = _SearchBox.text;
    NSString * reportContent = [_HistoryPool objectForKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
    NSString * reportErrorInfo = tempError;
    
    if (reportContent.length > 200) {
        reportContent = [reportContent substringToIndex:200];
    }
    
    [theview setValue:reportTitle forKeyPath:@"rtitle"];
    [theview setValue:reportContent forKeyPath:@"rcontent"];
    [theview setValue:reportErrorInfo forKeyPath:@"rerror"];
    
    //将第一个 view的参数准备给下一个view

}

- (IBAction)SendReport:(id)sender {
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    
    [self performSegueWithIdentifier:@"sendReport" sender:nil];
    //将到mcReportController.m处理
}

- (IBAction)GoRandom:(id)sender {
    NSInteger k = (int)(arc4random()%10);
    NSString *theTitle = [_RandomPool objectForKey:[NSString stringWithFormat:@"%ld",(long)k]];
    [_SearchBox setText:theTitle];
    [self MainMission];
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    [self SendRandomRequest];
}

- (IBAction)AboutApp:(id)sender {
    [_aboutView setHidden:NO];
    [_popoutView setHidden:YES];
}

- (IBAction)GoRefresh:(id)sender {
    isRefresh = 1;
    pointer_current --;
    [self MainMission];
    
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
}

//向右滑动－退后
- (IBAction)SwipeBack:(id)sender {
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    if ([[defaultdata objectForKey:@"SwipeMode"]isEqualToString:@"ON"]) {
        NSLog(@"检测到向后滑动");
        if (pointer_current > 1) {
            NSLog(@"传递参数");
            [_ForwardLabel setHidden:YES];
            [_GoBackLabel setHidden:NO];
            [self GoBackward:nil];
            [self performSelector:@selector(resetLabel:) withObject:nil afterDelay:1.2];
        }
    }
}


//向左滑动－向前
- (IBAction)SwipeForward:(id)sender {
    NSLog(@"检测到向前滑动");
    if (pointer_current < pointer_max) {
        NSLog(@"传递参数");
        [_GoBackLabel setHidden:YES];
        [_ForwardLabel setHidden:NO];
        [self GoForward:nil];
        [self performSelector:@selector(resetLabel:) withObject:nil afterDelay:1.2];
    }
}

- (IBAction)SettingButton:(id)sender {
    [_popoutView setHidden:YES];
    [_HideMenuButton setHidden:YES];
    
    [self performSegueWithIdentifier:@"showSettings" sender:nil];
    //将到mcSettingsController.m处理
}

- (void)resetLabel:(NSObject *)theobj {
    [_GoBackLabel setHidden:YES];
    [_ForwardLabel setHidden:YES];
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
    
    [self ProgressReset];
    
    [RequestConnection cancel];
    [RequestConnectionForMainpage cancel];
    
    
    if ([[ItemName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        //空白字符串不执行任务
        NSLog(@"空白字符串不进行工作");
    } else {
        if ([ItemName isEqualToString:@"Mainpage"]) {
            [_SearchBox setText:@"首页"];
            ItemName = @"首页";
        }
        
        if ([ItemName isEqualToString:@"首页"]) {
            //开始加载首页
            NSLog(@"检索 首页");
            
            NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
            if (([defaultdata objectForKey:@"homepage"] == nil)||(isRefresh == 1)) {
                //如果缓存中没有首页的数据或者是刷新请求，则向网络请求首页的数据
                [self ProgressGo:0.35];
                
                InstanceLock = 0;
                
                //向masterchan.me请求框架
                NSString *RequestURL = homepagelink;
                NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
                [TheRequest setHTTPMethod:@"GET"];
                RequestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
                
                //向zh.moegirl.org请求内容
                
                NSMutableURLRequest * TheRequest2 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:API,@"Mainpage"]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
                [TheRequest2 setHTTPMethod:@"POST"];
                RequestConnectionForMainpage = [[NSURLConnection alloc]initWithRequest:TheRequest2 delegate:self];
                
                //======================
                
                isRefresh = 0;
            } else {
                //如果缓存中有首页的数据，这直接SendToInterface
                [self SendToInterface:[defaultdata objectForKey:@"homepage"]];
                //----------------------------------------
            }
            
            
        } else {
            //开始加载词条
            NSLog(@"检索 %@",ItemName);
            
            [self ProgressGo:0.1];
            
            NSURLRequestCachePolicy loadType = NSURLRequestReturnCacheDataElseLoad;
            if (isRefresh == 1) {
                loadType = NSURLRequestReloadIgnoringLocalCacheData;
                isRefresh = 0;
            }
            
            NSString *RequestURL = [NSString stringWithFormat:API,[ItemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:loadType timeoutInterval:RequestTimeOutSec];
            
            [TheRequest setHTTPMethod:@"GET"];
            RequestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
        }
        NSLog(@"程序已经发送请求，等待响应中");
    }
}

- (void)SendToInterface:(NSString *)content
{
    NSString *baselink;
    if (![_SearchBox.text isEqualToString:@"首页"]) {
        
        //如果这个页面是没有结果的页面，将地址栏修改成查询模式然后重新加载
        
        NSString * regexstr = @"此页目前没有内容，您可以在其它页";
        NSRange range = [content rangeOfString:regexstr];
        if (range.location != NSNotFound) {
            NSLog(@"==无结果！==");
            _SearchBox.text = [NSString stringWithFormat:@"Special:搜索/%@",_SearchBox.text];
            [self MainMission];
            return;
        }
        //return;
        
        
        NSLog(@"开始处理页面");
        content = [self PrepareContent:content];
        baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/%@",baseID,[_SearchBox.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        baselink = [NSString stringWithFormat:@"http://zh.moegirl.org/%@/",baseID];
    }
    
    //取得页面阅读到的位置
    UIScrollView* scrollView = [[_MasterWebView subviews] objectAtIndex:0];
    [_PositionPool setObject:NSStringFromCGPoint(scrollView.contentOffset) forKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
    
    
    if (pointer_current< 10) {
        pointer_current ++;
        [_HistoryPool setObject:content forKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
        [_NamePool setObject:_SearchBox.text forKey:[NSString stringWithFormat:@"%ld",(long)pointer_current]];
        
        [_ForwardButton setEnabled:NO];
        if (pointer_current != 1) {
            [_BackwardButton setEnabled:YES];
        }
    }else{
        NSInteger i;
        for (i=2; i<=10; i++) {
            [_HistoryPool setObject:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] forKey:[NSString stringWithFormat:@"%ld",(long)(i-1)]];
            [_NamePool setObject:[_NamePool objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] forKey:[NSString stringWithFormat:@"%ld",(long)(i-1)]];
            [_PositionPool setObject:[_PositionPool objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] forKey:[NSString stringWithFormat:@"%ld",(long)(i-1)]];
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
    
    
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    if ([[defaultdata objectForKey:@"NoImgMode"]isEqualToString:@"ON"]) {
        NSLog(@"无图模式开启");
        [self ProgressGo:0.05];
        regexstr = @"<img .*?>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@""];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
    }
    
    
    //Template:Vocaloid Songbox
    [self ProgressGo:0.05];
    regexstr = @"align=\"center\" width=\"450px\" style=\"border:0px; text-align:center; line-height:1.3em;\" class=\"infotemplate\"";
    range = [content rangeOfString:regexstr];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@"align=\"center\" style=\"border:0px; text-align:center; line-height:1.3em;width:100%;margin-left:-5px;\" class=\"infotemplate\""];
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
    //banner修正
    content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:80%;" withString:@"<table class=\"common-box\" style=\""];
    content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:350px;" withString:@"<table class=\"common-box\" style=\""];
    
    [self ProgressGo:0.05];
    //R18修正
    regexstr = @"<script language=\"javascript\"[\\s\\S]*?<div id=x18[\\s\\S]*?</div>[\\s\\S]*?</script>[\\s\\S]*<span style=\"position:fixed;top: 0px;[\\s\\S]*width=\"227\" height=\"83\" /></a></span>[\\s\\S]*?</p>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        NSLog(@"此词条为 R18 限制");
        if ([r18l isEqualToString:@"xxoo"]) {
            NSString *Title = @"R-18 限制";
            UIAlertView *R18Warning=[[UIAlertView alloc] initWithTitle:Title message:@"你是否年满18周岁？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否",nil];
            R18Warning.alertViewStyle=UIAlertViewStyleDefault;
            [R18Warning show];
        } else {
            NSString *Title = @"R-18 限制";
            UIAlertView *R18Warning=[[UIAlertView alloc] initWithTitle:Title message:@"根据相关法律法规，该词条被屏蔽。" delegate:self cancelButtonTitle:@"是" otherButtonTitles:nil];
            R18Warning.alertViewStyle=UIAlertViewStyleDefault;
            [R18Warning show];
            return @"根据相关法律法规，该词条被屏蔽。";
        }
        
    }
    
    //搜索结果修正
    if ([_SearchBox.text hasPrefix:@"Special:搜索"]) {
        regexstr = @"<form id=\"search\" [\\s\\S]*?</form>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    
    
    [self ProgressGo:0.05];
    //添加定制样式
    regexstr = @"</body>";
    range = [content rangeOfString:regexstr];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        NSString *style= @"<style> body{padding:10px !important;overflow-x:hidden !important;} p{clear:both !important;} #mw-content-text{ max-width: 100%; overflow: hidden;} .wikitable, table.navbox{ display:block; overflow-y:scroll;} .nowraplinks.mw-collapsible{width:300% !important; font-size:10px !important;} .navbox-title span{font-size:10px !important;} .backToTop{display:none !important;} .mw-search-pager-bottom{display:none;} .searchresult{font-size: 10px !important;line-height: 13px;width: 100% !important;} form{display:none;} iframe{width:292px !important; height:auto;} #mw-pages .mw-content-ltr td, #mw-subcategories .mw-content-ltr td{float: left;display: block;clear: both;width: 90% !important;}</style> <script>$(document).ready(function(){$(\".heimu\").click(function(){$(this).css(\"background\",\"#ffffff\")});});</script>";
        content = [NSString stringWithFormat:@"%@%@%@",[content substringWithRange:NSMakeRange(0, range.location)],style,[content substringWithRange:NSMakeRange(range.location, (content.length - range.location))]];
    }
    
    

    return content;
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"检测到摇晃！");
        //if ((arc4random()%10)>8) {//只有20％的概率会刷新概率池
            [self SendRandomRequest];
        //}
        NSString *theTitle = [_RandomPool objectForKey:[NSString stringWithFormat:@"%d",(int)(arc4random()%10)]];
        if (theTitle == nil) {
            [self SendRandomRequest];
            return;
        }
        NSString *Title = [NSString stringWithFormat:@"你摇到了「 %@ 」",theTitle];
        UIAlertView *RanPage=[[UIAlertView alloc] initWithTitle:Title message:nil delegate:self cancelButtonTitle:@"查看" otherButtonTitles:@"取消",nil];
        RanPage.alertViewStyle=UIAlertViewStyleDefault;
        [RanPage show];
        tempTitle = theTitle;
    }
    
}

- (void)PrepareRandomPopout:(NSString *)content{
    NSInteger i;
    NSString * thetext;
    NSRange therange;
    for (i=0; i<10; i++) {
        therange = [content rangeOfString:@"title=\"" options:NSLiteralSearch];
        content = [content substringFromIndex:therange.location+7];
        therange = [content rangeOfString:@"\" />" options:NSLiteralSearch];
        thetext = [content substringToIndex:therange.location];
        content = [content substringFromIndex:therange.location+4];
        [_RandomPool setObject:thetext forKey:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    [defaultdata setObject:[_RandomPool objectForKey:@"0"] forKey:@"ran0"];
    [defaultdata setObject:[_RandomPool objectForKey:@"1"] forKey:@"ran1"];
    [defaultdata setObject:[_RandomPool objectForKey:@"2"] forKey:@"ran2"];
    [defaultdata setObject:[_RandomPool objectForKey:@"3"] forKey:@"ran3"];
    [defaultdata setObject:[_RandomPool objectForKey:@"4"] forKey:@"ran4"];
    [defaultdata setObject:[_RandomPool objectForKey:@"5"] forKey:@"ran5"];
    [defaultdata setObject:[_RandomPool objectForKey:@"6"] forKey:@"ran6"];
    [defaultdata setObject:[_RandomPool objectForKey:@"7"] forKey:@"ran7"];
    [defaultdata setObject:[_RandomPool objectForKey:@"8"] forKey:@"ran8"];
    [defaultdata setObject:[_RandomPool objectForKey:@"9"] forKey:@"ran9"];
    //===================================================================
    [defaultdata setObject:baseID forKey:@"version"];
    NSLog(@"加入版本号");
    //===================================================================
    [defaultdata synchronize];
}

- (void)SendRandomRequest{
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:APIrandom] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:RequestTimeOutSec];
    [TheRequest setHTTPMethod:@"POST"];
    RequestConnectionForRandom = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
}


- (void)PrepareHomepage{
    if (InstanceLock >= 2) {
        NSString * TheStructure = [[NSString alloc] initWithData:_RecievePool encoding:NSUTF8StringEncoding];
        NSString * TheContent = [[NSString alloc] initWithData:_RecievePool3 encoding:NSUTF8StringEncoding];
       
        NSString *regexstr = @"<div id=\"mainpage\">[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
        NSRange range = [TheContent rangeOfString:regexstr options:NSRegularExpressionSearch];
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        if (range.location != NSNotFound) {
            TheContent = [TheContent substringWithRange:range];
            
            //清除图标
            regexstr =@"<div class=\"floatleft\">[\\s\\S]*?</div>";
            range = [TheContent rangeOfString:regexstr options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                TheContent = [TheContent stringByReplacingCharactersInRange:range withString:@""];
            }
            
            //清除最后一个栏目
            
            TheContent = [TheContent stringByReplacingOccurrencesOfString:@"<div class=\"mainpage-title\">萌娘网姊妹项目</div>" withString:@""];
            
            regexstr = @"<div class=\"mainpage-content nomobile\">[\\s\\S]*?</div>";
            range = [TheContent rangeOfString:regexstr options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                TheContent = [TheContent stringByReplacingCharactersInRange:range withString:@""];
            }
            
            //汇报到主页面
            regexstr = @"<!--MainpageContent-->";
            range = [TheStructure rangeOfString:regexstr];
            if (range.location != NSNotFound) {
                NSString* timestamp;
                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                timestamp = [formatter stringFromDate:[NSDate date]];
                TheContent = [TheContent stringByAppendingString:[NSString stringWithFormat:@"<p id='update'>更新时间 %@</p>",timestamp]];
                TheStructure = [TheStructure stringByReplacingCharactersInRange:range withString:TheContent];
                [defaultdata setObject:@"xxoo" forKey:@"retl"];
                r18l = @"xxoo";
            }else{
                [defaultdata setObject:@"off" forKey:@"retl"];
                r18l = @"off";
            }
        }
        
        
        [self SendToInterface:TheStructure];
        
        [defaultdata setObject:TheStructure forKey:@"homepage"];
        [defaultdata synchronize];
    }
}

- (void)CallFromScheme{
    NSLog(@"检查是否由URL Scheme调用");
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    if ([defaultdata objectForKey:@"target"] != nil) {
        NSLog(@"是由URL Scheme调用");
        NSString * TheTarget = [defaultdata objectForKey:@"target"];
        if ([TheTarget hasPrefix:@"moegirl://?w="]) {
            TheTarget = [TheTarget substringFromIndex:13];
            [_SearchBox setText:[TheTarget stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self MainMission];
        }
        [defaultdata removeObjectForKey:@"target"];
        [defaultdata synchronize];
    }
}
@end

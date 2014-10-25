//
//  moegirlWebView.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlWebView.h"

@implementation moegirlWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *)prepareContent:(NSData *)data
{
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    /*处理接受的数据*/
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
    
    NSString * regexstr;
    NSRange range;    
    
        //R18修正
        [self.hook progressAndStatusMakeStep:3 info:nil];
        regexstr = @"<script language=\"javascript\"[\\s\\S]*?<div id=x18[\\s\\S]*?</div>[\\s\\S]*?</script>[\\s\\S]*<span style=\"position:fixed;top: 0px;[\\s\\S]*width=\"227\" height=\"83\" /></a></span>[\\s\\S]*?</p>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@""];
            NSLog(@"此词条为 R18 限制");
        }
        
        //banner修正
        [self.hook progressAndStatusMakeStep:3 info:nil];
        content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:80%;" withString:@"<table class=\"common-box\" style=\""];
        content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:350px;" withString:@"<table class=\"common-box\" style=\""];
        
        //Template:Vocaloid Songbox
        [self.hook progressAndStatusMakeStep:3 info:nil];
        regexstr = @"align=\"center\" width=\"450px\" style=\"border:0px; text-align:center; line-height:1.3em;\" class=\"infotemplate\"";
        range = [content rangeOfString:regexstr];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@"align=\"center\" style=\"border:0px; text-align:center; line-height:1.3em;width:100%;margin-left:-5px;\" class=\"infotemplate\""];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
        
        //flashmp3 插件修正，针对音频
        [self.hook progressAndStatusMakeStep:3 info:nil];
        regexstr = @"<script language=\"JavaScript\" src=\"/extensions/FlashMP3/audio-player\\.js\".*soundFile=";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@"<audio src=\""];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
    
        [self.hook progressAndStatusMakeStep:3 info:nil];
        regexstr = @"\"><param name=\"quality\" value=\"high\"><param name=\"menu\" value=\"false\"><param name=\"wmode\" value=\"transparent\"></object>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@"\" controls=\"controls\"></audio>"];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
    
        //无图模式
        [self.hook progressAndStatusMakeStep:3 info:nil];
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        if ([defaultdata boolForKey:@"NoImage"]) {
            regexstr = @"<img .*?>";
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
            while (range.location != NSNotFound) {
                content = [content stringByReplacingCharactersInRange:range withString:@""];
                range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
            }
        }
    
    
    NSString * header = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"pageheader"] encoding:NSUTF8StringEncoding error:nil];
    header = [NSString stringWithFormat:@"%@<div class=\"mw-body\" role=\"main\"><h1 id=\"firstHeading\" class=\"firstHeading\" lang=\"zh-CN\"><span dir=\"auto\">%@</span></h1><div id=\"bodyContent\"><div id=\"mw-content-text\" lang=\"zh-CN\" dir=\"ltr\" class=\"mw-content-ltr\">",header,_keyword];
    
    
    NSString * footer = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"pagefooter"] encoding:NSUTF8StringEncoding error:nil];
    footer = [NSString stringWithFormat:@"</div></div></div><div style=\"height:50px;\"></div>%@",footer];
    content = [NSString stringWithFormat:@"%@%@%@",header,content,footer];
    /*============*/
    
    [self.hook progressAndStatusSetToValue:90 info:@"等待页面绘制"];
    return content;
}

- (NSString *)prepareContentOld:(NSData *)data
{
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
    
    NSString * oldcss = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"oldcustomize"] encoding:NSUTF8StringEncoding error:nil];
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    NSString *regexstr = @"<div id=\"siteSub\">.*?</div>";
    NSRange range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<div id=\"mw-page-base\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<div id=\"mw-head-base\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<div id=\"jump-to-nav\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<div id=\'mw-data-after-content\'>[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<div id=\"mw-navigation\">[\\s\\S]*?<div style=\"clear:both\"></div>[\\s\\S]*?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @" id=\"content\"";
    range = [content rangeOfString:regexstr];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<div id=\"siteNotice\">[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    //banner修正
    [self.hook progressAndStatusMakeStep:3 info:nil];
    content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:80%;" withString:@"<table class=\"common-box\" style=\""];
    content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:350px;" withString:@"<table class=\"common-box\" style=\""];
    
    //搜索结果修正
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<form id=\"search\" [\\s\\S]*?</form>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
    }
    
    //flashmp3 插件修正，针对音频
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"<script language=\"JavaScript\" src=\"/extensions/FlashMP3/audio-player\\.js\".*soundFile=";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@"<audio src=\""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"\"><param name=\"quality\" value=\"high\"><param name=\"menu\" value=\"false\"><param name=\"wmode\" value=\"transparent\"></object>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@"\" controls=\"controls\"></audio>"];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    //添加定制样式
    [self.hook progressAndStatusMakeStep:3 info:nil];
    regexstr = @"</body>";
    range = [content rangeOfString:regexstr];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:oldcss];
    }
    
    
    //无图模式
    [self.hook progressAndStatusMakeStep:3 info:nil];
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    if ([defaultdata boolForKey:@"NoImage"]) {
        regexstr = @"<img .*?>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@""];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
    }
    
    [self.hook progressAndStatusSetToValue:90 info:@"等待页面绘制"];
    return content;
    
}

#pragma mark Start:Dash!

- (void)loadContentWithEncodedKeyWord:(NSString *)keywordAfterEncode useCache:(BOOL)useCache
{
    [self.hook progressAndStatusShowUp];
    [self.hook progressAndStatusMakeStep:5 info:@"发送请求"];
    _keyword = [keywordAfterEncode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _contentRequest = [mcCachedRequest new];
    [_contentRequest setHook:self];
    if ([_keyword hasPrefix:@"Special:"]||[_keyword hasPrefix:@"File:"]) {
        [_contentRequest launchRequest:[NSString stringWithFormat:@"%@/%@",_targetURL,keywordAfterEncode] ignoreCache:!useCache];
    }else{
        [_contentRequest launchRequest:[NSString stringWithFormat:@"%@/%@?action=render",_targetURL,keywordAfterEncode] ignoreCache:!useCache];
    }
}

-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data
{
    if (cache) {
        [self.hook progressAndStatusSetToValue:50 info:@"发现缓存，正在处理"];
    }else{
        [self.hook progressAndStatusSetToValue:50 info:@"接收完成，正在处理"];
    }
    NSString * baseURL = [NSString stringWithFormat:@"%@/moegirl-app-2.0/%@",_targetURL,[_keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (success) {
        if ([_keyword hasPrefix:@"Special:"]||[_keyword hasPrefix:@"File:"]) {
            [self loadHTMLString:[self prepareContentOld:data]
                         baseURL:[NSURL URLWithString:baseURL]];
        }else{
            [self loadHTMLString:[self prepareContent:data]
                         baseURL:[NSURL URLWithString:baseURL]];
        }
    } else {
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
        
        NSString * defaultPage = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"errordefault"] encoding:NSUTF8StringEncoding error:nil];
        
        [self loadHTMLString:[NSString stringWithFormat:defaultPage,error,error]
                     baseURL:[NSURL URLWithString:baseURL]];
        
        NSLog(@"Error: %@",error);
    }
}

#pragma mark webViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hook progressAndStatusHide];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSString *link = [[request URL] absoluteString];
        NSLog(@"%@",link);
        if ([link hasPrefix:@"moegirl://"]) {
            return YES;//App 内部调用
        }
        NSRange rangeA = [link rangeOfString:@"//zh.moegirl.org/"];
        if (rangeA.location != NSNotFound) {
            link = [link substringFromIndex:rangeA.location + 17];
            if ([link hasPrefix:@"moegirl-app-2.0/"]) {
                link = [link substringFromIndex:16];
            }
            if ([link hasPrefix:[NSString stringWithFormat:@"%@#",[_keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]){
                return  YES;// a href # 页面内部转跳
            }
            NSLog(@"%@",link);
            //开启新词条
            [self.hook newWebViewRequestFormWebView:link];
            return NO;
        }
        if ([link hasPrefix:@"applewebdata://"]) {
            return YES;
        }
        
        if ([link hasPrefix:@"http://static.mengniang.org/"]) {
            _saveImageAlertView = [moegirlSaveImageAlertView alloc];
            [_saveImageAlertView setImageURL:link];
            _saveImageAlertView = [_saveImageAlertView initWithTitle:@"是否保存该图片?"
                                                           message:nil
                                                          delegate:_saveImageAlertView
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"保存", nil];
            [_saveImageAlertView show];
        }
        //站外链接
        return NO;
    }else{
        return YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.hook cancelKeyboard];
}


-(void)mcCachedRequestGotRespond
{
    [self.hook progressAndStatusMakeStep:4 info:@"得到响应"];
}

-(void)mcCachedRequestGotData
{
    [self.hook progressAndStatusMakeStep:1 info:@"正在接收数据"];
}

@end

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
        regexstr = @"<script language=\"javascript\"[\\s\\S]*?<div id=x18[\\s\\S]*?</div>[\\s\\S]*?</script>[\\s\\S]*<span style=\"position:fixed;top: 0px;[\\s\\S]*width=\"227\" height=\"83\" /></a></span>[\\s\\S]*?</p>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@""];
            NSLog(@"此词条为 R18 限制");
        }
        
        //banner修正
        content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:80%;" withString:@"<table class=\"common-box\" style=\""];
        content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:350px;" withString:@"<table class=\"common-box\" style=\""];
        
        //Template:Vocaloid Songbox
        regexstr = @"align=\"center\" width=\"450px\" style=\"border:0px; text-align:center; line-height:1.3em;\" class=\"infotemplate\"";
        range = [content rangeOfString:regexstr];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@"align=\"center\" style=\"border:0px; text-align:center; line-height:1.3em;width:100%;margin-left:-5px;\" class=\"infotemplate\""];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
        
        //flashmp3 插件修正，针对音频
        regexstr = @"<script language=\"JavaScript\" src=\"/extensions/FlashMP3/audio-player\\.js\".*soundFile=";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@"<audio src=\""];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
        regexstr = @"\"><param name=\"quality\" value=\"high\"><param name=\"menu\" value=\"false\"><param name=\"wmode\" value=\"transparent\"></object>";
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        while (range.location != NSNotFound) {
            content = [content stringByReplacingCharactersInRange:range withString:@"\" controls=\"controls\"></audio>"];
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
        }
    
    
    
    NSString * header = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"pageheader"] encoding:NSUTF8StringEncoding error:nil];
    header = [NSString stringWithFormat:@"%@<div class=\"mw-body\" role=\"main\"><h1 id=\"firstHeading\" class=\"firstHeading\" lang=\"zh-CN\"><span dir=\"auto\">%@</span></h1><div id=\"bodyContent\"><div id=\"mw-content-text\" lang=\"zh-CN\" dir=\"ltr\" class=\"mw-content-ltr\">",header,_keyword];
    
    
    NSString * footer = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"pagefooter"] encoding:NSUTF8StringEncoding error:nil];
    footer = [NSString stringWithFormat:@"</div></div></div><div style=\"height:50px;\"></div>%@",footer];
    content = [NSString stringWithFormat:@"%@%@%@",header,content,footer];
    /*============*/
    
    return content;
}

- (NSString *)prepareContentOld:(NSData *)data
{
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
    
    NSString * oldcss = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"oldcustomize"] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *regexstr = @"<div id=\"siteSub\">.*?</div>";
    NSRange range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @"<div id=\"mw-page-base\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @"<div id=\"mw-head-base\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @"<div id=\"jump-to-nav\"[\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @"<div id=\'mw-data-after-content\'>[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @"<div id=\"mw-navigation\">[\\s\\S]*?<div style=\"clear:both\"></div>[\\s\\S]*?</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @" id=\"content\"";
    range = [content rangeOfString:regexstr];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    regexstr = @"<div id=\"siteNotice\">[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    //banner修正
    content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:80%;" withString:@"<table class=\"common-box\" style=\""];
    content = [content stringByReplacingOccurrencesOfString:@"<table class=\"common-box\" style=\"margin: 0px 10%; width:350px;" withString:@"<table class=\"common-box\" style=\""];
    
    //搜索结果修正
    regexstr = @"<form id=\"search\" [\\s\\S]*?</form>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@""];
    }
    
    //flashmp3 插件修正，针对音频
    regexstr = @"<script language=\"JavaScript\" src=\"/extensions/FlashMP3/audio-player\\.js\".*soundFile=";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@"<audio src=\""];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    regexstr = @"\"><param name=\"quality\" value=\"high\"><param name=\"menu\" value=\"false\"><param name=\"wmode\" value=\"transparent\"></object>";
    range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:@"\" controls=\"controls\"></audio>"];
        range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
    }
    
    //添加定制样式
    regexstr = @"</body>";
    range = [content rangeOfString:regexstr];
    if (range.location != NSNotFound) {
        content = [content stringByReplacingCharactersInRange:range withString:oldcss];
    }
    
    
    return content;
}

- (void)loadContentWithEncodedKeyWord:(NSString *)keywordAfterEncode useCache:(BOOL)useCache
{
    _keyword = [keywordAfterEncode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _contentRequest = [mcCachedRequest new];
    [_contentRequest setHook:self];
    [_contentRequest launchRequest:[NSString stringWithFormat:@"%@/%@?action=render",_targetURL,keywordAfterEncode] ignoreCache:!useCache];
}

-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data
{
    if (cache) {
        NSLog(@"load from cache");
    }else{
        NSLog(@"new content");
    }
    NSString * baseURL = [NSString stringWithFormat:@"%@/moegirl-app-2.0/%@",_targetURL,_keyword];
    if (success) {
        if ([_keyword hasPrefix:@"Special:"]) {
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
            //<------------------------
            //在这里添加对图片地址的判断
            
            
            //<------------------------
            //开启新词条
            [self.hook newWebViewRequestFormWebView:link];
        }
        //站外链接
        
        
        
        
        return NO;
    }else{
        return YES;
    }
}

@end

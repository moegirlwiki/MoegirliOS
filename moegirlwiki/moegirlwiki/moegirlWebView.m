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
    /*被屏蔽处理方式*/
    NSString * idString = @"title=\"Special:用户登录\">登录</a>才能查看其它页面。";
    NSRange checkRange;
    
    checkRange = [content rangeOfString:idString];
    if (checkRange.location != NSNotFound) {
        NSLog(@"权限内容");
        
        
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
        
        NSString * defaultPage = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"errordefault"] encoding:NSUTF8StringEncoding error:nil];
        
        return [NSString stringWithFormat:defaultPage,@"需要权限",@"内容比较糟糕，需要权限"];
    }
    
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
            content = [content stringByReplacingCharactersInRange:range withString:@"\" controls=\"controls\"  preload=\"none\"></audio>"];
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
        }else{
            //对图片进行处理
            regexstr = @"<img .*?>";
            range = [content rangeOfString:regexstr options:NSRegularExpressionSearch];
            while (range.location != NSNotFound) {
                bool setH = YES, setMH = YES, setW = YES, setMW = YES;
                NSRange rangeW, rangeH, rangeS;
                NSString *imgStr = [content substringWithRange:range];
                NSString *widthStr, *heightStr, *styleStr, *newStyleStr = @"";
                rangeS = [imgStr rangeOfString:@"style=\".*?\"" options:NSRegularExpressionSearch];
                
                //NSLog(@"%@",imgStr);
                //Style
                if (rangeS.location != NSNotFound) {
                    styleStr = [imgStr substringWithRange:rangeS];
                    if ([styleStr rangeOfString:@"width:"].location != NSNotFound) {
                        setW = NO;
                        //删除图片固有尺寸
                        NSRange tempRange = [styleStr rangeOfString:@"width:.*?;"  options:NSRegularExpressionSearch];
                        if (tempRange.location != NSNotFound) {
                            styleStr = [styleStr stringByReplacingCharactersInRange:NSMakeRange(tempRange.location,0) withString:@"max-"];
                            setMW = NO;
                        }
                    }
                    if ([styleStr rangeOfString:@"max-width:"].location != NSNotFound) {
                        setMW = NO;
                    }
                    if ([styleStr rangeOfString:@"height:"].location != NSNotFound) {
                        setH = NO;
                    }
                    if ([styleStr rangeOfString:@"max-height:"].location != NSNotFound) {
                        setMH = NO;
                    }
                }
                
                if (setH||setMH) {
                    //Height
                    rangeH = [imgStr rangeOfString:@"height=\".*?\"" options:NSRegularExpressionSearch];
                    if (rangeH.location != NSNotFound) {
                        heightStr = [imgStr substringWithRange:NSMakeRange(rangeH.location + 8, rangeH.length - 9)];
                        if ([heightStr hasSuffix:@"%"]) {
                            //移除不处理
                            setH = NO;
                            setMH = NO;
                        }else{
                            //加上px将其设置为max-height
                            if (![heightStr hasSuffix:@"px"]) {
                                heightStr = [heightStr stringByAppendingString:@"px"];
                            }
                            setH = NO;
                        }
                        imgStr = [imgStr stringByReplacingCharactersInRange:rangeH withString:@""];
                    }else{
                        setH = NO;
                        setMH = NO;
                    }
                }
                
                
                if (setW||setMW) {
                    //Width
                    rangeW = [imgStr rangeOfString:@"width=\".*?\"" options:NSRegularExpressionSearch];
                    if (rangeW.location != NSNotFound) {
                        widthStr = [imgStr substringWithRange:NSMakeRange(rangeW.location + 7, rangeW.length - 8)];
                        if ([widthStr hasSuffix:@"%"]) {
                            //移除不处理
                            setW = NO;
                            setMW = NO;
                        }else{
                            //加上px将其设置为max-height
                            if (![widthStr hasSuffix:@"px"]) {
                                widthStr = [widthStr stringByAppendingString:@"px"];
                            }
                        }
                        imgStr = [imgStr stringByReplacingCharactersInRange:rangeW withString:@""];
                    }else{
                        setW = NO;
                        setMW = NO;
                    }
                }
                
                
                if (setMH) {
                    newStyleStr = [newStyleStr stringByAppendingString:[NSString stringWithFormat:@"max-height:%@;",heightStr]];
                }
                
                //if (setW) {
                    newStyleStr = [newStyleStr stringByAppendingString:@"width:100%;"];
                //}
                if (setMH) {
                    newStyleStr = [newStyleStr stringByAppendingString:[NSString stringWithFormat:@"max-width:%@;",widthStr]];
                }
             
                if (![newStyleStr isEqualToString:@""]) {
                    rangeS = [imgStr rangeOfString:@"style=\".*?\"" options:NSRegularExpressionSearch];
                    if (rangeS.location != NSNotFound) {
                        styleStr = [styleStr stringByReplacingCharactersInRange:NSMakeRange(styleStr.length - 1, 0) withString:newStyleStr];
                        imgStr = [imgStr stringByReplacingCharactersInRange:rangeS withString:styleStr];
                    }else{
                        if ([imgStr hasSuffix:@"/>"]) {
                            imgStr = [imgStr stringByReplacingCharactersInRange:NSMakeRange(imgStr.length - 2, 0) withString:[NSString stringWithFormat:@" style=\"%@\"",newStyleStr]];
                        }else{
                            imgStr = [imgStr stringByReplacingCharactersInRange:NSMakeRange(imgStr.length - 1, 0) withString:[NSString stringWithFormat:@" style=\"%@\"",newStyleStr]];
                        }
                    }
                }
                
                //NSLog(@"%@-%@-%@",imgStr,heightStr,widthStr);
                //NSLog(@" ");
                
                content = [content stringByReplacingCharactersInRange:range withString:imgStr];
                range = [content rangeOfString:regexstr options:NSRegularExpressionSearch range:NSMakeRange(range.location + imgStr.length, content.length - range.location - imgStr.length)];
            }
        }
    
    
    NSString * header = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"pageheader"] encoding:NSUTF8StringEncoding error:nil];
    header = [NSString stringWithFormat:@"%@<div class=\"mw-body\" role=\"main\"><h1 id=\"firstHeading\" class=\"firstHeading\" lang=\"zh-CN\"><span dir=\"auto\">%@</span></h1><div id=\"bodyContent\"><div id=\"mw-content-text\" lang=\"zh-CN\" dir=\"ltr\" class=\"mw-content-ltr\">",header,_keyword];
    
    
    NSString * footer = [NSString stringWithContentsOfFile:[htmlDocumentPath stringByAppendingPathComponent:@"pagefooter"] encoding:NSUTF8StringEncoding error:nil];
    footer = [NSString stringWithFormat:@"</div></div></div><div style=\"height:50px;\"></div>%@",footer];
    
    if (!([defaultdata boolForKey:@"PopoutMenu"])) {
        NSRange rangeA, rangeB;
        
        rangeA = [footer rangeOfString:@"<!--popoutB-->"];
        rangeB = [footer rangeOfString:@"<!--popoutE-->"];
        if ((rangeA.location!=NSNotFound)&&(rangeB.location!=NSNotFound)) {
            NSUInteger a = rangeA.location;
            NSUInteger b = rangeB.location;
            if (b>a) {
                footer = [footer stringByReplacingCharactersInRange:NSMakeRange(a, b-a) withString:@""];
            }
        }
    }
    
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
    regexstr = @"class=\"mw-body\"";
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
        content = [content stringByReplacingCharactersInRange:range withString:@"\" controls=\"controls\" preload=\"none\"></audio>"];
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
        [_contentRequest launchCookiedRequest:[NSString stringWithFormat:@"%@/%@",_targetURL,keywordAfterEncode] ignoreCache:!useCache];
    }else{
        [_contentRequest launchCookiedRequest:[NSString stringWithFormat:@"%@/%@?action=render",_targetURL,keywordAfterEncode] ignoreCache:!useCache];
    }
}

-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data
{
    if (cache) {
        [self.hook progressAndStatusSetToValue:50 info:@"发现缓存，正在处理"];
    }else{
        [self.hook progressAndStatusSetToValue:50 info:@"接收完成，正在处理"];
    }
    NSString * baseURL = [NSString stringWithFormat:@"%@/moegirl-app-2.4/%@",_targetURL,[_keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            if ([link hasPrefix:@"moegirl-app-2.4/"]) {
                link = [link substringFromIndex:16];
            }
            if ([link hasPrefix:[NSString stringWithFormat:@"%@#",[_keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]){
                return  YES;// a href # 页面内部转跳
            }
            //如果是转跳到别的页面并且带有位置表示#的情况
            NSRange targetRange = [link rangeOfString:@"#"];
            if (targetRange.location != NSNotFound) {
                link = [link substringToIndex:targetRange.location];
            }
            NSLog(@"%@",link);
            //编辑页面
            if ([link hasPrefix:@"index.php?title="]&&[link hasSuffix:@"&action=edit"]){
                [self.hook ctrlPanelCallEditor];
                return NO;
            }
            if ([link hasPrefix:@"index.php?"]) {
                //程序无法渲染，是否在其它页面中打开？
                [self cannotOpenLink:@"本程序无法渲染该页面，是否在Safari中打开 ？" link:[[request URL] absoluteString]];
                return NO;
            }
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
            return NO;
        }
        //站外链接
        [self cannotOpenLink:@"这是一个外链，您确定要打开这个链接吗？" link:[[request URL] absoluteString]];
        return NO;
    }else{
        return YES;
    }
}

- (void)cannotOpenLink:(NSString *)info link:(NSString *)link
{
    templink = link;
    UIAlertView * confirmAlert = [[UIAlertView alloc] initWithTitle:info
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"打开链接", nil];
    [confirmAlert show];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.hook cancelKeyboard];
    [super scrollViewDidScroll: scrollView];
}


-(void)mcCachedRequestGotRespond
{
    [self.hook progressAndStatusMakeStep:4 info:@"得到响应"];
}

-(void)mcCachedRequestGotData
{
    [self.hook progressAndStatusMakeStep:1 info:@"正在接收数据"];
}

- (void)cancelRequest
{
    [_contentRequest cancelRequest];
    [self setHook:nil];
}

#pragma mark AlertViewAction

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * btnText = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"打开链接"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:templink]];
    }
}

@end

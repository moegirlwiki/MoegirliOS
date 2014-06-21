//
//  mcViewController.m
//  moegirlwiki
//
//  Created by Chen Junlin on 14-6-19.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcViewController.h"

@interface mcViewController ()

@property (strong,nonatomic) NSMutableData *RecievePool1;
@property (strong,nonatomic) NSMutableData *RecievePool2;
@property (strong,nonatomic) NSMutableData *RecievePool3;
@property (strong,nonatomic) NSMutableData *RecievePool4;

@property (strong,nonatomic) NSMutableDictionary *HistoryPool;
@property (strong,nonatomic) NSMutableDictionary *NamePool;

@property (weak, nonatomic) IBOutlet UITextField *SearchInputBox;

- (IBAction)GoBackSwap:(id)sender;
- (IBAction)GoForwardSwap:(id)sender;
- (IBAction)SearchButton:(id)sender;

- (void)MasterLauncher;
- (void)CheckIfExisting;
- (void)SearchLemma;
- (void)SearchImages;
- (void)PreparePresentation1:(NSDictionary *)data;
- (void)PreparePresentation2;
- (void)PrepareImages;
- (void)RequestImage;
- (void)PresentImage;
- (NSRange)ReplaceString1:(NSRange) initRange;
- (NSRange)ReplaceString2:(NSRange) initRange;
- (void)SendToInterface:(NSString *)content;

@end

@implementation mcViewController


NSTimeInterval RequestTimeOutSec = 10;
NSInteger ImageLoopI = 0;
NSInteger InstanceLock = 2;
NSInteger pointer_max = 0;
NSInteger pointer_current =0;

NSArray * TheImageList;

NSString * API1 = @"http://zh.moegirl.org/api.php?format=json&action=query&titles=%@&prop=revisions&rvprop=content";
NSString * API2 = @"http://zh.moegirl.org/api.php?format=json&action=query&list=search&srwhat=text&srsearch=%@";
NSString * API3 = @"http://zh.moegirl.org/api.php?format=json&action=query&titles=%@&prop=images";
NSString * API4 = @"http://zh.moegirl.org/api.php?format=json&action=query&prop=imageinfo&titles=%@&iiprop=url";

NSString * LemmaContent;

NSString * Prefix =@"\
<!DOCTYPE html>\
<html lang=\"zh-CN\">\
<head>\
<meta charset=\"UTF-8\">\
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\
<link rel=\"stylesheet\" type=\"text/css\" href=\"http://192.168.1.15/library/style.css\">\
</head>\
<body>\
<div id=\"content\">\
";

NSString * Postfix =@"\
</div>\
</body>\
</html>\
";

NSString * DefaultPage =@"\
<!DOCTYPE html>\
<html lang=\"zh-CN\">\
<head>\
<meta charset=\"UTF-8\">\
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\
<link rel=\"stylesheet\" type=\"text/css\" href=\"http://192.168.1.15/library/style.css\">\
</head>\
<body>\
<div id=\"content\">\
Default\
</div>\
</body>\
</html>\
";

NSURLConnection * RequestConnection1;//用于查询词条内容
NSURLConnection * RequestConnection2;//用于获取词条列表（搜索用）
NSURLConnection * RequestConnection3;//用于获取图片列表
NSURLConnection * RequestConnection4;//用于获取图片链接

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _NamePool = [[NSMutableDictionary alloc] init];
    _HistoryPool = [[NSMutableDictionary alloc] init];
    [_MasterWebView setDelegate:self];
    [_MasterWebView loadHTMLString:DefaultPage baseURL:[NSURL URLWithString:@"http://localhost/"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_NamePool removeAllObjects];
    [_HistoryPool removeAllObjects];
    pointer_current = 0;
    pointer_max = 0;
}


//得到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (connection==RequestConnection1) {
        _RecievePool1 = [NSMutableData data];
        NSLog(@"请求1 得到服务器的响应");
    }else if (connection==RequestConnection2) {
        _RecievePool2 = [NSMutableData data];
        NSLog(@"请求2 得到服务器的响应");
    }else if (connection==RequestConnection3) {
        _RecievePool3 = [NSMutableData data];
        NSLog(@"请求3 得到服务器的响应");
    }else if (connection==RequestConnection4) {
        _RecievePool4 = [NSMutableData data];
        NSLog(@"请求4 得到服务器的响应");
    }
    
}

//开始接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection==RequestConnection1) {
        [_RecievePool1 appendData:data];
        NSLog(@"请求1 接收到了服务器传回的数据");
    }else if (connection==RequestConnection2) {
        [_RecievePool2 appendData:data];
        NSLog(@"请求2 接收到了服务器传回的数据");
    }else if (connection==RequestConnection3) {
        [_RecievePool3 appendData:data];
        NSLog(@"请求3 接收到了服务器传回的数据");
    }else if (connection==RequestConnection4) {
        [_RecievePool4 appendData:data];
        NSLog(@"请求4 接收到了服务器传回的数据");
    }
    
}

//错误处理
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection==RequestConnection1) {
        NSLog(@"请求1 发生错误！");
    }else if (connection==RequestConnection2) {
        NSLog(@"请求2 发生错误！");
    }else if (connection==RequestConnection3) {
        NSLog(@"请求3 发生错误！");
    }else if (connection==RequestConnection4) {
        NSLog(@"请求4 发生错误！");
    }
    NSLog(@"%@",error);
}

//结束接收数据
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection==RequestConnection1) {
        NSLog(@"请求1 数据接收完成！");
        [self CheckIfExisting];
    }else if (connection==RequestConnection2) {
        NSLog(@"请求2 数据接收完成！");
        [self PreparePresentation2];
    }else if (connection==RequestConnection3) {
        NSLog(@"请求3 数据接收完成！");
        [self PrepareImages];
    }else if (connection==RequestConnection4) {
        NSLog(@"请求4 数据接收完成！");
        [self PresentImage];
    }
}



- (IBAction)GoBackSwap:(id)sender {
    NSLog(@"往后");
    if (pointer_current > 1) {
        pointer_current --;
        [_MasterWebView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",Prefix,[_HistoryPool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]],Postfix] baseURL:[NSURL URLWithString:@"http://localhost/"]];
        [_SearchInputBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]]];
    }
}

- (IBAction)GoForwardSwap:(id)sender {
    NSLog(@"往前");
    if (pointer_current < pointer_max) {
        pointer_current ++;
        [_MasterWebView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",Prefix,[_HistoryPool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]],Postfix] baseURL:[NSURL URLWithString:@"http://localhost/"]];
        [_SearchInputBox setText:[_NamePool objectForKey:[NSString stringWithFormat:@"%d",pointer_current]]];
    }
}

- (IBAction)SearchButton:(id)sender {
    [self MasterLauncher];
    [_SearchInputBox resignFirstResponder];
}

//首先触发的事件，用于查询词条是否存在，如果存在就直接得到了词条的内容，可以直接进行页面绘制
- (void)MasterLauncher{
    InstanceLock = 0;
    
    NSString *ItemName = [_SearchInputBox text];
    NSLog(@"[API 1]开始进行查询工作，项目名称 %@",ItemName);
    
    NSString *RequestURL = [NSString stringWithFormat:API1,[ItemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"请求链接： %@",RequestURL);
    
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
    [TheRequest setHTTPMethod:@"GET"];
    RequestConnection1 = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
    NSLog(@"程序已经发送请求1，等待响应中");
}


//检查该 词条 是否存在，如果存在则绘制，如果不存在就进行搜索查询
- (void)CheckIfExisting{
    
    NSLog(@"请求1 开始解析数据，判断该条目是否存在。");
    NSDictionary *TheData = [[[NSJSONSerialization JSONObjectWithData:_RecievePool1 options:NSJSONReadingMutableLeaves error:nil]objectForKey:@"query"] objectForKey:@"pages"];
    NSEnumerator *TheEnumerator = [TheData keyEnumerator];
    id TheKey = [TheEnumerator nextObject];
    
    NSInteger returnvalue = [[NSString stringWithFormat:@"%@",TheKey]intValue];
    NSLog(@"请求1 返回页面ID为：%d",returnvalue);
    
    if (returnvalue>0) {
        NSLog(@"判定  存在该条目");
        [self PreparePresentation1:[TheData objectForKey:TheKey]];
    } else {
        NSLog(@"判定  不存在该条目");
        [self SearchLemma];
    }
}


//搜索词条
- (void)SearchLemma{
    NSString *ItemName = [_SearchInputBox text];
    NSLog(@"[API 2]开始进行查询工作，项目名称 %@",ItemName);
    
    NSString *RequestURL = [NSString stringWithFormat:API2,[ItemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"请求链接： %@",RequestURL);
    
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
    [TheRequest setHTTPMethod:@"GET"];
    RequestConnection2 = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
    NSLog(@"程序已经发送请求2，等待响应中");
    
}


//搜索图片
- (void)SearchImages{
    NSString *ItemName = [_SearchInputBox text];
    NSLog(@"[API 3]开始进行查询工作，项目名称 %@",ItemName);
    
    NSString *RequestURL = [NSString stringWithFormat:API3,[ItemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"请求链接： %@",RequestURL);
    
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
    [TheRequest setHTTPMethod:@"GET"];
    RequestConnection3 = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
    NSLog(@"程序已经发送请求3，等待响应中");
    
}

//完成绘制标识事件
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"页面完成绘制！");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"test");
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSString *link = [[request URL] absoluteString];
        link = [link substringFromIndex:17];
        NSLog(@"链接目标 %@",link);
        [_SearchInputBox setText:[link stringByRemovingPercentEncoding]];
        [self MasterLauncher];
        return NO;
    }
    return YES;
}


- (NSRange)ReplaceString1:(NSRange) initRange{
    NSRange range,rangeL,rangeR,rangeA,rangeB,rangeC,t;
    NSString *target, *flag;
    NSLog(@"--->>>递归进入");
    while ((range = [LemmaContent rangeOfString:@"[[" options:NSLiteralSearch range:initRange]).location != NSNotFound) {
        rangeA.length = LemmaContent.length - range.location -2;
        rangeA.location = range.location + 2;

        rangeL = [LemmaContent rangeOfString:@"[[" options:NSLiteralSearch range:rangeA];
        rangeR = [LemmaContent rangeOfString:@"]]" options:NSLiteralSearch range:rangeA];
        if (rangeL.location < rangeR.location) {
            //证明非闭合
            [self ReplaceString1:rangeA];
            initRange.length = LemmaContent.length - initRange.location;
        }
        rangeR = [LemmaContent rangeOfString:@"]]" options:NSLiteralSearch range:rangeA];
        rangeA.length = rangeR.location - rangeA.location;
        if ((rangeB = [LemmaContent rangeOfString:@"|" options:NSLiteralSearch range:rangeA]).location != NSNotFound) {
            rangeB.length = rangeB.location - rangeA.location;
            rangeB.location = rangeA.location;
            target = [LemmaContent substringWithRange:rangeB];
            rangeB.length ++;
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:rangeB withString:@""];
            rangeR.location += 8;
        }else{
            rangeB = rangeA;
            target = [LemmaContent substringWithRange:rangeB];
            rangeR.location += 9 + rangeB.length;
        }
        rangeC = [target rangeOfString:@":"];
        if (rangeC.location != NSNotFound) {
            flag = [target substringToIndex:rangeC.location];
        }else{
            flag = @"";
        }
        if (([flag isEqualToString:@"File"])||([flag isEqualToString:@"Image"])) {
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"<div>    %@  ",target]];
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:rangeR withString:@"</div>"];
        }else if ([flag isEqualToString:@"分类"]){
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"<p><!-- %@-->",target]];
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:rangeR withString:@"</p>"];
        }else {
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"<a href=\"%@\">",target]];
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:rangeR withString:@"</a>"];
        }
        NSLog(@"%@",target);
        initRange.length = LemmaContent.length - initRange.location;
        rangeL = [LemmaContent rangeOfString:@"[[" options:NSLiteralSearch range:initRange];
        rangeR = [LemmaContent rangeOfString:@"]]" options:NSLiteralSearch range:initRange];
        if (rangeL.location > rangeR.location) {
            //证明非闭合
            break;
        }
        initRange.length = LemmaContent.length - initRange.location;
    }
    NSLog(@"<<<---递归跳出");
    return t;
}


- (NSRange)ReplaceString2:(NSRange) initRange{
    NSRange range,rangeL,rangeR,rangeA,rangeB,t;
    NSString *target;
    NSLog(@"--->>>递归进入");
    while ((range = [LemmaContent rangeOfString:@"{{" options:NSLiteralSearch range:initRange]).location != NSNotFound) {
        rangeA.length = LemmaContent.length - range.location -2;
        rangeA.location = range.location + 2;
        
        rangeL = [LemmaContent rangeOfString:@"{{" options:NSLiteralSearch range:rangeA];
        rangeR = [LemmaContent rangeOfString:@"}}" options:NSLiteralSearch range:rangeA];
        if (rangeL.location < rangeR.location) {
            //证明非闭合
            [self ReplaceString1:rangeA];
            initRange.length = LemmaContent.length - initRange.location;
        }
        rangeR = [LemmaContent rangeOfString:@"}}" options:NSLiteralSearch range:rangeA];
        rangeA.length = rangeR.location - rangeA.location;
        if ((rangeB = [LemmaContent rangeOfString:@"|" options:NSLiteralSearch range:rangeA]).location != NSNotFound) {
            rangeB.length = rangeB.location - rangeA.location;
            rangeB.location = rangeA.location;
            target = [LemmaContent substringWithRange:rangeB];
            if ([target isEqualToString:@"萌属性信息\n"]) {
                target = @"info  ";
            } else if ([target isEqualToString:@"黑幕"]) {
                target = @"bl";
            } else if ([target isEqualToString:@"人物信息\n"]) {
                target = @"info ";
            }
            rangeB.length ++;
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:rangeB withString:@""];
            rangeR.location += 11;
        }else{
            rangeB = rangeA;
            target = [LemmaContent substringWithRange:rangeB];
            rangeR.location += 12 + rangeB.length;
        }

            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"<div class=\"%@\">",target]];
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:rangeR withString:@"</div>"];

        NSLog(@"%@",target);
        initRange.length = LemmaContent.length - initRange.location;
        rangeL = [LemmaContent rangeOfString:@"{{" options:NSLiteralSearch range:initRange];
        rangeR = [LemmaContent rangeOfString:@"}}" options:NSLiteralSearch range:initRange];
        
        if (rangeL.location > rangeR.location) {
            //证明非闭合
            break;
        }
        initRange.length = LemmaContent.length - initRange.location;
    }
    NSLog(@"<<<---递归跳出");
    return t;
}

//!!!!!!!!!!!!!!!!!!!
//样式需要对此部分进行改写
//!!!!!!!!!!!!!!!!!!!
- (void)PreparePresentation1:(NSDictionary *)data{
    NSLog(@"请求1 开始解析数据，准备展示。");
    
    NSString *LemmaTitle = [data objectForKey:@"title"];
    LemmaContent = [[[data objectForKey:@"revisions"]objectAtIndex:0]objectForKey:@"*"];
    
    NSRange range;
    
    //加粗字体
    NSInteger count = 1;
    while ((range = [LemmaContent rangeOfString:@"'''"]).location != NSNotFound) {
        if (count==1) {
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:range withString:@"<strong>"];
            count = 0;
        } else {
            LemmaContent = [LemmaContent stringByReplacingCharactersInRange:range withString:@"</strong>"];
            count = 1;
        }
    }
    
    //设置链接
    range.location = 0;
    range.length = LemmaContent.length -1;
    NSLog(@"交给了递归");
    [self ReplaceString1:range];
    NSLog(@"递归结束了");


    
    
    //设置{{xxxx|aaaaaa|bbbbbb}}
    range.location = 0;
    range.length = LemmaContent.length -1;
    NSLog(@"交给了递归");
    [self ReplaceString2:range];
    NSLog(@"递归结束了");
    
    
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"=====\n" withString:@"</h5>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"====\n" withString:@"</h4>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"===\n" withString:@"</h3>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"==\n" withString:@"</h2>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"=====" withString:@"<h5>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"====" withString:@"<h4>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"===" withString:@"<h3>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"==" withString:@"<h2>"];
    LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
    
    
    
    [self SearchImages];
    
    LemmaContent = [NSString stringWithFormat:@"<h1>%@</h1>%@",LemmaTitle,LemmaContent];
    NSLog(@"请求1 开始发送到界面");
    InstanceLock ++;
    [self SendToInterface:LemmaContent];
}



//!!!!!!!!!!!!!!!!!!!
//样式需要对此部分进行改写
//!!!!!!!!!!!!!!!!!!!
- (void)PreparePresentation2{
    NSLog(@"请求2 开始解析数据，准备展示。");
    
    NSArray *TheList = [[[NSJSONSerialization JSONObjectWithData:_RecievePool2 options:NSJSONReadingMutableLeaves error:nil]objectForKey:@"query"]objectForKey:@"search"];
    NSInteger ListCount = [TheList count];
    NSLog(@"请求2 得到条目 %i条",ListCount);
    
    
    NSDictionary *Item;
    
    NSString *ItemTitle;
    NSString *ItemTimeStamp;
    NSString *ItemWordCount;
    NSString *ItemSnippet;
    LemmaContent = @"";
    
    for (int i = 0; i < ListCount; i++) {
        
        Item = [TheList objectAtIndex:i];
        
        ItemTitle = [NSString stringWithFormat:@"<a href=\"%@\"><h3>%@</h3></a>",[Item objectForKey:@"title"],[Item objectForKey:@"title"]];
        ItemTimeStamp = [NSString stringWithFormat:@"<span>%@</span> ",[Item objectForKey:@"timestamp"]];
        ItemWordCount = [NSString stringWithFormat:@"<span>%@</span><br />",[Item objectForKey:@"wordcount"]];
        ItemSnippet = [NSString stringWithFormat:@"<p>%@</p><hr />",[Item objectForKey:@"snippet"]];
        
        LemmaContent = [NSString stringWithFormat:@"%@%@%@%@%@",LemmaContent,ItemTitle,ItemTimeStamp,ItemWordCount,ItemSnippet];
    }
    
    NSLog(@"请求2 开始发送到界面");
    InstanceLock ++;
    InstanceLock ++;
    [self SendToInterface:LemmaContent];
    
}

- (void)PrepareImages{
    NSLog(@"请求3 开始解析数据，判断该条目是否存在。");
    NSDictionary *TheData = [[[NSJSONSerialization JSONObjectWithData:_RecievePool3 options:NSJSONReadingMutableLeaves error:nil]objectForKey:@"query"] objectForKey:@"pages"];
    NSEnumerator *TheEnumerator = [TheData keyEnumerator];
    id TheKey = [TheEnumerator nextObject];

    TheImageList = [[TheData objectForKey:TheKey]objectForKey:@"images"];
    ImageLoopI = 0;
    [self RequestImage];
}


- (void)RequestImage{
    if (ImageLoopI < [TheImageList count]) {
        NSString *ImageName = [[TheImageList objectAtIndex:ImageLoopI]objectForKey:@"title"];
        NSLog(@"[API 4]开始进行查询工作，项目名称 %@",ImageName);
        
        NSString *RequestURL = [NSString stringWithFormat:API4,[ImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"请求链接： %@",RequestURL);
        
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:RequestTimeOutSec];
        [TheRequest setHTTPMethod:@"GET"];
        RequestConnection4 = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
        NSLog(@"程序已经发送请求4，等待响应中");
        
        ImageLoopI ++;
    } else {
        ImageLoopI = 0;
        NSLog(@"请求4 开始发送到界面");
        InstanceLock ++;
        [self SendToInterface:LemmaContent];
    }
}


- (void)PresentImage{
    
    NSLog(@"请求4 开始解析数据，判断该条目是否存在。");
    NSDictionary *TheData = [[[NSJSONSerialization JSONObjectWithData:_RecievePool4 options:NSJSONReadingMutableLeaves error:nil]objectForKey:@"query"] objectForKey:@"pages"];
    NSEnumerator *TheEnumerator = [TheData keyEnumerator];
    id TheKey = [TheEnumerator nextObject];
    
    NSInteger returnvalue = [[NSString stringWithFormat:@"%@",TheKey]intValue];
    NSLog(@"请求4 返回页面ID为：%d",returnvalue);
    
    if (returnvalue>0) {
        NSLog(@"判定  存在该条目");
        
        NSString *target = [[[TheData objectForKey:TheKey]objectForKey:@"title"] substringFromIndex:5];
        NSLog(@"%@",target);
        
        NSString *link = [[[[TheData objectForKey:TheKey]objectForKey:@"imageinfo"]objectAtIndex:0]objectForKey:@"url"];
        NSLog(@"%@",link);
        
        LemmaContent = [LemmaContent stringByReplacingOccurrencesOfString:target withString:[NSString stringWithFormat:@"<img src=\"%@\">",link]];
    } else {
        NSLog(@"判定  不存在该条目");
    }
    
    [self RequestImage];
    
}

- (void)SendToInterface:(NSString *)content{
    //NSLog(@"%@",content);
    if (InstanceLock >= 2) {
        if (pointer_current< 10) {
            pointer_current ++;
            [_HistoryPool setObject:content forKey:[NSString stringWithFormat:@"%d",pointer_current]];
            [_NamePool setObject:_SearchInputBox.text forKey:[NSString stringWithFormat:@"%d",pointer_current]];
        }else{
            NSInteger i;
            for (i=2; i<=10; i++) {
                [_HistoryPool setObject:[_HistoryPool objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",(i-1)]];
                [_NamePool setObject:[_NamePool objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",(i-1)]];
            }
            [_HistoryPool setObject:content forKey:[NSString stringWithFormat:@"%d",10]];
            [_NamePool setObject:_SearchInputBox.text forKey:[NSString stringWithFormat:@"%d",10]];
        }
        pointer_max = pointer_current;
        [_MasterWebView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",Prefix,content,Postfix] baseURL:[NSURL URLWithString:@"http://localhost/"]];
        InstanceLock = 0;
    }
}



@end

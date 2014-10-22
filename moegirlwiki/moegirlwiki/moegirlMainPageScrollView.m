//
//  moegirlMainPageScrollView.m
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlMainPageScrollView.h"

@implementation moegirlMainPageScrollView

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


- (void)refreshScrollView
{
    float initWidth = self.bounds.size.width;
    float YPoint = 20;
    
    [self setContentSize:CGSizeMake(initWidth, 0)];
    
    for (int i = 0; i< _mainPageTitle.count; i++) {
        UIView *itemView = [_scrollItemsPanel objectAtIndex:i];
        [itemView setFrame:CGRectMake(0, YPoint,initWidth, 600)];
        
        UILabel *itemTitle = [_scrollItemsTitle objectAtIndex:i];
        [itemTitle setFrame:CGRectMake(20, 0, initWidth - 40, 30)];
        
        UITextView *itemContent = [_scrollItemsContent objectAtIndex:i];
        CGSize size = [itemContent sizeThatFits:CGSizeMake(initWidth - 10, FLT_MAX)];
        [itemContent setFrame:CGRectMake(5, 30, initWidth - 10, size.height)];
        
        
        [itemView setFrame:CGRectMake(itemView.frame.origin.x, itemView.frame.origin.y, itemView.frame.size.width, itemContent.frame.origin.y + itemContent.frame.size.height)];
        
        YPoint += itemView.frame.size.height + 10;
    }
    
    if (YPoint<self.bounds.size.height) {
        YPoint = self.bounds.size.height + 1;
    }
    [self setContentSize:CGSizeMake(self.bounds.size.width, YPoint)];
    
    float XPoint = (self.bounds.size.width - 180)/2;
    [_scrollHeadBanner setFrame:CGRectMake(XPoint,  -55, 180, 40)];
    [_scrollHeadHint1 setFrame:CGRectMake(0, 0, 180, 20)];
    [_scrollHeadHint2 setFrame:CGRectMake(0, 20, 180, 20)];
}

- (void)setupScrollView
{
    float initWidth = self.bounds.size.width;
    float YPoint = 20;
    
    _scrollItemsPanel = [NSMutableArray new];
    _scrollItemsTitle = [NSMutableArray new];
    _scrollItemsContent = [NSMutableArray new];
    
    [self setBackgroundColor:[UIColor colorWithRed:0.973 green:0.988 blue:1 alpha:1]];
    
    [self setContentSize:CGSizeMake(initWidth, 0)];
    
    for (int i = 0; i< _mainPageTitle.count; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, YPoint,initWidth, 600)];
        [itemView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:itemView];
        
        UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, initWidth - 40, 30)];
        [itemTitle setText:[_mainPageTitle objectAtIndex:i]];
        [itemTitle setNumberOfLines:0];
        [itemTitle setBackgroundColor:[UIColor clearColor]];
        [itemTitle setTextColor:[UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1]];
        [itemTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [itemView addSubview:itemTitle];
        
        UITextView *itemContent = [[UITextView alloc] init];
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
            [itemContent setSelectable:YES];
            [itemContent setLinkTextAttributes:@{
                                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.024 green:0.271 blue:0.678 alpha:1]
                                                 }];
        }else{
            [itemContent setUserInteractionEnabled:YES];
        }
        [itemContent setEditable:NO];
        [itemContent setScrollEnabled:NO];
        [itemContent setDelegate:self];
        [itemContent setAttributedText:[_mainPageContent objectAtIndex:i]];
        [itemContent setBackgroundColor:[UIColor whiteColor]];
        CGSize size = [itemContent sizeThatFits:CGSizeMake(initWidth - 10, FLT_MAX)];
        [itemContent setFrame:CGRectMake(5, 30, initWidth - 10, size.height)];
        [itemView addSubview:itemContent];
        
        
        [itemView setFrame:CGRectMake(itemView.frame.origin.x, itemView.frame.origin.y, itemView.frame.size.width, itemContent.frame.origin.y + itemContent.frame.size.height)];
        
        YPoint += itemView.frame.size.height + 15;
        
        [_scrollItemsContent addObject:itemContent];
        [_scrollItemsTitle addObject:itemTitle];
        [_scrollItemsPanel addObject:itemView];
        
    }
    
    if (YPoint<self.bounds.size.height) {
        YPoint = self.bounds.size.height + 1;
    }
    [self setContentSize:CGSizeMake(self.bounds.size.width, YPoint)];
}

- (void)setupHeadBanner
{
    float XPoint = (self.bounds.size.width - 180)/2;
    _scrollHeadBanner = [[UIView alloc] initWithFrame:CGRectMake(XPoint, -55, 180, 40)];
    [_scrollHeadBanner setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_scrollHeadBanner];
    
    _scrollHeadHint1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
    [_scrollHeadHint1 setText:@"下拉刷新 (´･_･`)"];
    [_scrollHeadHint1 setBackgroundColor:[UIColor clearColor]];
    [_scrollHeadHint1 setTextColor:[UIColor darkGrayColor]];
    [_scrollHeadHint1 setFont:[UIFont boldSystemFontOfSize:11]];
    
    _scrollHeadHint2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 180, 20)];
    [_scrollHeadHint2 setText:[[NSString alloc] initWithFormat:@"最后更新：%@",_lastRefreshDateTime]];
    [_scrollHeadHint2 setBackgroundColor:[UIColor clearColor]];
    [_scrollHeadHint2 setTextColor:[UIColor darkGrayColor]];
    [_scrollHeadHint2 setFont:[UIFont systemFontOfSize:10]];
    
    [_scrollHeadBanner addSubview:_scrollHeadHint1];
    [_scrollHeadBanner addSubview:_scrollHeadHint2];
    
}

- (void)presentError:(NSString *)info
{
    NSLog(@"错误信息:%@",info);
}

-(NSAttributedString *)transFormat:(NSString *)initString
{
    initString = [initString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    initString = [initString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    initString = [initString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    initString = [initString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    initString = [initString stringByReplacingOccurrencesOfString:@"<center>" withString:@""];
    initString = [initString stringByReplacingOccurrencesOfString:@"</center>" withString:@""];
    initString = [initString stringByReplacingOccurrencesOfString:@"<ul>" withString:@""];
    initString = [initString stringByReplacingOccurrencesOfString:@"</ul>" withString:@""];
    initString = [initString stringByReplacingOccurrencesOfString:@"<li>" withString:@""];
    initString = [initString stringByReplacingOccurrencesOfString:@"</li>" withString:@"\n"];
    initString = [initString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    initString = [initString stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
    initString = [initString stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    
    //标记现有标签
    NSString *regex = @"<[\\s\\S]*?>";
    NSRange range = [initString rangeOfString:regex options:NSRegularExpressionSearch];
    NSMutableArray *arrayOfTags = [NSMutableArray new];
    while (range.location != NSNotFound) {
        mcListOfTags * temptag = [mcListOfTags new];
        [temptag setPosition:range.location];
        [temptag setTag:[initString substringWithRange:range]];
        [arrayOfTags addObject:temptag];
        initString = [initString stringByReplacingCharactersInRange:range withString:@""];
        range = [initString rangeOfString:regex options:NSRegularExpressionSearch];
    }
    
    //确定默认样式
    NSDictionary * initFontAttr = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:12],
                                    NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                    };
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:initString attributes:initFontAttr];
    
    //对<b></b>标签进行处理
    NSDictionary * boldFontAttr = @{
                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:12.5],
                                    NSForegroundColorAttributeName : [UIColor blackColor]
                                    };
    int i = 0;
    while (i < arrayOfTags.count) {
        mcListOfTags * temp = [arrayOfTags objectAtIndex:i];
        if ([temp.tag isEqualToString:@"<b>"]) {
            for (int j = i + 1; j < arrayOfTags.count; j++) {
                mcListOfTags * temp2 = [arrayOfTags objectAtIndex:j];
                if ([temp2.tag isEqualToString:@"</b>"]) {
                    [attrString setAttributes:boldFontAttr range:NSMakeRange(temp.position, temp2.position - temp.position)];
                    [arrayOfTags removeObjectAtIndex:j];
                    break;
                }
            }
            [arrayOfTags removeObjectAtIndex:i];
        }else{
            i++;
        }
    }
    
    //对<a href=""></a>进行处理
    i = 0;
    regex = @"href=\"[\\s\\S]*?\"";
    
    NSString * link;
    while (i < arrayOfTags.count) {
        mcListOfTags * temp = [arrayOfTags objectAtIndex:i];
        if ([temp.tag hasPrefix:@"<a "]) {
            range = [temp.tag rangeOfString:regex options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                link = [temp.tag substringWithRange:NSMakeRange(range.location + 6, range.length - 7)];
            }else{
                link = @"";
            }
            for (int j = i + 1; j < arrayOfTags.count; j++) {
                mcListOfTags * temp2 = [arrayOfTags objectAtIndex:j];
                if ([temp2.tag isEqualToString:@"</a>"]) {
                    link = [link stringByReplacingOccurrencesOfString:@"//zh.moegirl.org/" withString:@"moegirl://?w="];
                    [attrString addAttribute:NSLinkAttributeName value:link range:NSMakeRange(temp.position, temp2.position - temp.position)];
                    [arrayOfTags removeObjectAtIndex:j];
                    break;
                }
            }
            [arrayOfTags removeObjectAtIndex:i];
        }else{
            i++;
        }
    }
    return attrString;
}

- (void)processRawData:(NSString *)data
{
    //处理首页数据
    
    //挖出首页
    NSString *regex = @"<div id=\"mainpage\">[\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?(<div [\\s\\S]*?</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>[\\s\\S]*?)*</div>";
    NSRange range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        data = [data substringWithRange:range];
    }else{
        [self presentError:@"无法解析数据"];
        return;
    }
    
    //清除不必要元素
    //底部的友情链接
    data = [data stringByReplacingOccurrencesOfString:@"<div class=\"mainpage-title\">萌娘网姊妹项目</div>" withString:@""];
    regex = @"<div class=\"mainpage-content nomobile\">[\\s\\S]*?</div>";
    range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        data = [data stringByReplacingCharactersInRange:range withString:@""];
    }
    
    //首栏图片
    regex =@"<div class=\"floatleft\">[\\s\\S]*?</div>";
    range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        data = [data stringByReplacingCharactersInRange:range withString:@""];
    }
    
    //图片内容
    regex = @"<img .*?>";
    range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        data = [data stringByReplacingCharactersInRange:range withString:@""];
        range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    }
    
    
    //分组内容
    _mainPageContent = [NSMutableArray new];
    _mainPageTitle = [NSMutableArray new];
    
    //标题
    regex = @"<div class=\"mainpage-title\">[\\s\\S]*?</div>";
    range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        [_mainPageTitle addObject:[data substringWithRange:NSMakeRange(range.location + 28, range.length - 34)]];
        data = [data stringByReplacingCharactersInRange:range withString:@""];
        range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    }
    
    //内容
    regex = @"<div class=\"mainpage-1stcontent\">[\\s\\S]*?</div>";
    range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        [_mainPageContent addObject:[self transFormat:[data substringWithRange:NSMakeRange(range.location + 33, range.length - 39)]]];
        data = [data stringByReplacingCharactersInRange:range withString:@""];
        range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    }
    
    regex = @"<div class=\"mainpage-content\">[\\s\\S]*?</div>";
    range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    while (range.location != NSNotFound) {
        [_mainPageContent addObject:[self transFormat:[data substringWithRange:NSMakeRange(range.location + 30, range.length - 36)]]];
        data = [data stringByReplacingCharactersInRange:range withString:@""];
        range = [data rangeOfString:regex options:NSRegularExpressionSearch];
    }
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self setupScrollView];
    [self setupHeadBanner];
    
    
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * mainpageDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"]stringByAppendingPathComponent:@"mainpage"];
    NSString * TempFile = [[NSString alloc] initWithData:_recievePool encoding:NSUTF8StringEncoding];
    [TempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageCache"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    _lastRefreshDateTime = [formatter stringFromDate:[NSDate date]];
    [_lastRefreshDateTime writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageDate"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)loadMainPage:(BOOL)useCache
{
    if (_lastRefreshDateTime == nil) {
        _lastRefreshDateTime = [NSString new];
    }
    if (requestConnection != nil) {
        [requestConnection cancel];
        requestConnection = nil;
    }
    _recievePool = nil;
    
    if (useCache) {
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * mainpageDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"]stringByAppendingPathComponent:@"mainpage"];
        
        NSString * data = [[NSString alloc] initWithContentsOfFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageCache"] encoding:NSUTF8StringEncoding error:nil];
        _lastRefreshDateTime = [[NSString alloc] initWithContentsOfFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageDate"] encoding:NSUTF8StringEncoding error:nil];
        
        [self processRawData:data];
    }else{
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_targetURL]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:20];
        requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                           delegate:self
                                                   startImmediately:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recievePool = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recievePool appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self presentError:error.localizedFailureReason];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self processRawData:[[NSString alloc] initWithData:_recievePool encoding:NSUTF8StringEncoding]];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -70) {
        [self loadMainPage:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -70) {
        [_scrollHeadHint1 setText:@"释放更新 (((o(*ﾟ▽ﾟ*)o)))"];
    }else{
        [_scrollHeadHint1 setText:@"下拉刷新 (´･_･`)"];
    }
}

@end


@implementation mcListOfTags

@end
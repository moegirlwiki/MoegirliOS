//
//  mcAnalytics.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/25.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcAnalytics.h"

@implementation mcAnalytics

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)startRequest
{
    AnalyticURL = [NSURL URLWithString:@"https://masterchan.me:1024/v21/"];
    
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc] initWithURL:AnalyticURL
                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                timeoutInterval:20];
    requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                       delegate:self
                                               startImmediately:YES];
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
    NSLog(@"Analytic Error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * content = [[NSString alloc]initWithData:_recievePool encoding:NSUTF8StringEncoding];
    NSRange rangeA, rangeB;
    rangeA = [content rangeOfString:@"<!--engine[["];
    rangeB = [content rangeOfString:@"]]engine-->"];
    if ((rangeA.location!=NSNotFound)&&(rangeB.location!=NSNotFound)) {
        NSUInteger a = rangeA.location + 12;
        NSUInteger b = rangeB.location;
        if (b>a) {
            NSString * latestEngine = [content substringWithRange:NSMakeRange(a, b-a)];
            NSLog(@"%@",latestEngine);
            NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
            [defaultdata setObject:latestEngine forKey:@"engine_latest"];
            [defaultdata synchronize];
        }
    }
    
    [self loadHTMLString:content baseURL:AnalyticURL];
}

@end

//
//  moegirlEditorInit.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlEditorInit.h"

@implementation moegirlEditorInit

- (NSString *)urlEncode:(NSString *)unencodedStr
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)unencodedStr,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8 ));
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recievePool = [NSMutableData new];
    _responsePool = [NSURLResponse new];
    _responsePool = response;
    
    [self.hook addStatus:@"正在接收数据"];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recievePool appendData:data];
    [self.hook addStatus:@"."];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.hook addStatus:@"\n数据接收完毕！\n"];
    [self prepareContent];
}

-(void)cancelRequest
{
    [requestConnection cancel];
    [self setHook:nil];
}

-(void)fetchToken
{
    [self.hook addStatus:[NSString stringWithFormat:@"正在连接萌娘百科服务器......\n编辑目标:%@\n",_targetTitle]];
    NSString *RequestURL = @"http://zh.moegirl.org/api.php";
    //POST的内容
    NSString *RequestContent = [NSString stringWithFormat:@"action=query&prop=info|revisions&rvprop=content&intoken=edit&titles=%@&format=json",
                                [self urlEncode:_targetTitle]
                                ];
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:20];
    [TheRequest setHTTPMethod:@"POST"];
    [TheRequest setHTTPShouldHandleCookies:YES];
    [TheRequest setHTTPBody:[RequestContent dataUsingEncoding:NSUTF8StringEncoding]];
    requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                       delegate:self];
}

-(void)prepareContent
{
    
    //处理编辑令牌
    //NSLog(@"%@",_responsePool);
    //NSLog(@"%@",[[NSString alloc]initWithData:_recievePool encoding:NSUTF8StringEncoding]);
    
    NSDictionary *warningData = [[[NSJSONSerialization JSONObjectWithData:_recievePool
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil]
                                 objectForKey:@"warnings"]
                                objectForKey:@"info"];
    
    NSString *warningInfo =[warningData objectForKey:@"*"];
    
    if (warningInfo != nil) {
        [self.hook addStatus:[NSString stringWithFormat:@"哎呀呀，出错了! %@",warningInfo]];
    }else{
        NSDictionary *unwarpData = [[[NSJSONSerialization JSONObjectWithData:_recievePool
                                                                  options:NSJSONReadingMutableLeaves
                                                                    error:nil]
                                  objectForKey:@"query"]
                                 objectForKey:@"pages"];
        NSEnumerator *TheEnumerator = [unwarpData keyEnumerator];
        id TheKey = [TheEnumerator nextObject];
        
        NSDictionary *theData = [unwarpData objectForKey:TheKey];
        
        _edit_pageid = [theData objectForKey:@"pageid"];
        _edit_title = [theData objectForKey:@"title"];
        _edit_startTime = [theData objectForKey:@"starttimestamp"];
        _edit_touchedTime = [theData objectForKey:@"touched"];
        _edit_token = [theData objectForKey:@"edittoken"];
        
        if (_edit_token == nil) {
            [self.hook addStatus:@"哎呀呀，出错了！找不到编辑令牌！\n"];
        }else{
            NSArray *revision = [theData objectForKey:@"revisions"];
            _targetContent = [[revision objectAtIndex:0] objectForKey:@"*"];
            
            [self.hook addStatus:[NSString stringWithFormat:@"页面名称：%@（ID:%@）\n",_edit_title,_edit_pageid]];
            [self.hook addStatus:[NSString stringWithFormat:@"页面最后更新时间：%@\n",_edit_touchedTime]];
            [self.hook addStatus:[NSString stringWithFormat:@"编辑令牌申请时间：%@\n",_edit_startTime]];
            [self.hook addStatus:[NSString stringWithFormat:@"编辑令牌：%@\n",_edit_token]];
            
            [self.hook addStatus:[NSString stringWithFormat:@"准备完成！！！"]];
            [self.hook initSuccess];
        }
    }
}

@end

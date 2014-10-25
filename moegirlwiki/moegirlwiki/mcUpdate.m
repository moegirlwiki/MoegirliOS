//
//  mcUpdate.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/25.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcUpdate.h"

@implementation mcUpdate


-(void)mcCachedRequestGotRespond
{

}

-(void)mcCachedRequestGotData
{
    
}

-(bool)checkData:(NSString *)data;
{
    if ([data hasPrefix:@"<!--confirmbegin-->"]&&[data hasSuffix:@"<!--confirmend-->"]){
        return YES;
    }
    return NO;
}

-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data
{
    
    if (success){
        recieveCount ++;
        [self.hook mcUpdateChangeLabel:[NSString stringWithFormat:@"接收 %d/5",recieveCount]];
    }else{
        [self.hook mcUpdateChangeLabel:@"更新失败"];
        [self.hook mcUpdatdFinished];
        
        [_errordefault setHook:nil];
        [_mainpageCache setHook:nil];
        [_oldcustomize setHook:nil];
        [_pagefooter setHook:nil];
        [_pageheader setHook:nil];
        
        [self setHook:nil];
    }
    
    if (recieveCount == 5) {
        recieveCount = 0;
        
        NSString * pt1 = [[NSString alloc] initWithData:_errordefault.recievePool encoding:NSUTF8StringEncoding];
        NSString * pt2 = [[NSString alloc] initWithData:_mainpageCache.recievePool encoding:NSUTF8StringEncoding];
        NSString * pt3 = [[NSString alloc] initWithData:_oldcustomize.recievePool encoding:NSUTF8StringEncoding];
        NSString * pt4 = [[NSString alloc] initWithData:_pagefooter.recievePool encoding:NSUTF8StringEncoding];
        NSString * pt5 = [[NSString alloc] initWithData:_pageheader.recievePool encoding:NSUTF8StringEncoding];
        
        if ([self checkData:pt1]&&[self checkData:pt2]&&[self checkData:pt3]&&[self checkData:pt4]&&[self checkData:pt5]) {
            
            
            NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString * mainpageDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"mainpage"];
            NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
            
            [pt2 writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageCache"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            [pt5 writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"pageheader"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [pt4 writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"pagefooter"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [pt3 writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"oldcustomize"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [pt1 writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"errordefault"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            
            NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
            [defaultdata setObject:[defaultdata objectForKey:@"engine_latest"] forKey:@"engine"];
            
            [self.hook mcUpdateChangeLabel:@"更新成功！"];
            [self.hook mcUpdatdFinished];
        }else{
            [self.hook mcUpdateChangeLabel:@"更新失败"];
            [self.hook mcUpdatdFinished];
        }
    }
}

- (void)launchUpdate
{
    recieveCount = 0;
    
    _errordefault = [mcCachedRequest new];
    _mainpageCache = [mcCachedRequest new];
    _oldcustomize = [mcCachedRequest new];
    _pagefooter = [mcCachedRequest new];
    _pageheader = [mcCachedRequest new];
    
    [_errordefault setHook:self];
    [_mainpageCache setHook:self];
    [_oldcustomize setHook:self];
    [_pagefooter setHook:self];
    [_pageheader setHook:self];

    [_errordefault launchRequest:@"https://masterchan.me:1024/v20/initdata/errordefault.html" ignoreCache:YES];
    [_mainpageCache launchRequest:@"https://masterchan.me:1024/v20/initdata/mainpageCache.html" ignoreCache:YES];
    [_oldcustomize launchRequest:@"https://masterchan.me:1024/v20/initdata/oldcustomize.html" ignoreCache:YES];
    [_pagefooter launchRequest:@"https://masterchan.me:1024/v20/initdata/pagefooter.html" ignoreCache:YES];
    [_pageheader launchRequest:@"https://masterchan.me:1024/v20/initdata/pageheader.html" ignoreCache:YES];
    
    
}

@end

//
//  moegirlConnectionLogin.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/28.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlConnectionLogin.h"

@implementation moegirlConnectionLogin

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
    [self.hook moegirlConnectionLogin:NO info:error.localizedFailureReason cookie:nil];
    
    NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
    [defaultdata setObject:@"--" forKey:@"username"];
    [defaultdata setObject:@"--" forKey:@"cookie"];
    [defaultdata synchronize];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    step ++;
    NSDictionary *TheData = [[NSJSONSerialization JSONObjectWithData:_recievePool
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil]
                             objectForKey:@"login"];
    if (step == 1) {
        
        if ([[TheData objectForKey:@"result"] isEqualToString:@"NeedToken"]) {
            
            session = [TheData objectForKey:@"sessionid"];
            token = [TheData objectForKey:@"token"];
            cookieprefix = [TheData objectForKey:@"cookieprefix"];
            
            [self RequestLogin];
        }else{
            [self.hook moegirlConnectionLogin:NO info:[TheData objectForKey:@"result"] cookie:nil];
            
            NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
            [defaultdata setObject:@"--" forKey:@"username"];
            [defaultdata setObject:@"--" forKey:@"cookie"];
            [defaultdata synchronize];
        }
    }else if (step == 2){
        if ([[TheData objectForKey:@"result"] isEqualToString:@"Success"]) {
            [self.hook moegirlConnectionLogin:YES info:[TheData objectForKey:@"result"] cookie:[TheData objectForKey:@"lgtoken"]];
            
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            
            [cookieProperties setObject:[NSString stringWithFormat:@"%@Token",cookieprefix] forKey:NSHTTPCookieName];
            [cookieProperties setObject:[TheData objectForKey:@"lgtoken"] forKey:NSHTTPCookieValue];
            [cookieProperties setObject:@".moegirl.org" forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:@".moegirl.org" forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:60*60*24*30*6] forKey:NSHTTPCookieExpires];
            
            NSHTTPCookie *theCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:theCookie];
            
            NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
            [defaultdata setObject:savedUsername forKey:@"username"];
            [defaultdata setObject:[TheData objectForKey:@"lgtoken"] forKey:@"cookie"];
            [defaultdata synchronize];
            
            //NSLog(@"%@",[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
            
        }else{
            [self.hook moegirlConnectionLogin:NO info:[TheData objectForKey:@"result"] cookie:nil];
            
            NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
            [defaultdata setObject:@"--" forKey:@"username"];
            [defaultdata setObject:@"--" forKey:@"cookie"];
            [defaultdata synchronize];
        }
        step = 0;
    }
}

- (id)init{
    return self;
}

- (void)SetUsername:(NSString *)username Password:(NSString *)password
{
    savedUsername = username;
    savedPassword = password;
}

- (void)RequestLogin
{
    
    NSString *RequestURL =@"http://zh.moegirl.org/api.php";
    NSString *RequestContent = [NSString stringWithFormat:@"action=login&lgname=%@&lgpassword=%@&lgtoken=%@&format=json",
                                savedUsername,
                                savedPassword,
                                token
                                ];
    NSString *RequestCookie = [NSString stringWithFormat:@"%@_session=%@",
                               cookieprefix,session
                               ];
    
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:20];
    
    [TheRequest setHTTPMethod:@"POST"];
    [TheRequest setValue:RequestCookie forHTTPHeaderField:@"Cookie"];
    [TheRequest setHTTPBody:[RequestContent dataUsingEncoding:NSUTF8StringEncoding]];
    
    _recievePool = nil;
    
    requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest delegate:self];
    
}

- (void)StartRequest
{
    step = 0;
    
    NSString *RequestURL = @"http://zh.moegirl.org/api.php";
    NSString *RequestContent = [NSString stringWithFormat:@"action=login&lgname=%@&lgpassword=%@&format=json",
                                savedUsername,savedPassword];
    
    NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:RequestURL]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:20];
    [TheRequest setHTTPMethod:@"POST"];
    [TheRequest setHTTPBody:[RequestContent dataUsingEncoding:NSUTF8StringEncoding]];
    
    requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                        delegate:self];
    
}

@end

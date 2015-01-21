//
//  mcCachedRequest.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcCachedRequest.h"

@implementation mcCachedRequest

- (NSString*)MD5:(NSString *)targetString
{
    const char *ptr = [targetString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (void)cancelRequest
{
    [requestConnection cancel];
    [self setHook:nil];
}

- (void)launchRequest:(NSString *)URL ignoreCache:(bool)ignore
{
    NSString * hashString = [self MD5:URL];
    
    documentPath = [[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                      stringByAppendingPathComponent:@"cache"]
                     stringByAppendingPathComponent:@"page"]
                    stringByAppendingPathComponent:hashString];
    
    fileManager = [NSFileManager defaultManager];
    if (([fileManager fileExistsAtPath:documentPath])&&(!ignore)) {
            [self.hook mcCachedRequestFinishLoading:YES
                                      LoadFromCache:YES
                                              error:nil
                                               data:[[NSMutableData alloc] initWithContentsOfFile:documentPath]];
    }else{
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:20];
        
        [TheRequest setHTTPShouldHandleCookies:YES];
        requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                           delegate:self
                                                   startImmediately:YES];
    }
}

- (void)launchPostRequestForRandom:(NSString *)URL ignoreCache:(bool)ignore
{
    NSString * hashString = [self MD5:URL];
    
    documentPath = [[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                      stringByAppendingPathComponent:@"cache"]
                     stringByAppendingPathComponent:@"page"]
                    stringByAppendingPathComponent:hashString];
    
    fileManager = [NSFileManager defaultManager];
    if (([fileManager fileExistsAtPath:documentPath])&&(!ignore)) {
        [self.hook mcCachedRequestFinishLoading:YES
                                  LoadFromCache:YES
                                          error:nil
                                           data:[[NSMutableData alloc] initWithContentsOfFile:documentPath]];
    }else{
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:2];
        [TheRequest setHTTPMethod:@"POST"];
        [TheRequest setHTTPShouldHandleCookies:YES];
        requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                           delegate:self
                                                   startImmediately:YES];
    }
}

- (void)launchCookiedRequest:(NSString *)URL ignoreCache:(bool)ignore
{
    NSString * hashString = [self MD5:URL];
    
    documentPath = [[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                      stringByAppendingPathComponent:@"cache"]
                     stringByAppendingPathComponent:@"page"]
                    stringByAppendingPathComponent:hashString];
    
    fileManager = [NSFileManager defaultManager];
    if (([fileManager fileExistsAtPath:documentPath])&&(!ignore)) {
        
        @try{
            [self.hook mcCachedRequestFinishLoading:YES
                                      LoadFromCache:YES
                                              error:nil
                                               data:[[NSMutableData alloc] initWithContentsOfFile:documentPath]];
        }@catch (NSException *exception) {NSLog(@"Oh___1");}@finally {}
    }else{
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]
                                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                    timeoutInterval:20];
        
        [TheRequest setHTTPShouldHandleCookies:YES];
        requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                           delegate:self
                                                   startImmediately:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recievePool = [NSMutableData new];
    @try{
    [self.hook mcCachedRequestGotRespond];
    }@catch (NSException *exception) {NSLog(@"Oh___2");}@finally {}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recievePool appendData:data];
    @try{
    [self.hook mcCachedRequestGotData];
    }@catch (NSException *exception) {NSLog(@"Oh___3");}@finally {}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    @try{
    [self.hook mcCachedRequestFinishLoading:NO
                              LoadFromCache:NO
                                      error:error.localizedDescription
                                       data:nil];
    }@catch (NSException *exception) {NSLog(@"Oh___4");}@finally {}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try{
    [self.hook mcCachedRequestFinishLoading:YES
                              LoadFromCache:NO
                                      error:nil
                                       data:_recievePool];
    [_recievePool writeToFile:documentPath atomically:YES];
    }@catch (NSException *exception) {NSLog(@"Oh___5");}@finally {}
}

@end

//
//  moegirlRandom.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/28.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlRandom.h"

@implementation moegirlRandom

#pragma mark Cached Request Delegate

-(void)mcCachedRequestGotRespond
{
    
}

-(void)mcCachedRequestGotData
{
    
}

-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data
{
    if (success) {
        
        NSInteger i;
        NSString * thetext;
        NSRange therange;
        NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray * randomPool = [NSMutableArray new];
        
        for (i=0; i<10; i++) {
            therange = [content rangeOfString:@"title=\"" options:NSLiteralSearch];
            content = [content substringFromIndex:therange.location+7];
            therange = [content rangeOfString:@"\" />" options:NSLiteralSearch];
            thetext = [content substringToIndex:therange.location];
            content = [content substringFromIndex:therange.location+4];
            [randomPool addObject:thetext];
        }
        keyWord = [randomPool objectAtIndex:(int)(arc4random()%10)];
        NSString *title = [NSString stringWithFormat:@"你摇到了「 %@ 」",keyWord];
        
        UIAlertView * randomAlert = [[UIAlertView alloc] initWithTitle:title
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"查看", nil];
        [randomAlert show];
        
        randomRequest = [mcCachedRequest new];
        [randomRequest setHook:nil];
        [randomRequest launchPostRequestForRandom:@"https://masterchan.me:1024/v20/random.php" ignoreCache:YES];
    }else{
        UIAlertView * randomAlert = [[UIAlertView alloc] initWithTitle:@"什么也没摇到~~~"
                                                               message:@"由于网络原因无法连接服务器"
                                                              delegate:nil
                                                     cancelButtonTitle:@"知道了"
                                                     otherButtonTitles:nil];
        [randomAlert show];
        
    }
}

-(void)cancelRequest
{
    [randomRequest cancelRequest];
    [self setHook:nil];
}

-(void)getARandom
{
    randomRequest = [mcCachedRequest new];
    [randomRequest setHook:self];
    [randomRequest launchPostRequestForRandom:@"https://masterchan.me:1024/v20/random.php" ignoreCache:NO];
}
#pragma mark AlertViewAction

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * btnText = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"查看"]) {
        [self.hook newWebViewRequestFormRandom:keyWord];
    }
}

@end

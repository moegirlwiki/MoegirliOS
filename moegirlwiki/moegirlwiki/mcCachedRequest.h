//
//  mcCachedRequest.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@protocol mcCachedRequestDelegate <NSObject>

-(void)mcCachedRequestGotRespond;
-(void)mcCachedRequestGotData;
-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data;

@end

@interface mcCachedRequest : NSObject
{
    @private
    NSURLConnection *requestConnection;
    NSString * documentPath;
    NSFileManager *fileManager;
}

- (void)launchRequest:(NSString *)URL ignoreCache:(bool)ignore;
- (void)launchPostRequest:(NSString *)URL ignoreCache:(bool)ignore;
- (void)launchCookiedRequest:(NSString *)URL ignoreCache:(bool)ignore;

- (NSString *)MD5:(NSString *)targetString;

@property (strong,nonatomic) NSMutableData * recievePool;
@property (assign,nonatomic) id<mcCachedRequestDelegate> hook;

@end

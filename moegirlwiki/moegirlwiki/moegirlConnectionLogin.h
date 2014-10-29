//
//  moegirlConnectionLogin.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/28.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol moegirlConnectionLoginDelegate <NSObject>
-(void)moegirlConnectionLogin:(bool)success info:(NSString *)info cookie:(NSString *)cookieString;
@end

@interface moegirlConnectionLogin : NSObject
{
    @private
    NSURLConnection *requestConnection;
    NSInteger step;
    NSString * savedUsername;
    NSString * savedPassword;
    NSString * token;
    NSString * session;
    NSString * cookieprefix;
}


- (void)SetUsername:(NSString *)username Password:(NSString *)password;
- (void)StartRequest;


@property (strong,nonatomic) NSMutableData * recievePool;
@property (assign,nonatomic) id<moegirlConnectionLoginDelegate> hook;

@end

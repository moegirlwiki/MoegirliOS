//
//  moegirlEditorInit.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol moegirlEditorInitDelegate<NSObject>
- (void)addStatus:(NSString *)statusText;
- (void)initSuccess;

@end

@interface moegirlEditorInit : NSObject
{
    @private
    NSURLConnection *requestConnection;
}

-(void)cancelRequest;
-(void)fetchToken;
-(void)prepareContent;

@property  (assign, nonatomic) id<moegirlEditorInitDelegate> hook;

@property (strong,nonatomic) NSString * targetTitle;
@property (strong,nonatomic) NSString * targetContent;

@property (strong,nonatomic) NSString * edit_pageid;
@property (strong,nonatomic) NSString * edit_title;
@property (strong,nonatomic) NSString * edit_touchedTime;
@property (strong,nonatomic) NSString * edit_startTime;
@property (strong,nonatomic) NSString * edit_token;

@property (strong,nonatomic) NSMutableData * recievePool;
@property (strong,nonatomic) NSURLResponse * responsePool;

@end

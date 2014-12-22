//
//  moegirlEditorSubmit.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/12/22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol moegirlEditorSubmitDelegate<NSObject>
- (void)addStatus:(NSString *)statusText;
- (void)initSuccess;
@end

@interface moegirlEditorSubmit : NSObject
{
    @private
        NSURLConnection *requestConnection;
}

-(void)cancelRequest;
-(void)submitRequest;
-(void)finishRequest;

@property (strong, nonatomic) NSString * wikiTextString;

@property (strong,nonatomic) NSString * edit_pageid;
@property (strong,nonatomic) NSString * edit_title;
@property (strong,nonatomic) NSString * edit_touchedTime;
@property (strong,nonatomic) NSString * edit_startTime;
@property (strong,nonatomic) NSString * edit_token;

@property (strong,nonatomic) NSMutableData * recievePool;
@property (strong,nonatomic) NSURLResponse * responsePool;

@property  (assign, nonatomic) id<moegirlEditorSubmitDelegate> hook;

@end

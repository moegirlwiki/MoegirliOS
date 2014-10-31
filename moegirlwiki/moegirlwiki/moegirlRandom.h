//
//  moegirlRandom.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/28.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mcCachedRequest.h"
@protocol moegirlRandomDelegate<NSObject>

- (void)newWebViewRequestFormRandom:(NSString *)keyword;

@end

@interface moegirlRandom : NSObject<mcCachedRequestDelegate>
{
    @private
    mcCachedRequest * randomRequest;
    NSString * keyWord;
}

-(void)cancelRequest;
-(void)getARandom;

@property (assign, nonatomic) id<moegirlRandomDelegate> hook;

@end

//
//  mcUpdate.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/25.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mcCachedRequest.h"

@protocol mcUpdateDelegate<NSObject>

-(void)mcUpdateChangeLabel:(NSString *)hint;
-(void)mcUpdatdFinished;

@end


@interface mcUpdate : NSObject<mcCachedRequestDelegate>
{
    @private
    int recieveCount;
}

- (bool)checkData:(NSString *)data;
- (void)launchUpdate;

@property (strong, nonatomic) mcCachedRequest * errordefault;
@property (strong, nonatomic) mcCachedRequest * oldcustomize;
@property (strong, nonatomic) mcCachedRequest * pagefooter;
@property (strong, nonatomic) mcCachedRequest * pageheader;

@property (assign, nonatomic) id<mcUpdateDelegate> hook;

@end

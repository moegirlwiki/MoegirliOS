//
//  mcAppDelegate.h
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcInitial.h"

@protocol mcAppDelegate <NSObject>

- (void)urlSchemeCall:(NSString *)target;

@end

@interface mcAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) id<mcAppDelegate> hook;

@end

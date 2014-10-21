//
//  mcAppDelegate.m
//  moegirlwiki
//
//  Created by master on 14-10-21.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcAppDelegate.h"

@implementation mcAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    if (![[defaultdata objectForKey:@"version"] isEqualToString:@"2.0"]) {
    //首次开启程序

        /*
        ------初始化目录结构------
        /cache
        /cache/page
        /cache/image
        /data
        /data/mainpage
        /data/setting
        */
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"cache"] stringByAppendingPathComponent:@"page"] withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"cache"] stringByAppendingPathComponent:@"image"] withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"mainpage"] withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:[[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"] withIntermediateDirectories:YES attributes:nil error:nil];
        
        //初始化关键文件
        NSString * mainpageDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"mainpage"];

        NSString * tempFile = @"<div id=\"mainpage\"><div id=\"mainpage-a\"><div class=\"mainpage-newsbox\"><div class=\"mainpage-title\">你好~欢迎来到萌娘百科！</div><div class=\"mainpage-1stcontent\">请下拉刷新页面</div></div></div></div>";
        [tempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageCache"] atomically:YES encoding:NSUTF8StringEncoding error:nil];

        tempFile = @"2014-10-20 12:00:00";
        [tempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageDate"] atomically:YES encoding:NSUTF8StringEncoding error:nil];

        //赋值UserDefaults
        [defaultdata setObject:@"2.0" forKey:@"version"];
        [defaultdata synchronize];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  mcInitial.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcInitial.h"

@implementation mcInitial

- (void)resetFiles
{
    NSUserDefaults * defaultdata = [NSUserDefaults standardUserDefaults];
    
    NSString * uuid = [defaultdata objectForKey:@"uuid"];
    if (uuid == nil) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    NSString * username = @"--";
    NSString * cookie = @"--";
/*
    NSString * username = [defaultdata objectForKey:@"username"];
    if (username != nil) {
        username = [defaultdata objectForKey:@"username"];
    }else{
        username = @"--";
    }
    
    NSString * cookie = [defaultdata objectForKey:@"cookie"];
    if (cookie != nil) {
        cookie = [defaultdata objectForKey:@"cookie"];
    }else{
        cookie = @"--";
    }
*/
    
    NSDictionary * dict = [defaultdata dictionaryRepresentation];
    for (id key in dict) {
        [defaultdata removeObjectForKey:key];
    }
    [defaultdata synchronize];
    
    [defaultdata setBool:NO forKey:@"NoImage"];
    [defaultdata setObject:@"20150101" forKey:@"engine"];
    [defaultdata setObject:@"--" forKey:@"engine_latest"];
    [defaultdata setObject:username forKey:@"username"];
    [defaultdata setObject:cookie forKey:@"cookie"];
    [defaultdata setObject:uuid forKey:@"uuid"];
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
    
    
    
    /*初始化关键文件*/
    //1. 首页数据   /data/mainpage/mainpageCache
    NSString * mainpageDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"mainpage"];
    NSURL * fileURL = [[NSBundle mainBundle] URLForResource:@"mainpageCache" withExtension:@"html" subdirectory:@"initdata"];
    NSString * tempFile = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    [tempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageCache"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    //2.首页日期    /data/mainpage/mainpageDate
    tempFile = @"2014-11-27 00:00:00";
    [tempFile writeToFile:[mainpageDocumentPath stringByAppendingPathComponent:@"mainpageDate"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    //3.默认页首    /data/setting/pageheader
    NSString * htmlDocumentPath = [[documentPath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:@"setting"];
    fileURL = [[NSBundle mainBundle] URLForResource:@"pageheader" withExtension:@"html" subdirectory:@"initdata"];
    tempFile = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    [tempFile writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"pageheader"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //4.默认页脚    /data/setting/pagefooter
    fileURL = [[NSBundle mainBundle] URLForResource:@"pagefooter" withExtension:@"html" subdirectory:@"initdata"];
    tempFile = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    [tempFile writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"pagefooter"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //5.对于无法使用 action=render 的采用旧版样式 /data/setting/oldcustomize
    fileURL = [[NSBundle mainBundle] URLForResource:@"oldcustomize" withExtension:@"html" subdirectory:@"initdata"];
    tempFile = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    [tempFile writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"oldcustomize"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //6.默认错误页面 /data/setting/errordefault
    fileURL = [[NSBundle mainBundle] URLForResource:@"errordefault" withExtension:@"html" subdirectory:@"initdata"];
    tempFile = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    [tempFile writeToFile:[htmlDocumentPath stringByAppendingPathComponent:@"errordefault"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    /*赋值UserDefaults*/
    [defaultdata setObject:@"2.4" forKey:@"version"];
    [defaultdata synchronize];
    
}

@end

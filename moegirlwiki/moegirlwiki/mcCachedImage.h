//
//  mcCachedImage.h
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@protocol mcCachedImage <NSObject>

-(void)finishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error;

@end

@interface mcCachedImage : UIImageView
{
    @private
    NSURLConnection *requestConnection;
    NSString * documentPath;
    NSFileManager *fileManager;
}

- (void)loadFromURL:(NSString *)URL ignoreCache:(BOOL)ignoreCache;
- (NSString *)MD5:(NSString *)targetString;

@property (strong,nonatomic) NSMutableData * recievePool;
@property (assign,nonatomic) id<mcCachedImage> hook;

@end

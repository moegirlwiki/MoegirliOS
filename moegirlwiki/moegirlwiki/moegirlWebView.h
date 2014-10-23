//
//  moegirlWebView.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcCachedRequest.h"

@protocol moegirlWebViewDelegate <NSObject>

- (void)newWebViewRequestFormWebView:(NSString *)decodedKeyword;

@end

@interface moegirlWebView : UIWebView<UIWebViewDelegate,mcCachedRequestDelegate>
{
    
}

- (NSString *)prepareContent:(NSData *)data;
- (void)loadContentWithDecodedKeyWord:(NSString *)keywordAfterDecode useCache:(BOOL)useCache;
- (void)loadContentWithKeyWord:(NSString *)keyword useCache:(BOOL)useCache;

@property (strong, nonatomic) mcCachedRequest * contentRequest;
@property (strong, nonatomic) NSString * targetURL;
@property (strong, nonatomic) NSString * keyword;

@property (assign, nonatomic) id<moegirlWebViewDelegate> hook;

@end

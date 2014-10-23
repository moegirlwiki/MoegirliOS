//
//  moegirlWebView.h
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcCachedRequest.h"

@interface moegirlWebView : UIWebView<UIWebViewDelegate,mcCachedRequestDelegate>
{

}

@property (strong, nonatomic) mcCachedRequest * contentRequest;
@property (strong, nonatomic) NSString * targetURL;
@property (strong, nonatomic) NSString * keyword;

- (NSString *)urlEncode:(NSString *)unencodeString;
- (NSString *)prepareContent:(NSData *)data;
- (void)loadContentWithDecodedKeyWord:(NSString *)keywordAfterDecode useCache:(BOOL)useCache;
- (void)loadContentWithKeyWord:(NSString *)keyword useCache:(BOOL)useCache;

@end

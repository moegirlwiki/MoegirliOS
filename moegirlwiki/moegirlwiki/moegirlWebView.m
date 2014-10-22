//
//  moegirlWebView.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlWebView.h"

@implementation moegirlWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *)urlEncode:(NSString*)unencodeString
{
    NSString * encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodeString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)prepareContent:(NSData *)data
{
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    return content;
}

- (void)loadContentWithDecodedKeyWord:(NSString *)keywordAfterDecode useCache:(BOOL)useCache
{
    _keyword = keywordAfterDecode;
    _contentRequest = [mcCachedRequest new];
    [_contentRequest setHook:self];
    [_contentRequest launchRequest:[NSString stringWithFormat:@"%@/%@?action=render",_targetURL,_keyword] ignoreCache:useCache];
}

- (void)loadContentWithKeyWord:(NSString *)keyword useCache:(BOOL)useCache
{
    [self loadContentWithDecodedKeyWord:[self urlEncode:keyword] useCache:useCache];
}

-(void)mcCachedRequestFinishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error data:(NSMutableData *)data
{
    if (success) {
        [self loadHTMLString:[self prepareContent:data]
                     baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/moegirl-app-2.0/%@",_targetURL,_keyword]]];
    } else {
        NSLog(@"Error: %@",error);
    }
}

@end

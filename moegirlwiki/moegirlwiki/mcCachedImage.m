//
//  mcCachedImage.m
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcCachedImage.h"

@implementation mcCachedImage

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


- (NSString*)MD5:(NSString *)targetString
{
    const char *ptr = [targetString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}


-(void)loadFromURL:(NSString *)URL ignoreCache:(BOOL)ignoreCache
{
    NSString * hashString = [self MD5:URL];
    
    documentPath = [[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                      stringByAppendingPathComponent:@"cache"]
                     stringByAppendingPathComponent:@"image"]
                    stringByAppendingPathComponent:hashString];
    
    fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:documentPath]) {
        [self setImage:[UIImage imageWithContentsOfFile:documentPath]];
        [self setContentMode:UIViewContentModeCenter];
        [self.hook finishLoading:YES LoadFromCache:YES error:nil];
    }else{
        NSMutableURLRequest * TheRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URL]
                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                   timeoutInterval:20];
        requestConnection = [[NSURLConnection alloc]initWithRequest:TheRequest
                                                           delegate:self
                                                   startImmediately:YES];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _recievePool = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recievePool appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.hook finishLoading:NO LoadFromCache:NO error:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self setImage:[UIImage imageWithData:_recievePool]];
    [self setContentMode:UIViewContentModeCenter];
    [_recievePool writeToFile:documentPath atomically:YES];
    [self.hook finishLoading:YES LoadFromCache:NO error:nil];
}

@end

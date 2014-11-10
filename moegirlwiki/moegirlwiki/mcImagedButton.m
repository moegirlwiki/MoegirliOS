//
//  mcImagedButton.m
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/28.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcImagedButton.h"

@implementation mcImagedButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)finishLoading:(bool)success LoadFromCache:(bool)cache error:(NSString *)error
{
    if (success) {
        [self setBackgroundImage:btnImage.image forState:UIControlStateNormal];
        //NSLog(@"图片加载成功");
    }
}

-(void) cancelRequest
{
    [btnImage cancelRequest];
}

- (void)loadFormURL:(NSString *)URL target:(NSString *)keyword ignoreCache:(bool)ignoreCache
{
    btnImage = [mcCachedImage new];
    [btnImage setHook:self];
    [btnImage loadFromURL:URL ignoreCache:ignoreCache];
    _targetKeyword = keyword;
}

@end

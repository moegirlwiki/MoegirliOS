//
//  mcImagedButton.h
//  moegirlwiki
//
//  Created by Michael Chan on 14/10/28.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mcCachedImage.h"

@interface mcImagedButton : UIButton<mcCachedImage>
{
    @private
    mcCachedImage * btnImage;
}

- (void)loadFormURL:(NSString *)URL target:(NSString *)keyword ignoreCache:(bool)ignoreCache;
- (void)cancelRequest;

@property (strong, nonatomic) NSString * targetKeyword;
@property (assign, nonatomic) UIImage * targetImage;

@end

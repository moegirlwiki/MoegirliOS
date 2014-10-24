//
//  moegirlSaveImageAlertView.m
//  moegirlwiki
//
//  Created by master on 14-10-23.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "moegirlSaveImageAlertView.h"

@implementation moegirlSaveImageAlertView

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
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * btnText = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnText isEqualToString:@"保存"]) {
        NSLog(@"%@",_imageURL);
        NSData * tmpData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_imageURL]];
        UIImage * tmpImage = [[UIImage alloc] initWithData:tmpData];
        [self saveImageToPhotos:tmpImage];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"保存失败"
                                                    message:error.localizedFailureReason
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
        [alertview show];
    }else{
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"成功保存图片"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
        
        [alertview show];
    }
}

@end

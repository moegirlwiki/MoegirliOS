//
//  mcRightDrag.m
//  moegirlwiki
//
//  Created by master on 14-10-22.
//  Copyright (c) 2014年 masterchan.me. All rights reserved.
//

#import "mcRightDrag.h"

@implementation mcRightDrag

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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    startPoint = [touch locationInView:self];
    _offSetX = 0;
    [self.hook MoveMainViewByRightBegan];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    _offSetX = nowPoint.x - startPoint.x;
    [self setFrame:CGRectMake(self.frame.origin.x + _offSetX,
                              self.frame.origin.y,
                              self.frame.size.width,
                              self.frame.size.height
                              )];
    [self.hook MoveMainViewByRight:_offSetX];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_offSetX <= 0) {
        [self.hook MoveMainViewByRightEnded:YES];
    }else{
        [self.hook MoveMainViewByRightEnded:NO];
    }
}
@end

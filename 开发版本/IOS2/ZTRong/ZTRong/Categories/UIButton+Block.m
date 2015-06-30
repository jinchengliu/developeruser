//
//  UIButton+Block.m
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-1.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>
@implementation UIButton (Block)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block
{
    if(!event)
        event=UIControlEventTouchUpInside;
    objc_setAssociatedObject(self, &"myBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    block=objc_getAssociatedObject(self, &"ss");
//    if(self.se)
    [self addTarget:self
             action:@selector(blockEvent:)
   forControlEvents:event];
}
-(void)blockEvent:(UIButton *)sender
{
    ActionBlock block=objc_getAssociatedObject(self, &"myBlock");
    if(block)
    {
        block();
    }
}
@end

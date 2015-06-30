//
//  UIAlertView+Block.m
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-13.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>
@implementation UIAlertView (Block)
- (void)handleWithBlock:(AlertViewBlock)avb
{
    if(!avb)return;
    self.delegate=nil;
    self.delegate=self;
    objc_setAssociatedObject(self, &"alertVB", avb, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   AlertViewBlock avb=objc_getAssociatedObject(self, &"alertVB");
    if(avb){
        avb(buttonIndex);
    }
}
-(void)changeBackground
{
    [self show];

}

@end

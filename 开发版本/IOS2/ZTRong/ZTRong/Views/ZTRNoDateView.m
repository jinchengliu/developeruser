//  没数据的view
//  ZTRNoDateView.m
//  ZTRong
//
//  Created by fcl on 15/5/26.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "ZTRNoDateView.h"

@implementation ZTRNoDateView

-(id)initWithFrame:(CGRect)frame view :(UIView *)view{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews=YES;
        float x=(frame.size.width -view.frame.size.width)/2;
        float y=(frame.size.height -view.frame.size.height)/2;
      //  view.center = self.center;
        view.frame=CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
    }
    
    return self;
}

@end

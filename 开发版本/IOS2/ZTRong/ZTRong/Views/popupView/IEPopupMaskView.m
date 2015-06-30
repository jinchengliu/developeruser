//
//  IEPopupMaskView.m
//  InnExpert
//
//  Created by Charles on 13-8-18.
//  Copyright (c) 2013年 JTTW. All rights reserved.
//

#import "IEPopupMaskView.h"

@interface IEPopupMaskView () {
    //是否已移除
    BOOL isDismissed;
}

@property (nonatomic, copy)void(^dismission)(void);

@end

@implementation IEPopupMaskView

#pragma mark - UIResponder Method

-(id) init{
    self=[super init];
    
    if(self){
        self.bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        self.bgView.backgroundColor=[UIColor redColor];
        [self addSubview:self.bgView];
    }
    
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    
    if(self){
        self.bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.bgView.backgroundColor=[UIColor clearColor];
        [self addSubview:self.bgView];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (_tapToDismiss) {
        [self doDismiss];
    }
}

#pragma mark - Base Method

- (void)maskWillAppear {
    // do noting in base
}

- (void)maskDoAppear {
    // do noting in base
}

- (void)maskDidAppear {
    // do noting in base
}

- (void)maskWillDisappear {
    // do noting in base
}

- (void)maskDoDisappear {
    // do noting in base
}

- (void)maskDidDisappear {
    // do noting in base
}

#pragma mark - Inerface Method

- (void)showInView:(UIView *)view MaskColor:(UIColor *)maskColor Completion:(void(^)(void))completion Dismission:(void(^)(void))dismission{
    
    self.dismission = dismission;
    
    CGRect frame = self.bgView.bounds;
    if (view == [UIApplication sharedApplication].delegate.window) {
        frame.origin.y = 20;
        frame.size.height -= 20;
    }
    
    self.backgroundColor = [UIColor clearColor];
    frame.origin.y=[UIApplication sharedApplication].delegate.window.frame.size.height;
    self.bgView .frame=frame;
    //CGRectMake(0,[UIApplication sharedApplication].delegate.window.frame.size.height, [UIApplication sharedApplication].delegate.window.frame.size.width, [UIApplication sharedApplication].delegate.window.frame.size.height);;
    self.clipsToBounds = YES;
    [view addSubview:self];
    
    [self maskWillAppear];
    
    [UIView animateWithDuration:_animationDuration?_animationDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self maskDoAppear];
                         self.backgroundColor = maskColor;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             isDismissed=NO;
                             [self maskDidAppear];
                             
                             if (completion) {
                                 completion();
                             }
                         }
                     }];
    
    
    
    
    
//    [UIView beginAnimations:nil context:nil];
//    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//   // [UIView setAnimationRepeatAutoreverses:NO];
//   // [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
//    [UIView setAnimationDuration:0.7f];
//    //设置要变化的frame 推入与推出修改对应的frame即可
//    self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
    
    
    
    
   
    
}

- (void)doDismiss {
    
    if (isDismissed) {
        return;
    }
    else {
        isDismissed = YES;
    }
    
    [self maskWillDisappear];
    
    [UIView animateWithDuration:_animationDuration?_animationDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveEaseInOut animations:^{
        [self maskDoDisappear];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self maskDidDisappear];
        
        if (_dismission) {
            _dismission();
        }
        
        [self removeFromSuperview];
    }];
    
}


@end

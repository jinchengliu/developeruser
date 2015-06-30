//
//  IEPopupMaskView.h
//  InnExpert
//
//  Created by Charles on 13-8-18.
//  Copyright (c) 2013年 JTTW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEPopupMaskView : UIView

@property (nonatomic)BOOL tapToDismiss;
@property (nonatomic)CGFloat animationDuration;
@property (nonatomic)UIView *bgView;

#pragma mark - Base Method

- (void)maskWillAppear;

- (void)maskDoAppear;

- (void)maskDidAppear;

- (void)maskWillDisappear;

- (void)maskDoDisappear;

- (void)maskDidDisappear;


#pragma mark - Interface Method

- (void)showInView:(UIView *)view MaskColor:(UIColor *)maskColor Completion:(void(^)(void))completion Dismission:(void(^)(void))dismission;

- (void)doDismiss;

@end

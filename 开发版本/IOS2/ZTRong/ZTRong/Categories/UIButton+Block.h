//
//  UIButton+Block.h
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-1.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);
@interface UIButton (Block)
/*
 *  handleControlEvent:withBlock:
 *  使用block处理button事件
 *  入参:event 触发类型                 例: UIControlEventTouchUpInside
 *      block 满足触发条件后的事件        例:^{}
 *  注:最后入参有效,同时只能保存一个block触发事件
 */


- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
@end

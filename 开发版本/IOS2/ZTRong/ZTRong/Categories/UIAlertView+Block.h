//
//  UIAlertView+Block.h
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-13.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^AlertViewBlock)(NSInteger);//无返回值,入参无为int型,应用在alertView回调
@interface UIAlertView (Block)<UIAlertViewDelegate>

/*
 *  handleWithBlock:
 *  使用block来处理alertview事件
 *  入参: block 使用block来处理alertview事件 例:^(NSInteger butIndex){CFShow(@"block");
 */
- (void)handleWithBlock:(AlertViewBlock)block;
/*
 *  changeBackground
 *  修改alert的外观,必须在show之后使用
 */
-(void)changeBackground;
@end

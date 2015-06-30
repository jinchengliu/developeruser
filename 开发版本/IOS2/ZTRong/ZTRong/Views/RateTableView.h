//
//  RateTableView.h
//  ZTRong
//
//  Created by 李婷 on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEPopupMaskView.h"

@interface RateTableView : UIView
@property (nonatomic, strong) void (^didSelect)(NSString *str);
@property (nonatomic) BOOL isDescendingOrder;//是否降序
/**
 *  利率的下拉列表
 *
 *  @param frame 列表的大小
 *  @param arrs  数组内容
 *
 *  @return 下拉列表
 */
- (void)initWithFrame:(CGRect)frame withArrs:(NSArray *)arrs;
@end

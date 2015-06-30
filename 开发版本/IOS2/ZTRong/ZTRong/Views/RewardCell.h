//
//  RewardCell.h
//  ZTRong
//
//  Created by 李婷 on 15/6/8.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;//白色背景框
@property (weak, nonatomic) IBOutlet UIView *cellline;//中间的线条
@property (weak, nonatomic) IBOutlet UILabel *name;//用户名（包括等级）
@property (weak, nonatomic) IBOutlet UILabel *reward;//奖励金额
@property (weak, nonatomic) IBOutlet UILabel *investID;//标id
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;//订单金额
@property (weak, nonatomic) IBOutlet UILabel *rate;//费率
@property (weak, nonatomic) IBOutlet UILabel *dateTime;//发放日期
@property (weak, nonatomic) IBOutlet UIImageView *isInvestImage;//是否投资图片

@property (nonatomic) BOOL isInvest;//是否投资
@end

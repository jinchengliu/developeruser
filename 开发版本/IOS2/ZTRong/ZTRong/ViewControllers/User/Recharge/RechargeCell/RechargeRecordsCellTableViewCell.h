//
//  RechargeRecordsCellTableViewCell.h
//  ZTRong
//
//  Created by fcl on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeRecordsCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cnumberLB;                //编号

@property (weak, nonatomic) IBOutlet UILabel *finishTypeLB;             //完成状态
@property (weak, nonatomic) IBOutlet UIImageView *finishTypeImage;      //完成状态图片



@property (strong, nonatomic)  UILabel *cTimeLBTitle;                  //充值时间
@property (strong, nonatomic)  UILabel *cBankLBTitle;                  //充值银行
@property (strong, nonatomic)  UILabel *ccushLBTitle;                  //充值金额
@property (strong, nonatomic)  UILabel *cTimeLB;                  //充值时间
@property (strong, nonatomic)  UILabel *cBankLB;                  //充值银行
@property (strong, nonatomic)  UILabel *ccushLB;                  //充值金额
@property (strong, nonatomic)  UILabel *messageLB;                //备注

@property(strong ,nonatomic)  UIImageView *line1;
@property(strong ,nonatomic)  UIImageView *line2;


-(void)resetCell :(NSDictionary *)dic;


@end

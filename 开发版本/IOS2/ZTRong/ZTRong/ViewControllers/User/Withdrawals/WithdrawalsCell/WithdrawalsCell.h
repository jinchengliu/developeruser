//
//  WithdrawalsCell.h
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tnumberLB;                //编号
@property (weak, nonatomic) IBOutlet UILabel *tBankcardLB;              //提现卡号
@property (weak, nonatomic) IBOutlet UILabel *ttimeLB;                  //提现时间
@property (weak, nonatomic) IBOutlet UILabel *tcushLB;                  //提现金额
@property (weak, nonatomic) IBOutlet UILabel *tfeeLB;                   //提现手续费
@property (weak, nonatomic) IBOutlet UILabel *finishTypeLB;             //完成状态
@property (weak, nonatomic) IBOutlet UIImageView *finishTypeImage;      //完成状态图片

@property (weak, nonatomic) IBOutlet UILabel *messageLB;                //备注
@property (weak, nonatomic) IBOutlet UIView  *messageView;              //备注




-(void)resetCell :(NSDictionary *)dic;

@end

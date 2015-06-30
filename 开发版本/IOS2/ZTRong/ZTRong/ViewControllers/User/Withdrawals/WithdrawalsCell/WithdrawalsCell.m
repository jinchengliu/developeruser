//
//  WithdrawalsCell.m
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "WithdrawalsCell.h"
#import "NSString+TimestampToDate.h"

@implementation WithdrawalsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)resetCell :(NSDictionary *)dic{
    
    
    self.messageLB.text=@"";
    self.messageView.hidden=YES;
    if([dic objectForKey:@"memo"] !=nil){
        self.messageLB.text=[NSString stringWithFormat:@"备注%@", [dic objectForKey:@"memo"]];
        self.messageView.hidden=NO;
        
    }
    
//    depositId	String	内部提现流水号
//    createDate	Date	申请时间
//    bankCardNoStr	String	提现卡号
//    depositAmount	String	提现金额(格式化后的)
//    feeAmount	String	手续费
//    statusName	String	状态
//    feeAmountStr	String	手续费(格式化后的)
//    amount	String	提现金额
//    Status	String	提现状态
//    未审核    weishenhe
//    审核通过   shenhetongguo
//    审核未通过 shenheweitongguo
//    已完成    yiwancheng
//    memo   备注

    
    self.tnumberLB.text= [NSString stringWithFormat:@"流水号 %@", [dic objectForKey:@"depositId"] ];
    NSString *time=[dic objectForKey:@"createDateStr"];
    //[NSString stringWithFormat:@"%zi", [[dic objectForKey:@"createDate"] integerValue] ];

    self.ttimeLB.text=time;
    //[Tool dateFormatter:[time timestampToDate]];
    self.tBankcardLB.text=[NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@"bankName"],[dic objectForKey:@"bankCardNoStr"]];
    self.tcushLB.text=  [dic objectForKey:@"realyAmountStr"];
    self.tfeeLB.text=[NSString stringWithFormat:@"￥%@", [dic objectForKey:@"feeAmountStr"]];
    self.finishTypeLB.text=[dic objectForKey:@"statusName"];
    NSString *payState =[dic objectForKey:@"status"];
    //if(payState i)
    if([payState isEqualToString:@"yiwancheng"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType3"];
    }else if([payState isEqualToString:@"weishenhe"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType1"];
        
    }else if([payState isEqualToString:@"shenheweitongguo"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType2"];
    }else if([payState isEqualToString:@"shenhetongguo"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType3"];
        
    }
    
        
    
}



@end

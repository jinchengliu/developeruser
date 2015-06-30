//
//  RechargeRecordsCellTableViewCell.m
//  ZTRong
//
//  Created by fcl on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "RechargeRecordsCellTableViewCell.h"


@implementation RechargeRecordsCellTableViewCell

- (void)awakeFromNib {
    // 充值时间
    self.cTimeLBTitle=[Tool createLable:CUSTOMCOLOR(121,121,121) font:13 frame:CGRectMake(8, 39, 120*APPDELEGATE.autoSizeScaleX, 15)];
    self.cTimeLBTitle.text=@"充值时间";
    
    self.cTimeLB=[Tool createLable:CUSTOMCOLOR(189,163,123) font:12 frame:CGRectMake(8, 64, 120*APPDELEGATE.autoSizeScaleX, 15)];
    self.cTimeLB.text=@"";
    
    
    
    // 充值银行
    self.cBankLBTitle=[Tool createLable:CUSTOMCOLOR(121,121,121) font:13 frame:CGRectMake(145*APPDELEGATE.autoSizeScaleX, 39, 65*APPDELEGATE.autoSizeScaleX, 15)];
    self.cBankLBTitle.text=@"充值银行";
    self.cBankLBTitle.textAlignment=NSTextAlignmentCenter;
    self.cBankLB=[Tool createLable:CUSTOMCOLOR(189,163,123) font:13 frame:CGRectMake(145*APPDELEGATE.autoSizeScaleX, 64, 65*APPDELEGATE.autoSizeScaleX, 15)];
    self.cBankLB.text=@"";
    self.cBankLB.textAlignment=NSTextAlignmentCenter;
    

    //充值金额
    self.ccushLBTitle=[Tool createLable:CUSTOMCOLOR(121,121,121) font:13 frame:CGRectMake(230*APPDELEGATE.autoSizeScaleX, 39, 80*APPDELEGATE.autoSizeScaleX, 15)];
    self.ccushLBTitle.text=@"充值金额";
    self.ccushLB=[Tool createLable:CUSTOMCOLOR(189,163,123) font:13 frame:CGRectMake(230*APPDELEGATE.autoSizeScaleX, 64, 80*APPDELEGATE.autoSizeScaleX, 15)];
    self.ccushLB.text=@"";
    
    
    //虚线
    self.line1=[[UIImageView alloc] initWithFrame:CGRectMake(135*APPDELEGATE.autoSizeScaleX, 39, 1, 40)];
    self.line1.image=[UIImage imageNamed:@"xuline"];
    self.line2=[[UIImageView alloc] initWithFrame:CGRectMake(220*APPDELEGATE.autoSizeScaleX, 39, 1, 40)];
    self.line2.image=[UIImage imageNamed:@"xuline"];
    
    
    //备注
    self.messageLB=[Tool createLable:CUSTOMCOLOR(233,112,51) font:13 frame:CGRectMake(8, 89, 280*APPDELEGATE.autoSizeScaleX, 15)];
    self.messageLB.text=@"备注";
    
    

    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addLables {
    UIView *view=[self.contentView viewWithTag:1000];
    UIView *view1=[view viewWithTag:1001];
    
    [view1 addSubview:self.cTimeLBTitle];
    [view1 addSubview:self.cBankLBTitle];
    [view1 addSubview:self.ccushLBTitle];
    [view1 addSubview:self.cTimeLB];
    [view1 addSubview:self.cBankLB];
    [view1 addSubview:self.ccushLB];
    [view1 addSubview:self.line1];
    [view1 addSubview:self.line2];
    
    [view1 addSubview:self.messageLB];
    
}

-(void)resetCell :(NSDictionary *)dic{
    
    [self addLables];
    self.messageLB.text=@"";
    
    if([dic objectForKey:@"memo"] !=nil){
        self.messageLB.text=[NSString stringWithFormat:@"备注：%@", [dic objectForKey:@"memo"]];
        
    }
   
//    rechargeId	String	编号
//    createDate	Date	充值时间
//    bankNumStr	String	充值银行
//    orderAmountStr	String	充值金额(格式化后的)
//    payStateStr	String	状态
//    payState	String	充值状态
//    "weiwancheng","未完成",
//    "yiwancheng","已完成",
//    "shibai","失败";
//    //memo   备注
    
    self.cnumberLB.text=[NSString stringWithFormat:@"编号: %@",[dic objectForKey:@"rechargeId"]]  ;
    
    
    NSString *time=[dic objectForKey:@"createDateStr"];
    //[NSString stringWithFormat:@"%zi", [[dic objectForKey:@"createDate"] integerValue] ];
    
    self.cTimeLB.text=time;
   // self.cTimeLB.text=[dic objectForKey:@"createDate"];
    self.cBankLB.text=[dic objectForKey:@"bankNumStr"];
    self.ccushLB.text=[NSString stringWithFormat:@"￥%@", [dic objectForKey:@"orderAmountStr"]];
    self.finishTypeLB.text=[dic objectForKey:@"payStateStr"];
    NSString *payState =[dic objectForKey:@"payState"];
    //if(payState i)
    if([payState isEqualToString:@"yiwancheng"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType3"];
    }else if([payState isEqualToString:@"weiwancheng"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType1"];
        
    }else if([payState isEqualToString:@"shibai"]){
        self.finishTypeImage.image=[UIImage imageNamed:@"recharge_fType2"];
    }
}

@end

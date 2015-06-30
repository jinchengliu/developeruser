//
//  BankCardAuthenPopup.m
//  ZTRong
//
//  Created by fcl on 15/5/25.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "BankCardAuthenPopup.h"

@implementation BankCardAuthenPopup

- (void)maskWillAppear {
    // do noting in base
    [super maskWillAppear];
    float y=kAppHeight -250;
    // waitingCenterView.frame=CGRectMake((kApplicationFrameWidth-286)/2, y/2, 286, 335);
    
    UIView  *waitingCenterView = [[UIView alloc] initWithFrame:CGRectMake((kAppWidth-286)/2, y/2, 286, 250)];
    waitingCenterView.backgroundColor = [UIColor clearColor];
    waitingCenterView.layer.cornerRadius = 5;
    waitingCenterView.layer.masksToBounds = YES;
    [self.bgView addSubview:waitingCenterView];
    
    
    
    
    //self.bgView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    
    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 286, 250)];
    bg.backgroundColor=[UIColor whiteColor];
    //bg.image=[UIImage imageNamed:@"xuanyao_bg"];
    [waitingCenterView addSubview:bg];
    
    
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 27, 27)];
    icon.image =[UIImage imageNamed:@"recharge_icon10"];
    
    [waitingCenterView addSubview:icon];
    
    UILabel *tilte=[[UILabel alloc] initWithFrame:CGRectMake(50, 33, 240, 20)];
    tilte.text=@"您的银行认证信息已提交！";
    tilte.font=[UIFont systemFontOfSize:17];
    tilte.textColor = [UIColor colorWithRed:68/255.0 green:51/255.0 blue:44/255.0 alpha:1];
    tilte.backgroundColor=[UIColor clearColor];
    
    [waitingCenterView addSubview:tilte];
    
    UILabel *mesg1=[[UILabel alloc] initWithFrame:CGRectMake(15, 85, 266, 48)];
    mesg1.text=@"您将接到银联DNA支付平台的专线专号96585/020-96585语音来电，请按语音提示完成认证操作";
    mesg1.font=[UIFont systemFontOfSize:13];
    mesg1.numberOfLines=0;
    mesg1.backgroundColor=[UIColor clearColor];
    [waitingCenterView addSubview:mesg1];
    
    
    
//    UILabel *mesg2=[[UILabel alloc] initWithFrame:CGRectMake(15, 103, 266, 15)];
//    mesg2.text=@"";
//    mesg2.font=[UIFont systemFontOfSize:12];
//    mesg2.backgroundColor=[UIColor clearColor];
//    [waitingCenterView addSubview:mesg2];
    
    
    
    
    UIButton *cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(16, 170, 120, 40)];
    [cancelBtn setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"认证完成" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [waitingCenterView addSubview:cancelBtn];
    
    
    UIButton *doBtn=[[UIButton alloc] initWithFrame:CGRectMake(150, 170, 120, 40)];
    [doBtn setBackgroundImage:[Tool createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [doBtn setTitleColor:ButtonBG forState:UIControlStateNormal];
    [doBtn setTitle:@"继续认证" forState:UIControlStateNormal];
    doBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    doBtn.layer.cornerRadius = 5;
    doBtn.layer.masksToBounds = YES;
    doBtn.layer.borderColor=ButtonBG.CGColor;
    doBtn.layer.borderWidth=1;
    [doBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    [waitingCenterView addSubview:doBtn];
    
}

-(void)finish{
     [self doDismiss];
    if(self.finishBlock){
        self.finishBlock();
    }
    
}

-(void)doCancel{
    [self doDismiss];
}





- (void)maskDoAppear {
    [super maskDoAppear];
    self.bgView.frame=CGRectMake(0,self.bgView.frame.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)maskDidAppear {
    // do noting in base
    [super maskDidAppear];
}

- (void)maskWillDisappear {
    // do noting in base
    [super maskWillDisappear];
}

- (void)maskDoDisappear {
    // do noting in base
    [super maskDoDisappear];
    self.bgView.frame=CGRectMake(0,kAppHeight, self.frame.size.width, self.frame.size.height);
}

- (void)maskDidDisappear {
    // do noting in base
    [super maskDidDisappear];
}



@end

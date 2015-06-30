//
//  WithdrawalsFinishPoPup.m
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "WithdrawalsFinishPoPup.h"

@implementation WithdrawalsFinishPoPup

- (void)maskWillAppear {
    // do noting in base
    [super maskWillAppear];
    float y=kAppHeight -220;
   // waitingCenterView.frame=CGRectMake((kApplicationFrameWidth-286)/2, y/2, 286, 335);
    
    UIView  *waitingCenterView = [[UIView alloc] initWithFrame:CGRectMake((kAppWidth-286)/2, y/2, 286, 220)];
    waitingCenterView.backgroundColor = [UIColor clearColor];
    //waitingCenterView.layer.cornerRadius = 10;
    [self.bgView addSubview:waitingCenterView];
    
    
    
    
    //self.bgView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    
    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 286, 220)];
    bg.backgroundColor=[UIColor whiteColor];
    //bg.image=[UIImage imageNamed:@"xuanyao_bg"];
      [waitingCenterView addSubview:bg];
    
    
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 27, 27)];
    icon.image =[UIImage imageNamed:@"recharge_icon10"];
    
    [waitingCenterView addSubview:icon];
    
    UILabel *tilte=[[UILabel alloc] initWithFrame:CGRectMake(75, 33, 200, 20)];
    tilte.text=@"提现申请提交成功！";
    tilte.font=[UIFont systemFontOfSize:16];
   tilte.textColor = [UIColor colorWithRed:251/255 green:251/255 blue:251/255 alpha:1];
    tilte.backgroundColor=[UIColor clearColor];
    
    [waitingCenterView addSubview:tilte];
    
    UILabel *mesg1=[[UILabel alloc] initWithFrame:CGRectMake(20, 65, 246, 40)];
    mesg1.text=@"1,为了您的资金安全，提现申请提交后需要审核通过后才能提现成功。";
    mesg1.font=[UIFont systemFontOfSize:13];
    mesg1.backgroundColor=[UIColor clearColor];
    mesg1.numberOfLines=2;
    [waitingCenterView addSubview:mesg1];
    
    
    
    UILabel *mesg2=[[UILabel alloc] initWithFrame:CGRectMake(20, 110, 246, 40)];
    mesg2.text=@"2，由于具体银行处理时间不同，提现申请提交后，正常T+1个工作日到账";
    mesg2.font=[UIFont systemFontOfSize:13];
    mesg2.backgroundColor=[UIColor clearColor];
    mesg2.numberOfLines=2;
    [waitingCenterView addSubview:mesg2];


    
    
    UIButton *cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(73, 165, 140, 31)];
    [cancelBtn setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    [waitingCenterView addSubview:cancelBtn];
    
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

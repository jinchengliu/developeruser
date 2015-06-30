//  分享弹出层
//  SharePopup.m
//  ZTRong
//
//  Created by fcl on 15/6/9.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "SharePopup.h"
#import "QRDetailViewController.h"

@implementation SharePopup

- (void)maskWillAppear {
    // do noting in base
    [super maskWillAppear];
   // float y=kAppHeight -250;
    // waitingCenterView.frame=CGRectMake((kApplicationFrameWidth-286)/2, y/2, 286, 335);
    
    UIButton *cancel =[[UIButton alloc] initWithFrame:CGRectMake(0, 0,kAppWidth, kAppHeight-260)];
    
    
    [cancel handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self doDismiss];
        
    }];
    
    
    [self.bgView addSubview:cancel];
    
    UIView  *waitingCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, kAppHeight-260, kAppWidth, 260)];
    waitingCenterView.backgroundColor = [UIColor clearColor];
    //waitingCenterView.layer.cornerRadius = 10;
    [self.bgView addSubview:waitingCenterView];
    
    
    
    
    //self.bgView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    
    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 260)];
    bg.backgroundColor=[UIColor whiteColor];
    //bg.image=[UIImage imageNamed:@"xuanyao_bg"];
    [waitingCenterView addSubview:bg];
    
    
    UILabel *tilte=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kAppWidth, 20)];
    tilte.text=@"分享好友";
    tilte.font=[UIFont systemFontOfSize:14];
    tilte.textColor = [UIColor colorWithRed:251/255 green:251/255 blue:251/255 alpha:1];
    tilte.backgroundColor=[UIColor clearColor];
    tilte.textAlignment=NSTextAlignmentCenter;
    
    [waitingCenterView addSubview:tilte];
    
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(0, 39, kAppWidth, 1)];
    line1.backgroundColor=[UIColor lightGrayColor];
    [waitingCenterView addSubview:line1];
    
    
    
    UIView *shareButtonView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, kAppWidth, 170)];
    
    [self addShareButton:shareButtonView];
    
    [waitingCenterView addSubview:shareButtonView];
    
    
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(0, 219, kAppWidth, 0.5)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [waitingCenterView addSubview:line2];
    
    UIButton *cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 220, kAppWidth, 40)];
   // [cancelBtn setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取  消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    [waitingCenterView addSubview:cancelBtn];
    
}



-(void)addShareButton :(UIView *)shareButtonView{
    
    
    
//    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 50, 50)];
//    button1.tag=1001;
//    [button1 setImage:[UIImage imageNamed:@"share_icon10"] forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, 65, 70, 20)];
//    label1.font = [UIFont fontWithName:nil size:12];
//    label1.textAlignment = NSTextAlignmentCenter;
//    label1.text = @"新浪微博";
//    
//    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonView.frame.size.width/2-25, 10, 50, 50)];
//    button2.tag=1002;
//    [button2 setImage:[UIImage imageNamed:@"share_icon11"] forState:UIControlStateNormal];
//    [button2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x-10, 65, 70, 20)];
//    label2.font = [UIFont fontWithName:nil size:12];
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.text = @"微信好友";
//    
//    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonView.frame.size.width-80, 10, 50, 50)];
//    button3.tag=1003;
//    [button3 setImage:[UIImage imageNamed:@"share_icon12"] forState:UIControlStateNormal];
//    [button3 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(button3.frame.origin.x-10, 65, 70, 20)];
//    label3.font = [UIFont fontWithName:nil size:12];
//    label3.textAlignment = NSTextAlignmentCenter;
//    label3.text = @"微信朋友圈";
//    
//    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(30, 95, 50, 50)];
//    button4.tag=1004;
//    [button4 setImage:[UIImage imageNamed:@"share_icon13"] forState:UIControlStateNormal];
//    [button4 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(button4.frame.origin.x-10, 150, 70, 20)];
//    label4.font = [UIFont fontWithName:nil size:12];
//    label4.textAlignment = NSTextAlignmentCenter;
//    label4.text = @"QQ空间";
//    
//    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonView.frame.size.width/2-25, 95, 50, 50)];
//    button5.tag=1005;
//    [button5 setImage:[UIImage imageNamed:@"share_icon14"] forState:UIControlStateNormal];
//    [button5 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(button5.frame.origin.x-10, 150, 70, 20)];
//    label5.font = [UIFont fontWithName:nil size:12];
//    label5.textAlignment = NSTextAlignmentCenter;
//    label5.text = @"QQ好友";
    
  //  UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonView.frame.size.width-80, 95, 50, 50)];
      UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(shareButtonView.bounds.size.width/2-40, 35, 80, 80)];
    [button6 setImage:[UIImage imageNamed:@"share_icon15"] forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(shareErweima) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(button6.frame.origin.x, 115, 80, 20)];
    label6.font = [UIFont fontWithName:nil size:14];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.text = @"二维码";
    
    
    
    
//    [shareButtonView addSubview:button1];
//    [shareButtonView addSubview:label1];
//    [shareButtonView addSubview:button2];
//    [shareButtonView addSubview:label2];
//    [shareButtonView addSubview:button3];
//    [shareButtonView addSubview:label3];
//    [shareButtonView addSubview:button4];
//    [shareButtonView addSubview:label4];
//    [shareButtonView addSubview:button5];
//    [shareButtonView addSubview:label5];
    [shareButtonView addSubview:button6];
    [shareButtonView addSubview:label6];

    
}



//分享事件
-(void)shareAction :(id)sender{
    UIButton *button=(UIButton *)sender;
    
    ShareUitl_ShareType  shareType;
    if(button.tag==1001){
        shareType=ShareUitl_Sina;
    }else if (button.tag==1002){
        shareType = ShareUitl_WX;
    }else if (button.tag==1003){
        shareType = ShareUitl_WXQ;
        
    }else if (button.tag==1004){
        shareType = ShareUitl_QQzq;
    }else if (button.tag==1005){
        shareType = ShareUitl_QQ;
        
        
    }else{
        return;
    }
    
    
    if(self.shareImage){
    
        [[ShareUitl ShareInstrance] doShare:[Tool getShareDate:[NSString stringWithFormat:@"%@",
                                                            self.sharecontent]]   image:self.shareImage url: self.shareURL
                              ShareType:shareType finishBlock:
           ^{

                NSLog(@"分享成功");
                [Tool showerrorLabelView:@"分享成功" rootView:gRootVC.view superController:nil];
                [self doDismiss];
            } faildBlock:^(NSError *error){
//                if(shareType == ShareUitl_WX || shareType == ShareUitl_WXQ){
//                    if (error.code == -22003){
//                        [Tool showerrorLabelView:[error domain] rootView:gRootVC.view superController:nil];
//                    }
//                }else{
                    [Tool showerrorLabelView:[error domain] rootView:gRootVC.view superController:nil];
               // }
                
                NSLog(@"%@",[error domain]);
        }];
    }else if(self.shareImageURL){
        
        [[ShareUitl ShareInstrance] doShare:[Tool getShareDate:[NSString stringWithFormat:@"%@",
                                             self.sharecontent]] URLimage:self.shareImageURL url:self.shareURL ShareType:shareType finishBlock:
         ^{
                NSLog(@"分享成功");
                [Tool showerrorLabelView:@"分享成功" rootView:gRootVC.view superController:nil];
                [self doDismiss];
        
        } faildBlock:^(NSError *error){
                NSLog(@"%@",[error domain]);
//                if(shareType == ShareUitl_WX || shareType == ShareUitl_WXQ){
//                    if (error.code == -22003){
//                        [Tool showerrorLabelView:[error domain] rootView:gRootVC.view superController:nil];
//                    }
//                }else{
                    [Tool showerrorLabelView:[error domain] rootView:gRootVC.view superController:nil];
               // }
            
            
        }];
        
        
    }
    
    
    
    
}

//分享二维码
- (void)shareErweima{
//    if(self.ErweimaBlock){
//        self.ErweimaBlock();
        [self doDismiss];
//    }
    
    NSDictionary *param;
    if([UserTool userIsLogin])
    {
        param = @{@"userId":[UserTool getUserID],@"device":@"IOS"};
    }
    else
    {
        param = @{@"device":@"IOS"};
    }
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/invitationCode.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        if([dict[@"success"] intValue] == 1)
        {
            QRDetailViewController *QRView = [[QRDetailViewController alloc] init];
            QRView.type = kpresent;
            UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:QRView];
            
            nc.navigationBar.barStyle = UIStatusBarStyleDefault;
            [nc.navigationBar setTintColor:[UIColor whiteColor]];
            QRView.title = @"二维码分享";
            QRView.QRURL = dict[@"map"][@"invitation"];
            [_rootViewController presentViewController:nc animated:YES completion:nil];

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 1000;
            [alert show];
        }
        
        
    } failure:^(NSError *NSError) {
        
        NSString *message= [Tool getErrorMsssage:NSError];
        
        NSLog(@"%@",message);
        
    }];

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

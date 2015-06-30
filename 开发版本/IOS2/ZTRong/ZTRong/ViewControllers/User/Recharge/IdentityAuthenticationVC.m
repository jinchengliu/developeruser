//  身份认证
//  IdentityAuthenticationVC.m
//  ZTRong
//
//  Created by fcl on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "IdentityAuthenticationVC.h"
#import "RechargeRecordsVC.h"
#import "BankCardAuthenticationVC.h"

@interface IdentityAuthenticationVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;    //姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *numberText;  //身份证输入框
@property (weak, nonatomic) IBOutlet UIButton *nextBT;         //下一步按钮
@property(strong,nonatomic)  UIView *inShenhezhongView; //审核中
@property(strong,nonatomic)  UIView *inWeiTongGuoView;  //未通过

@end

@implementation IdentityAuthenticationVC




//显示认证失败界面
-(void)showWeiTongGuo{
    
    self.inWeiTongGuoView=[[UIView alloc] initWithFrame:CGRectMake(0, 140, kAppWidth, kAppHeight-140)];
    self.inWeiTongGuoView.backgroundColor=[UIColor whiteColor];
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake((kAppWidth-30)/2, 20, 28, 28)];
    icon.image=[UIImage imageNamed:@"recharge_icon20"];
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, kAppWidth-40, 17)];
    lable.text=@"对不起,您的身份认证审核未通过";
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:13];
    lable.backgroundColor=[UIColor clearColor];
    lable.textColor=CUSTOMCOLOR(108,108,108);
    
    UILabel *lable1=[[UILabel alloc] initWithFrame:CGRectMake(20, 85, (kAppWidth-30)/2, 17)];
    lable1.text=@"如需帮助,请联系客服";
    lable1.textAlignment=NSTextAlignmentRight;
    lable1.font=[UIFont systemFontOfSize:15];
    lable1.backgroundColor=[UIColor clearColor];
    lable1.textColor=CUSTOMCOLOR(108,108,108);
    
    
    
    UILabel *lable2=[[UILabel alloc] initWithFrame:CGRectMake(kAppWidth/2+5, 83, (kAppWidth-30)/2, 20)];
    lable2.text=@"400-922-1111";
    lable2.textAlignment=NSTextAlignmentLeft;
    lable2.font=[UIFont systemFontOfSize:18];
    lable2.backgroundColor=[UIColor clearColor];
    lable2.textColor=ButtonBG;
    lable2.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    longPress.minimumPressDuration = 1;
    longPress.numberOfTouchesRequired = 1;
    [lable2 addGestureRecognizer:longPress];

    
    
    
    [self.inWeiTongGuoView addSubview:icon];
    [self.inWeiTongGuoView addSubview:lable];
    [self.inWeiTongGuoView addSubview:lable1];
    [self.inWeiTongGuoView addSubview:lable2];
    
    [self.view addSubview:self.inWeiTongGuoView];
    
}



//显示审核中页面
-(void)showinShenhezhong{
    
    self.inShenhezhongView=[[UIView alloc] initWithFrame:CGRectMake(0, 140, kAppWidth, kAppHeight-140)];
    self.inShenhezhongView.backgroundColor=[UIColor whiteColor];
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake((kAppWidth-30)/2, 20, 28, 28)];
    icon.image=[UIImage imageNamed:@"recharge_icon19"];
    
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, kAppWidth-40, 15)];
    lable.text=@"您的身份认证已提交成功正在审核中…";
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:13];
    lable.backgroundColor=[UIColor clearColor];
    lable.textColor=CUSTOMCOLOR(108,108,108);
    
    
    
    UILabel *lable1=[[UILabel alloc] initWithFrame:CGRectMake(20, 85, (kAppWidth-30)/2, 17)];
    lable1.text=@"如需帮助,请联系客服";
    lable1.textAlignment=NSTextAlignmentRight;
    lable1.font=[UIFont systemFontOfSize:13];
    lable1.backgroundColor=[UIColor clearColor];
    lable1.textColor=CUSTOMCOLOR(108,108,108);
    
    
    
    UILabel *lable2=[[UILabel alloc] initWithFrame:CGRectMake(kAppWidth/2+5, 83, (kAppWidth-30)/2, 20)];
    lable2.text=@"400-922-1111";
    lable2.textAlignment=NSTextAlignmentLeft;
    lable2.font=[UIFont systemFontOfSize:15];
    lable2.backgroundColor=[UIColor clearColor];
    lable2.textColor=ButtonBG;
    
    lable2.userInteractionEnabled=YES;
     UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    longPress.minimumPressDuration = 1;
    longPress.numberOfTouchesRequired = 1;
    [lable2 addGestureRecognizer:longPress];
    
    [self.inShenhezhongView addSubview:icon];
    [self.inShenhezhongView addSubview:lable];
    [self.inShenhezhongView addSubview:lable1];
    [self.inShenhezhongView addSubview:lable2];
    
    [self.view addSubview:self.inShenhezhongView];
    
}


//长按拨打电话
-(void)callPhone:(UILongPressGestureRecognizer *)gesture  {
    if(gesture.state ==UIGestureRecognizerStateEnded ){
       // NSLog(@"111");
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://4009221111"]]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"拨打客服电话400-922-1111" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert handleWithBlock:^(NSInteger index){
                if(index==1){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4009221111"]];
                }
                
                
            }];
            
            [alert show];
            
        }
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值前准备";
    
    [self.nextBT setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    
    [self.nextBT addTarget:self action:@selector(bindingRealname) forControlEvents:UIControlEventTouchUpInside];
    self.nextBT.layer.cornerRadius = 5;
    self.nextBT.layer.masksToBounds = YES;
    
    if([self.identityAuditstatusE isEqualToString:@"notAudit"]){
        [self showinShenhezhong]; //审核中
        
    }else if([self.identityAuditstatusE isEqualToString:@"notPassed"]){
        [self showWeiTongGuo]; //审核未通过
        
    }

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//跳转到银行卡认证
-(void)pushToBankCard{
    BankCardAuthenticationVC *bavc=[[BankCardAuthenticationVC alloc] initWithNibName:@"BankCardAuthenticationVC" bundle:nil];
    
    [self.navigationController pushViewController:bavc animated:YES];
   
}

//绑定实名认证
-(void)bindingRealname{
    [self.view endEditing:YES];
    if(self.nameText.text.length==0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入真实姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else if(self.numberText.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入真实身份证号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    [map setObject:self.nameText.text forKey:@"realName"];
    [map setObject:self.numberText.text forKey:@"papersNum"];
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    
 //审核状态
//    NOCERTIFICATION(10000,"noCertification","未认证"),
//    NOTAUDIT(10001,"notAudit","待审核"),
//    PASSED(10002,"passed","已认证"),
//    NOTPASSED(10003,"notPassed","不通过"),
//    BAN(10004,"ban","禁止");
    
    self.nextBT.enabled=NO;
     [self.view endEditing:YES];
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmdidentityAuth] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
       // self.nextBT.enabled=YES;
        [self.HUD hide:YES];
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            
//            NSString *identityAuditstatusE=[dict objectForKey:@"identityAuditstatusE"];
//            if([identityAuditstatusE isEqualToString:@"passed"]){
//                [self pushToBankCard];
//                return ;
//            }else if([identityAuditstatusE isEqualToString:@"notAudit"]){ //待审核中
//                [self showinShenhezhong];
//                
//            }else if([identityAuditstatusE isEqualToString:@"notPassed"]){ //不通过
//                [self showWeiTongGuo];
//                
//            }else if([identityAuditstatusE isEqualToString:@"noCertification"]){ //未认证
//                self.nextBT.enabled=YES;
//            }
            [self getquerySafety];
            
            NSString *message=dict[@"msg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
            
            
        }else{
            self.nextBT.enabled=YES;

            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }

    
    
    } failure:^(NSError *error){
        self.nextBT.enabled=YES;
       
        
        
        NSString *message= [Tool getErrorMsssage:error];
        NSLog(@"%@",message);
        [self hideHUD:message];
    
    
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//绑定成功后 获取认证状态
-(void)getquerySafety{
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    NSMutableDictionary *params =[Tool getHttpParams:map];
    
    
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/querySafety.htm"]  parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
        self.HUD.hidden=YES;
        NSLog(@"%@",dict.description);
        NSString *identityAuditstatusE=[[dict objectForKey:@"map"] objectForKey:@"identityAuditstatusE"];
        
        if([identityAuditstatusE isEqualToString:@"passed"]){
            [self pushToBankCard];
            return ;
        }else if([identityAuditstatusE isEqualToString:@"notAudit"]){ //待审核中
            [self showinShenhezhong];
            
        }else if([identityAuditstatusE isEqualToString:@"notPassed"]){ //不通过
            [self showWeiTongGuo];
            
        }else if([identityAuditstatusE isEqualToString:@"noCertification"]){ //未认证
            self.nextBT.enabled=YES;
        }

        
        
        
        
    }  failure:^(NSError *error){
        
        NSString *message= [Tool getErrorMsssage:error];
        [self hideHUD:message];
       
    }];
    
    
}



@end

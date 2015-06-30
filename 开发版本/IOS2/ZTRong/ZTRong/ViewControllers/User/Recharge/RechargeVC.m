//  充值
//  RechargeVC.m
//  ZTRong
//
//  Created by fcl on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "RechargeVC.h"
#import "RechargeRecordsVC.h"
#import "BankCardAuthenticationVC.h"


@interface RechargeVC (){
    NSTimer *countDownTimer;
}

@property (weak, nonatomic) IBOutlet UIButton *choseBankCardBT; //选择银行卡按钮
@property (strong, nonatomic)  UILabel *choseBankCardLB; //选择银行卡按钮
@property (weak, nonatomic) IBOutlet UIButton *addBankCardBT;   //添加银行卡按钮
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;          //预留电话lable
@property (weak, nonatomic) IBOutlet UILabel *eMsgLB;           //验证码错误提示lable
@property (weak, nonatomic) IBOutlet UITextField *yzmText;      //验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *yzmBT;           //获取验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *numberText;   //金额输入框
@property (weak, nonatomic) IBOutlet UIButton *nextBT;          //充值按钮

@property(nonatomic,strong)UIPopoverListView *popoList;        //弹出银行卡


@end

@implementation RechargeVC

//直接返回根视图
-(void)backAction{
    if(self.type==kpresent){
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    //从银行卡认证进入返回root      其他返回上一个界面
    if(self.rechargeVCFromType==RechargeFromNewVC){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//显示银行卡列表
-(void)showPopoList{
    [self.popoList.listView reloadData];
    [self.popoList show];
}


//验证码定时器事件
-(void)CountDown:(NSTimer *)timer
{
    secondsCountDown--;
    [self.yzmBT setTitle:[NSString stringWithFormat:@"%zi",secondsCountDown] forState:UIControlStateNormal];
    if (secondsCountDown==0) {
        
        if(countDownTimer !=nil){
            [countDownTimer invalidate];
            countDownTimer=nil;
        }
        [self.yzmBT setTitle:@"点击获取" forState:UIControlStateNormal];
        self.yzmBT.enabled=YES;
        secondsCountDown=60;
    }
    
}


//获取验证码
-(void)getYZMAction{
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    [map setObject:self.backCard forKey:@"cardNo"];
    [map setObject:self.phone forKey:@"reserveMobile"];
    
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl, kCmdbankSendSMS]  parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
        [self.HUD hide: YES];
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            self.batchNo =[[dict objectForKey:@"map"] objectForKey:@"batchNo"];
            self.yzmBT.enabled=NO;
            NSString *message=dict[@"msg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            countDownTimer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDown:) userInfo:nil repeats:YES];
            
        }else{
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }
        

        
    
    } failure:^(NSError *error){
        
        NSString *message= [Tool getErrorMsssage:error];
        NSLog(@"%@",message);
        [self hideHUD:message];
    
    
    }];
    
    
}


//获取银行卡列表
-(void)getBankList{
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    [self showHUD];
    self.choseBankCardBT.enabled=NO;
    
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmdUserBankList] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
    
        [self.HUD hide:YES];
        self.choseBankCardBT.enabled=YES;
        
        if([dict[@"success"] intValue] == 1){
            NSArray *arr=[[dict objectForKey:@"map"] objectForKey:@"bankList"];
            self.bankList=[NSMutableArray arrayWithArray:arr];
            if(self.bankList.count==0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有绑定银行卡 请先绑定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else{
                // [self showPopoList];
                [self showPick];
            }
        }else{
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }

    
    
    
    
    } failure:^(NSError *error){
    
       
        self.choseBankCardBT.enabled=YES;
        NSString *message= [Tool getErrorMsssage:error];
        NSLog(@"%@",message);
        [self hideHUD:message];

    
    
    }];
    
}

//跳转到银行卡认证
-(void)pushToBankCardAuthentication{
    if(self.addBankCardBT.selected){
        return;
    }
    BankCardAuthenticationVC *bavc=[[BankCardAuthenticationVC alloc] initWithNibName:@"BankCardAuthenticationVC" bundle:nil];
    bavc.bankCardFromType=BankCardAdd;
    [self.navigationController pushViewController:bavc animated:YES];
    
}
//跳转到充值记录
-(void)pushToRechargeRecords{
    
    RechargeRecordsVC *rrVC=[[RechargeRecordsVC alloc] init];
    [self.navigationController pushViewController:rrVC animated:YES];
}


//选择佣金分成按钮事件
-(void)showPick{
     [self.view endEditing:YES];
    SheetPicker *sp=[[SheetPicker alloc]init];
    NSMutableArray *arr=[[NSMutableArray alloc] init];
   // NSArray *array1=[NSArray arrayWithObjects:@"20",@"40",@"60",@"80",@"100", nil];
    
    for(int i=0;i<self.bankList.count;i++){
        [arr addObject:[[self.bankList objectAtIndex:i]  objectForKey:@"bankNoEncry"] ];
    }
    
    sp.listData=arr;
    sp.title=@"请选择银行卡";
    sp.doneBlock=^(NSInteger row){
        self.selectIndex=row;
        [self bankCardVerification];
        
    };
    sp.clearBlock=^(NSInteger row){
        // NSLog(@"clear %d",row);
        
    };
    sp.viewController=self;
    [sp showSheetPicker];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值";
    secondsCountDown=60;
    
    //self.yzmBT.enabled=NO;
    self.bankList=[[NSMutableArray alloc] init];
    self.selectIndex=0;
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStyleBordered target:self action:@selector(pushToRechargeRecords)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    
    
    [self.addBankCardBT addTarget:self action:@selector(pushToBankCardAuthentication) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.popoList=[[UIPopoverListView alloc] initWithFrame:CGRectMake(20, 80, kAppWidth-40, 160)];
    [self.popoList.listView setSeparatorColor:[UIColor clearColor]];
    self.popoList.delegate=self;
    self.popoList.datasource=self;
    
    [self.choseBankCardBT addTarget:self action:@selector(getBankList) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.choseBankCardBT.layer.cornerRadius = 5;
    self.choseBankCardBT.layer.masksToBounds = YES;
    self.choseBankCardBT.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.choseBankCardBT.layer.borderWidth=0.5;
    
    [self.yzmBT  setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [self.yzmBT setEnabled:NO];
    self.yzmBT.layer.cornerRadius = 5;
    self.yzmBT.layer.masksToBounds = YES;
    self.nextBT.layer.cornerRadius = 5;
    self.nextBT.layer.masksToBounds = YES;
    

    [self.yzmBT addTarget:self action:@selector(getYZMAction) forControlEvents:UIControlEventTouchUpInside];
    self.yzmText.keyboardType = UIKeyboardTypeNumberPad;
    self.numberText.keyboardType = UIKeyboardTypeDecimalPad;
    
    
    [self.nextBT setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [self.nextBT addTarget:self action:@selector(doRechargeAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextBT.enabled=NO;
    
    
    [self setTextstyle];
   
}

//设置输入框样式
-(void)setTextstyle{
    UIImageView *telIcon = [[UIImageView alloc] init];
    telIcon.image = [UIImage imageNamed:@"image2"];
    telIcon.bounds=CGRectMake(5, 2, 40, 20);
    telIcon.contentMode = UIViewContentModeCenter;
    self.yzmText.leftView = telIcon;
    self.yzmText.leftViewMode = UITextFieldViewModeAlways;
    self.yzmText.layer.cornerRadius = 5;
    self.yzmText.layer.masksToBounds = YES;
    self.yzmText.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.yzmText.layer.borderWidth=0.5;
    
    
    
    UIImageView *telIcon1 = [[UIImageView alloc] init];
    telIcon1.image = [UIImage imageNamed:@"icon_$"];
    telIcon1.bounds=CGRectMake(5, 2, 40, 20);
    telIcon1.contentMode = UIViewContentModeCenter;
    self.numberText.leftView = telIcon1;
    self.numberText.leftViewMode = UITextFieldViewModeAlways;
    self.numberText.layer.cornerRadius = 5;
    self.numberText.layer.masksToBounds = YES;
    self.numberText.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.numberText.layer.borderWidth=0.5;
    self.numberText.delegate=self;
    
    
    UIImageView *telIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 25, 25)] ;
    telIcon2.image = [UIImage imageNamed:@"icon_backCard"];
//    telIcon2.bounds=CGRectMake(5, 2, 40, 20);
   // telIcon2.contentMode = UIViewContentModeCenter;
    
    [self.choseBankCardBT addSubview:telIcon2];
    
    float f1=215;
    if(kAppWidth==320){
        f1=215;
    }else if(kAppWidth==375){
        f1=222*APPDELEGATE.autoSizeScaleX;
    }else if(kAppWidth==414){
        f1=222*APPDELEGATE.autoSizeScaleX;
        
    }
    
    UIImageView *telIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(f1,10, 20, 20)];
    telIcon3.image = [UIImage imageNamed:@"icon_arrow"];
   // telIcon3.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
   // telIcon3.bounds=CGRectMake(self.choseBankCardBT.frame.size.width-25,5, 20, 20);
   // telIcon3.contentMode = UIViewContentModeCenter;
     [self.choseBankCardBT addSubview:telIcon3];
    
    
    self.choseBankCardLB=[Tool createLable:[UIColor lightGrayColor] font:14 frame:CGRectMake(41, 10, self.choseBankCardBT.frame.size.width-75, 20)];
    self.choseBankCardLB.text=@"请选择银行卡";
    [self.choseBankCardBT addSubview:self.choseBankCardLB];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resetType];
}

//重置界面
-(void) resetType{
    self.yzmText.text=@"";
    self.numberText.text=@"";
    self.choseBankCardLB.text=@"请选择银行卡";
    self.phoneLB.text=@"预留手机号码";
    self.yzmBT.enabled=NO;
    self.nextBT.enabled=NO;
    self.selectIndex=0;
    self.backCard=@"";
    self.phone=@"";
    
}


//充值事件
-(void)doRechargeAction{
    if(self.yzmText.text==nil ||self.yzmText.text.length==0){
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
//    }else if([self.yzmText.text isEqualToString:self.batchNo]==NO){
//         return;
    }else if(self.batchNo==nil || self.batchNo.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先获取验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else if(self.numberText.text== nil ||self.numberText.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入充值金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
         return;
//    }else if([self.numberText.text integerValue]<100){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"充值金额必须大于100" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//         return;
   
    }

    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    
    if(userid ==nil){
        userid=@"";
    }
    if(username ==nil){
        username=@"";
    }
    
    [map setObject:self.backCard forKey:@"cardNo"];
    [map setObject:self.batchNo forKey:@"batchNo"];
    [map setObject:self.numberText.text forKey:@"payAmount"];
    [map setObject:self.phone forKey:@"reserveMobile"];
    [map setObject:self.yzmText.text forKey:@"smsCode"];
    [map setObject:userid forKey:@"userId"];
    [map setObject:username forKey:@"userName"];
        
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    self.nextBT.enabled=NO;
    [self.view endEditing:YES];
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl, KCmdrecharge] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
        self.nextBT.enabled=YES;
        [self.HUD hide: YES];
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            self.batchNo =@"";
            secondsCountDown=2;
            //[[dict objectForKey:@"map"] objectForKey:@"batchNo"];
            NSString *message=dict[@"msg"];
            
            [self pushToRechargeRecords];   //先跳转到记录
            if(message==nil || message.length==0){
                message=@"完成充值";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
            
        }else{
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


#pragma mark - popoverListViewDelegate
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] ;
    
    //NSInteger row = indexPath.row;
    cell.textLabel.text = [[self.bankList objectAtIndex:indexPath.row] objectForKey:@"bankNoEncry"];
    cell.textLabel.textColor=[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1];
    cell.textLabel.highlightedTextColor=[UIColor colorWithRed:186/255.0 green:152/255.0 blue:100/255.0 alpha:1];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(20, 39, cell.frame.size.width-40, 1)];
    line.backgroundColor=[UIColor colorWithRed:198/255.0 green:173/255.0 blue:136/255.0 alpha:1];
    [cell addSubview:line];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    
    return self.bankList.count;
}



//验证银行卡
-(void) bankCardVerification{
    
    //    bankCardNo	String	银行卡号
    //    realName	String	真实姓名
    //    bankName	String	银行名称
    //    bankNoEncry	String	银行卡格式化
    //    bankSubName	String 	支行名称
    //mobile   手机
    
   // [self.choseBankCardBT setTitle: [[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"bankNoEncry"] forState:UIControlStateNormal];
    self.choseBankCardLB.text=[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"bankNoEncry"];
    self.phoneLB.text=[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"mobile"];
    self.yzmBT.enabled=NO;
    self.nextBT.enabled=NO;
    self.yzmText.text=@"";
    self.numberText.text=@"";
   // self.selectIndex=indexPath.row;
    self.backCard=[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"bankCardNo"];
    self.phone=[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"mobile"];
    // your code here
    
    // 选完卡号 需要验证银行卡   kCmdqueryBankVerify
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    [map setObject:self.backCard forKey:@"cardNo"];
    [map setObject:self.phone forKey:@"reserveMobile"];
    
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    NSLog(@"%@",params);
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl, kCmdqueryBankVerify] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
        
        [self.HUD hide:YES];
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            self.yzmBT.enabled=YES;
            self.nextBT.enabled=YES;
            if(countDownTimer !=nil){
                [countDownTimer invalidate];
                countDownTimer=nil;
            }
            self.batchNo=@"";
            [self.yzmBT setTitle:@"点击获取" forState:UIControlStateNormal];
            self.yzmBT.enabled=YES;
            secondsCountDown=60;
            
        }else{
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }


    
    } failure:^(NSError *error){
        
       
        NSString *message= [Tool getErrorMsssage:error];
        NSLog(@"%@",message);
        
        [self hideHUD:message];

    
    
    }];
    
}


#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex=indexPath.row;
    [self bankCardVerification];
   
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}



- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (textField == self.numberText) {
        if([string isEqualToString:@""]){
            return YES;
        }
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers;
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }else{
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
        {
            return NO;
        }
        
        short remain = 2; //默认保留2位小数
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string;
                return NO;
            }else{
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                    
                }
                
            }
            
        }
        
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
            
        {
            return NO;
        }
        
        
    }
    
    
    
    return YES;
    
}



@end

//  提现
//  WithdrawalsVC.m
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "WithdrawalsVC.h"
#import "WithdrawalsrecordVC.h"
#import "BankCardAuthenticationVC.h"
#import "WithdrawalsFinishPoPup.h"
#import "PayPasswordViewController.h"
#import "PhoneViewController.h"

@interface WithdrawalsVC (){
     NSTimer *countDownTimer;
}

@property (weak, nonatomic) IBOutlet UIButton *choseBankCardBT; //选择银行卡按钮
@property(strong,nonatomic)UILabel *choseBankCardLB;            //选择银行卡lb
@property (weak, nonatomic) IBOutlet UIButton *addBankCardBT;   //添加银行卡按钮
@property (weak, nonatomic) IBOutlet UILabel *yuerLB;          //账户余额lable
@property (weak, nonatomic) IBOutlet UILabel *yuereMsgLB;       //账户余额提示lable
@property (weak, nonatomic) IBOutlet UILabel *cashMsgLB;        //金额错误提示lable
@property (weak, nonatomic) IBOutlet UILabel *feeLB;           //手续费lable
@property (weak, nonatomic) IBOutlet UILabel *withdrawalLB;    //费率
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;          //手机号lable
@property (weak, nonatomic) IBOutlet UILabel *eMsgLB;           //验证码错误提示lable
@property (weak, nonatomic) IBOutlet UITextField *yzmText;      //验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *yzmBT;           //获取验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *numberText;   //金额输入框
@property (weak, nonatomic) IBOutlet UIButton *nextBT;          //提现按钮
@property (weak, nonatomic) IBOutlet UIView *payBTView;         //支付密码按钮层
@property (weak, nonatomic) IBOutlet UIView *payMMView;         //支付密码密码层
@property (weak, nonatomic) IBOutlet UIButton *payBT;          //支付密码设置按钮

@property (weak, nonatomic) IBOutlet UIView *phoneMMView;         //手机认证层
@property (weak, nonatomic) IBOutlet UIButton *phoneBT;          //手机认证按钮
@property (weak, nonatomic) IBOutlet UITextField *payText;     //支付密码输入框



@property(nonatomic,strong)UIPopoverListView *popoList;        //弹出银行卡

@end

@implementation WithdrawalsVC



//提现成功
-(void)WithdrawalsFinish{
    WithdrawalsFinishPoPup *wfPopup=[[WithdrawalsFinishPoPup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    
    [wfPopup showInView:APPDELEGATE.window MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
            [self pushToWithdrawalsRecords];  //提现完成跳转到提现记录
        
    }];
    
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
    //    请求Url：
   //[URL]/findSendMessage.htm?message={"channel":"APP","params":{"mobile":"","modelID":"","userId":"","voice":"0"},"sign":"","version":"1.0"}
    //    param格式
    
    
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
   // [map setObject:self.backCard forKey:@"cardNo"];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    [map setObject:self.phone forKey:@"mobile"];
    [map setObject:@"10007" forKey:@"modelID"];
    [map setObject:@"0" forKey:@"voice"];
    
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    //[self.HUD show:YES];
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl, KCmdfindSendMessage] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
        [self.HUD hide:YES];
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            // self.batchNo =[[dict objectForKey:@"map"] objectForKey:@"batchNo"];
            self.yzmBT.enabled=NO;
            NSString *message=dict[@"msg"];
            if(message==nil || message.length==0){
                message=@"验证码已经下发到您手机";
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



//选择佣金分成按钮事件
-(void)showPick{
    [self.view endEditing:YES];
    SheetPicker *sp=[[SheetPicker alloc]init];
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    // NSArray *array1=[NSArray arrayWithObjects:@"20",@"40",@"60",@"80",@"100", nil];
    
    for(int i=0;i<self.bankList.count;i++){
        [arr addObject:[[self.bankList objectAtIndex:i]  objectForKey:@"bankCardNo"] ];
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



//选择银行卡列表
-(void)showPopoList{
    if(self.choseBankCardBT.selected){
        return;
    }
    
    if(self.bankList.count==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有绑定银行卡 请先绑定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
//        [self.popoList.listView reloadData];
//        [self.popoList show];
          [self  showPick];
    }

    
    
}

//跳转到银行卡认证
-(void)pushToBankCardAuthentication{
    BankCardAuthenticationVC *bavc=[[BankCardAuthenticationVC alloc] initWithNibName:@"BankCardAuthenticationVC" bundle:nil];
    bavc.bankCardFromType=BankCardAdd;
    [self.navigationController pushViewController:bavc animated:YES];
    
}

//跳转到提现记录
-(void)pushToWithdrawalsRecords{
    WithdrawalsrecordVC *rvc= [[WithdrawalsrecordVC alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}


-(void)initTV{
    float h=0;
    if(self.navigationController.tabBarController!=nil  &&  self.navigationController.tabBarController.tabBar.hidden==NO){
        h=kAppTabBarHeight;
    }else{
        h=0;
    }
    self.tv =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppWidth, kAppHeight-64)];
    [self.tv setSeparatorColor:[UIColor clearColor]];
    self.tv.dataSource=self;
    self.tv.delegate=self;
    self.tv.backgroundColor=[UIColor whiteColor];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 10)];
    header.backgroundColor=[UIColor whiteColor];
    [self.tv setTableHeaderView:header];
    
    [self.tv scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.view addSubview:self.tv];
    
    if(kAppHeight==480 || DEVICE_IS_IPHONE5){
         self.tv.scrollEnabled=YES;
    }else{
         self.tv.scrollEnabled=NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现";
     [self initTV];
    self.yzmBT.enabled=NO;
    secondsCountDown=60;
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"记录" style:UIBarButtonItemStyleBordered target:self action:@selector(pushToWithdrawalsRecords)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
    
    
    
    
    [self.addBankCardBT addTarget:self action:@selector(pushToBankCardAuthentication) forControlEvents:UIControlEventTouchUpInside];
    self.yzmText.keyboardType = UIKeyboardTypeNumberPad;
    self.numberText.keyboardType = UIKeyboardTypeDecimalPad;
    self.numberText.tag=101;
    self.numberText.delegate=self;
    self.payText.delegate=self;
    self.payText.tag=102;
    self.yzmText.delegate=self;
    self.yzmText.tag=103;
    self.payText.secureTextEntry = YES;
    
    self.popoList=[[UIPopoverListView alloc] initWithFrame:CGRectMake(20, 80, kAppWidth-40, 160)];
    [self.popoList.listView setSeparatorColor:[UIColor clearColor]];
    self.popoList.delegate=self;
    self.popoList.datasource=self;
    
    [self.choseBankCardBT addTarget:self action:@selector(showPopoList) forControlEvents:UIControlEventTouchUpInside];
    [self.yzmBT setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    
    [self.nextBT setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [self.nextBT addTarget:self action:@selector(doWithdrawals) forControlEvents:UIControlEventTouchUpInside];
    
    [self.payBT handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        PayPasswordViewController *payView = [[PayPasswordViewController alloc] init];
        [self.navigationController pushViewController:payView animated:YES];
    
    }];
    self.payBT.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.phoneBT.titleLabel.textAlignment=NSTextAlignmentLeft;
    
    
    [self.yzmBT handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self getYZMAction];
        
    }];
    
    self.yzmBT.layer.cornerRadius = 5;
    self.yzmBT.layer.masksToBounds = YES;
    self.nextBT.layer.cornerRadius = 5;
    self.nextBT.layer.masksToBounds = YES;

    
   [self.phoneBT handleControlEvent:UIControlEventTouchUpInside withBlock:^{
       PhoneViewController *phoneView = [[PhoneViewController alloc] init];
       [self.navigationController pushViewController:phoneView animated:YES];
    }];

    
   // self.payBTView.hidden=YES;
    
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
    
    
    
    self.choseBankCardBT.layer.cornerRadius = 5;
    self.choseBankCardBT.layer.masksToBounds = YES;
    self.choseBankCardBT.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.choseBankCardBT.layer.borderWidth=0.5;

    
    UIImageView *telIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 25, 25)] ;
    telIcon2.image = [UIImage imageNamed:@"icon_backCard"];
    //    telIcon2.bounds=CGRectMake(5, 2, 40, 20);
    // telIcon2.contentMode = UIViewContentModeCenter;
    
    [self.choseBankCardBT addSubview:telIcon2];
    
    
    UIImageView *telIcons = [[UIImageView alloc] initWithFrame:CGRectMake(280-25,10, 20, 20)];
    telIcons.image = [UIImage imageNamed:@"icon_arrow"];
    telIcons.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    // telIcon3.bounds=CGRectMake(self.choseBankCardBT.frame.size.width-25,5, 20, 20);
    // telIcon3.contentMode = UIViewContentModeCenter;
    [self.choseBankCardBT addSubview:telIcons];
    
    
    self.choseBankCardLB=[Tool createLable:[UIColor lightGrayColor] font:14 frame:CGRectMake(41, 10, 240*APPDELEGATE.autoSizeScaleX-75, 20)];
    self.choseBankCardLB.text=@"请选择银行卡";
   // self.choseBankCardLB.backgroundColor=[UIColor redColor];
    [self.choseBankCardBT addSubview:self.choseBankCardLB];
    
    
//    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(61, 20, 1, 500)];
//    line.backgroundColor=[UIColor blackColor];
//    
//    [self.view addSubview:line];
    
    
    UIImageView *telIcon4 = [[UIImageView alloc] init];
    telIcon4.image = [UIImage imageNamed:@"user_icon11"];
    telIcon4.bounds=CGRectMake(5, 2, 40, 20);
    telIcon4.contentMode = UIViewContentModeCenter;
    self.payText.leftView = telIcon4;
    self.payText.leftViewMode = UITextFieldViewModeAlways;
    self.payText.layer.cornerRadius = 5;
    self.payText.layer.masksToBounds = YES;
    
    
    
    
}



//重置界面
-(void) resetType{
    self.yzmText.text=@"";
    self.payText.text=@"";
    self.numberText.text=@"";
    self.choseBankCardLB.text=@"请选择银行卡";
    self.backCard=@"";
    self.yuereMsgLB.text=@"";
    self.feeLB.text=@"提现手续费:   ￥0";
    self.maxQuota=0;
    self.cashMsgLB.text=@"";
    //[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"id"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resetType];
    
    [self getWithdrawalsInfo];
    
    if(self.payBTView.hidden==NO){
        
        NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
        NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
        
        if(userid ==nil){
            userid=@"";
        }
        [map setObject:userid forKey:@"userId"];
        NSMutableDictionary *params =[Tool getHttpParams:map];
        
        //  [dict[@"map"][@"payPwd"] intValue  是否设置过支付密码;
        
        [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/querySafety.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
            
            NSLog(@"%@",dict.description);
            
            if([dict[@"success"] intValue] == 1){
                if([dict[@"map"][@"payPwd"] intValue] == 0){
                
                }else{
                    self.payBTView.hidden=YES;
                    self.payText.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    self.payText.layer.borderWidth=0.5;
                }
            }
        
        
        } failure:^(NSError *error){
        
        
        }];
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textLabel.text =[[self.bankList objectAtIndex:indexPath.row] objectForKey:@"bankCardNo"];
    cell.textLabel.textColor=[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1];
    cell.textLabel.highlightedTextColor=[UIColor colorWithRed:186/255.0 green:152/255.0 blue:100/255.0 alpha:1];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(20, 39, cell.frame.size.width-40, 1)];
    line.backgroundColor=[UIColor colorWithRed:198/255.0 green:173/255.0 blue:136/255.0 alpha:1];
    [cell addSubview:line];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    //[UIColor colorWithRed:94/255.0 green:71/255.0 blue:34/255.0 alpha:1];

    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return self.bankList.count;
}


//验证银行卡限额
-(void)bankCardVerification{
    
    self.choseBankCardLB.text=[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"bankCardNo"];
    self.backCard=[[self.bankList objectAtIndex:self.selectIndex] objectForKey:@"id"];
    //认证手机:
    
    self.yzmText.text=@"";
    self.payText.text=@"";
    self.numberText.text=@"";
    self.yuereMsgLB.text=@"";
    self.feeLB.text=@"提现手续费:   ￥0";
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    
    [map setObject:userid forKey:@"userId"];
    // bankId	True	String	银行卡ID
    NSString *bankId =  self.backCard;
    [map setObject:bankId forKey:@"bankId"];
    NSMutableDictionary *params =[Tool getHttpParams:map];
    //3.27.	获取银行卡可提现的最大限额

    
    if(countDownTimer !=nil){
        [countDownTimer invalidate];
        countDownTimer=nil;
    }
    [self.yzmBT setTitle:@"点击获取" forState:UIControlStateNormal];
    self.yzmBT.enabled=YES;
    secondsCountDown=60;
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,KCmdqueryUseDepositAmount] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            NSString *depositAmountMaxStr=[[dict objectForKey:@"map"] objectForKey:@"depositAmountMaxStr"];
            NSString *depositAmountMax=[[dict objectForKey:@"map"] objectForKey:@"depositAmountMax"];
        
            self.maxQuota=[depositAmountMax floatValue];
        
            self.yuereMsgLB.text=[NSString stringWithFormat:@"*该卡最多可允许转出 %@ 元",depositAmountMaxStr ];
        }
    
    } failure:^(NSError *error){
    
    
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



//获取用户提现信息
-(void)getWithdrawalsInfo{
    
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    
    [map setObject:userid forKey:@"userId"];
    NSMutableDictionary *params =[Tool getHttpParams:map];
    
//    amont	Double	可用余额(元)
//    amontStr	String	可用余额(元 格式化后数据)
//    notAmount	Double	未投资账户金额（元）
//    yetAmount	Double	已投资账户金额（元）
//    withdrawals	Double	手续费率
//    tel	String	手机号
    
   
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmddeposit] parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
      [self.HUD hide: YES];
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            self.dateMap=[dict objectForKey:@"map"];
            NSArray *arr=[[dict objectForKey:@"map"] objectForKey:@"bankList"];
            self.bankList=[NSMutableArray arrayWithArray:arr];
            self.yuerLB.text=[NSString stringWithFormat:@"账户余额:   ￥  %@",[self.dateMap objectForKey:@"amountStr"]];
            self.yuer= [[self.dateMap objectForKey:@"amount"] floatValue];
            NSString *withdrawals=[self.dateMap objectForKey:@"withdrawals"];
            float withdrawal=[withdrawals floatValue] *100;
            
            self.withdrawalLB.text=[NSString stringWithFormat:@"(仅收取未投资金额%.2f %%的手续费)",withdrawal];
            
            //[self showPopoList];
            NSString *tel=[self.dateMap objectForKey:@"tel"];
            if(tel && tel.length>0){
                self.phoneLB.text=[NSString stringWithFormat:@"认证手机: %@" ,tel];
                self.phone=tel;
                self.phoneMMView.hidden=YES;
            }else{
                
            }
            
        }else{
            NSString *message=dict[@"errorMsg"];
            if(message==nil || message.length==0){
                message=errorMessage;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }

    
    } failure:^(NSError *error){
        
        [self hideHUD:[Tool getErrorMsssage:error]];
    
    }];
    
}


//提现请求
-(void)doWithdrawals {

    if(self.backCard==nil ||self.backCard.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择银行卡" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(self.numberText.text==nil ||self.numberText.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入提现金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else if ([self.numberText.text integerValue]>self.yuer){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提现金额不能大于账户余额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
        
    }else if([self.numberText.text integerValue]>self.maxQuota ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提现金额不能大于可提现最大限额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else if ([self.numberText.text integerValue]<100){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提现金额不能小于100" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
        
   
        
    }else    if(self.payText.text==nil ||self.payText.text.length==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入支付密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        return;
        
    }else    if(self.yzmText.text==nil ||self.yzmText.text.length==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        return;
    }
    
    
    
   
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    [map setObject:self.backCard forKey:@"bankId"];
    [map setObject:self.numberText.text forKey:@"amount"];
    [map setObject:self.payText.text forKey:@"payPassword"];
    [map setObject:@"10007" forKey:@"modelID"];
    [map setObject:self.yzmText.text forKey:@"verifyCode"];
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    [self.view endEditing:YES];
    self.nextBT.enabled=NO;
//    self.HUD.labelText=@"";
//    [self.HUD show:YES];
    
    [self showHUD];
    
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl, kCmddepositForm]  parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
        [self.HUD hide:YES];
        self.nextBT.enabled=YES;
        
        NSLog( @"%@", dict.description);
        if(countDownTimer !=nil){
            [countDownTimer invalidate];
            countDownTimer=nil;
        }
        [self.yzmBT setTitle:@"点击获取" forState:UIControlStateNormal];
        self.yzmBT.enabled=YES;
        secondsCountDown=60;
        
        if([dict[@"success"] intValue] == 1){
    
            [self WithdrawalsFinish];
            
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


#pragma mark - UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row==0){
        return 95;
    }else if(indexPath.row==1){
        return 55;
    }else if(indexPath.row==2){
        return 65;
    }else if(indexPath.row==3){
        return 60;
    }else if(indexPath.row==4){
        return 44;
    }else if(indexPath.row==5){
        return 60;
    }else if(indexPath.row==6){
        return 125;
    }else if(indexPath.row==7){
        return 60;
        
        
        
        
    }

    return 44;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellID];
    }
    if(indexPath.row==0){
        cell = self.bankCardCell;
    }else if(indexPath.row==1){
        cell = self.yuerCell;
    }else if(indexPath.row==2){
        cell = self.txCushCell;
    }else if(indexPath.row==3){
         cell =  self.zfeeCell;
    }else if(indexPath.row==4){
         cell = self.zfPassWordCell;
    }else if(indexPath.row==5){
         cell =  self.zphoneCell;
    }else if(indexPath.row==6){
         cell =  self.yzmCell;
    }else if(indexPath.row==7){
         cell =  self.doButtonCell;
    
    }else{
        cell=self.zphoneCell;
    }
    
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}




#pragma mark UITextFiredDelgate
//textField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField.tag!=100 ){
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.tv];
        pt = rc.origin;
        pt.x = 0;
        pt.y = pt.y- 70;
        [self.tv setContentOffset:pt animated:YES];
    }

}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text =[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(textField.tag==101){
        float i=[textField.text floatValue];
        if(i >self.yuer){
           self.cashMsgLB.text=@"您输入的金额大于账户余额,请重新输入";
            return;
        }else{
            self.cashMsgLB.text=@"";
        }
        
        //提现手续费:   ￥0.00
        float yetAmount=[[self.dateMap objectForKey:@"yetAmount"] floatValue];
       // float notAmount=[[self.dateMap objectForKey:@"notAmount"] floatValue];
        float withdrawals=[[self.dateMap objectForKey:@"withdrawals"] floatValue];
        
        float f=0;
        if(i<=yetAmount){
            
        }else{
            float b=i-yetAmount;
            f=b*withdrawals;
            
        }
        
        float f1= f*100;
        f1=f1+0.5;
        
        
        int s =f1;
        
        f=s/100.00;
        
       
        self.feeLB.text=[NSString stringWithFormat:@"提现手续费:   ￥%.2f",f];
        
    }
     [self.tv scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
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
            
        }
        
        else
            
        {
            
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




- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    return YES;
}




@end

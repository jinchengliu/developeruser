//  银行卡认证
//  BankCardAuthenticationVC.m
//  ZTRong
//
//  Created by fcl on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "BankCardAuthenticationVC.h"
#import "RechargeRecordsVC.h"
#import "RechargeVC.h"
#import "WithdrawalsrecordVC.h"
#import "WithdrawalsVC.h"
#import "UIButton+WebCache.h"

@interface BankCardAuthenticationVC ()
@property (weak, nonatomic) IBOutlet UITextField *bankcardText;         //银行卡号输入框
@property (weak, nonatomic) IBOutlet UITextField *numberText;           //预留电话输入框
@property (weak, nonatomic) IBOutlet UITextField *banckDetailedText;    //开户行地址
@property (weak, nonatomic) IBOutlet UIButton *nextBT;                  //认证按钮
@property (weak, nonatomic) IBOutlet UILabel *nameLB;                   //实名lb
@property (weak, nonatomic) IBOutlet UILabel *idCardLB;                 //身份证lb


@property (weak, nonatomic) IBOutlet UIButton *backnameBT;             //选择银行按钮
@property (weak, nonatomic) IBOutlet UILabel *backnameLB;             //选择银行lb

@property (weak, nonatomic) IBOutlet UIButton *stateBT;             //选择省按钮
@property (weak, nonatomic) IBOutlet UILabel *stateLB;             //选择省lb

@property (weak, nonatomic) IBOutlet UIButton *cityBT;             //选择城市按钮
@property (weak, nonatomic) IBOutlet UILabel *cityLB;             //选择城市lb



@end



@implementation BankCardAuthenticationVC


-(void)backAction{
    if(self.type==kpresent){
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    if(self.bankCardFromType == BankCardAdd){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



//显示充值成功popup
-(void)showBankCardAuthenPopup{
        BankCardAuthenPopup *popup=[[BankCardAuthenPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        popup.finishBlock=^{
            if(self.bankCardFromType == BankCardAdd){
                [self backAction];         //先返回
            }else{
                [self pushToRechargeVC];   //去充值
            }
        };
        [popup showInView:APPDELEGATE.window MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
            
            
            
        }];
}


//跳转到充值记录
-(void)pushToRechargeRecords{
    RechargeRecordsVC *rrVC=[[RechargeRecordsVC alloc] init];
    [self.navigationController pushViewController:rrVC animated:YES];
}

//跳转到充值
-(void)pushToRechargeVC{
    RechargeVC *rvc=[[RechargeVC alloc] initWithNibName:@"RechargeVC" bundle:nil];
   // WithdrawalsVC *rvc= [[WithdrawalsVC alloc] initWithNibName:@"WithdrawalsVC" bundle:nil];
    rvc.rechargeVCFromType=RechargeFromNewVC;
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
//    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 10)];
//    header.backgroundColor=[UIColor whiteColor];
//    [self.tv setTableHeaderView:header];
    
    [self.tv scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.view addSubview:self.tv];
    
//    if(kAppHeight==480  || DEVICE_IS_IPHONE5){
//        self.tv.scrollEnabled=YES;
//    }else{
//        self.tv.scrollEnabled=NO;
//    }
    
   
    [[AddressDBUitl sharedDAO] initDatabase];
    
    
//    NSArray *arrays=[[AddressDBUitl sharedDAO] allProvincesWithPickertype:kAddressPickerCommon];
//    
//    for (int i=0; i<arrays.count; i++) {
//        HZLocation *hz=[arrays objectAtIndex:i];
//        NSLog(@"%@",hz.addressName);
//    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值前准备";

    [self initTV];
    self.numberText.keyboardType = UIKeyboardTypeNumberPad;
    [self.nextBT setBackgroundImage:[Tool createImageWithColor:ButtonBG] forState:UIControlStateNormal];
    [self.nextBT addTarget:self action:@selector(bindingBankCard) forControlEvents:UIControlEventTouchUpInside];
    self.nextBT.layer.cornerRadius = 5;
    self.nextBT.layer.masksToBounds = YES;
    
    
    
    self.stateBT.layer.cornerRadius = 5;
    self.stateBT.layer.masksToBounds = YES;
    self.stateBT.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.stateBT.layer.borderWidth=0.5;
    
    self.cityBT.layer.cornerRadius = 5;
    self.cityBT.layer.masksToBounds = YES;
    self.cityBT.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.cityBT.layer.borderWidth=0.5;

    
    
    
    self.popoList=[[UIPopoverListView alloc] initWithFrame:CGRectMake(20, 90, kAppWidth-40, kAppHeight-110)];
    [self.popoList.listView setSeparatorColor:[UIColor clearColor]];
    self.popoList.delegate=self;
    self.popoList.datasource=self;

    
    
    [self.backnameBT handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //self.stateArray =[[AddressDBUitl sharedDAO] allProvincesWithPickertype:kAddressPickerCommon];
        
        
//        self.backNameList=[NSArray arrayWithObjects:@"工商银行", @"建设银行", @"招商银行", @"浦发银行", @"广发银行",
//                           @"交通银行", @"邮政储蓄银行", @"中信银行", @"民生银行", @"光大银行",@"兴业银行",@"上海银行",@"上海农商", @"平安银行", @"北京银行",@"北京农商银行",nil];  // 
//        
       
        self.popoList.tag =1000;
        self.popoList.isNeeddismiss=NO;
        [self.popoList.listView reloadData];
        [self.popoList setTitle:@"请选择银行"];
        [self.popoList show];
    }];
    
    
    
    
    [self.stateBT handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.stateArray =[[AddressDBUitl sharedDAO] allProvincesWithPickertype:kAddressPickerCommon];
        self.popoList.tag =1001;
        self.popoList.isNeeddismiss=YES;
        [self.popoList.listView reloadData];
        [self.popoList setTitle:@"请选择省"];
        [self.popoList show];
    }];
    
    
    
    [self.cityBT handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    
        if(self.stateHZ !=nil){
            self.cityArray =[[AddressDBUitl sharedDAO] citiesWithProvinceID:self.stateHZ.addressID pickerType:kAddressPickerCommon ];
            self.popoList.tag =1002;
            self.popoList.isNeeddismiss=YES;
            [self.popoList.listView reloadData];
            [self.popoList setTitle:@"请选择城市"];
            [self.popoList show];
            
            
        }else{
            [Tool showerrorLabelView:@"请先选择省" rootView:self.view superController:self];
        }
    
    
    
    }];
    
    
    
    self.numberText.delegate=self;
    self.banckDetailedText.delegate=self;
    self.bankcardText.delegate=self;

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserIdentity];
}


//获取用户实名信息
-(void)getUserIdentity{
    
//    idNo	String	身份证信息
//    realName	String	实名姓名
    
    
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    [map setObject:userid forKey:@"userId"];
    
//    [map setObject:self.numberText.text forKey:@"reserveMobile"];
//    [map setObject:self.bankcardText.text forKey:@"cardNo"];
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    NSLog(@"%@",params);
    self.nextBT.enabled=NO;
    
    //   获取银行信息       KCmdgetUserIdentity
    
    
    
    //     "identityCard": "43************11",
    //     "realName": "杨**"
    //      bankNames
    //      bns
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,KCmdbankCardAuth]  parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict){
        self.nextBT.enabled=YES;
      //  NSLog(dict.description);
        if([dict[@"success"] intValue] == 1){
            self.nameLB.text=[NSString stringWithFormat:@"持卡人 :  %@",[[dict objectForKey:@"map"] objectForKey:@"realName"]];
            self.idCardLB.text=[NSString stringWithFormat:@"证件号 :  %@",[[dict objectForKey:@"map"] objectForKey:@"identityCard"]];    //idNo
            self.backNameList= [[dict objectForKey:@"map"]  objectForKey:@"bankNames"];
            self.backiconList= [[dict objectForKey:@"map"]  objectForKey:@"bns"];

            
        }
    
    } failure:^(NSError *error){
        self.nextBT.enabled=YES;
    
    
    }];
    
    
}

//绑定银行卡
-(void)bindingBankCard{
    [self.view endEditing:YES];
    NSString *regex=@"^[0-9]{16,19}$";
    if(self.bankcardText.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入银行卡号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
        
        
    }else if( [Tool isRegex:regex string:self.bankcardText.text] ==NO ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的银行卡号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;

    }else if(self.numberText.text.length !=11 || self.numberText.text==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入11位的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else if(!self.backname){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择银行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
        
    }else if(!self.stateHZ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择省" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
        
    }else if(!self.cityHZ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
        
    }else if(self.banckDetailedText.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先输入开户支行名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;

    }
    
    NSMutableDictionary *map=[[NSMutableDictionary alloc] init];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:userId];
    if(userid ==nil){
        userid=@"";
    }
    //bankName      银行名称
    //province      省
    //city          市
    //bankSubName   支行名称
    [map setObject:userid forKey:@"userId"];
   
    [map setObject:self.numberText.text forKey:@"reserveMobile"];
    [map setObject:self.bankcardText.text forKey:@"cardNo"];
    
    [map setObject:self.backname forKey:@"bankName"];
    [map setObject:self.stateHZ.addressName forKey:@"province"];
    [map setObject:self.cityHZ.addressName forKey:@"city"];
    [map setObject:self.banckDetailedText.text forKey:@"bankSubName"];
    
    
    NSMutableDictionary *params =[Tool getHttpParams:map];
    NSLog(@"%@",params);
    self.nextBT.enabled=NO;
    [self showHUD];
    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,kCmdbankVerify]  parameters:@{@"message":[StringHelper dictionaryToJson:params]} finishBlock:^(NSDictionary *dict){
        self.nextBT.enabled=YES;
        [self.HUD hide:YES];
        
        NSLog( @"%@", dict.description);
        if([dict[@"success"] intValue] == 1){
            [self showBankCardAuthenPopup];
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
          //  [self.HUD hide:YES];
        
            NSString *message= [Tool getErrorMsssage:error];
            NSLog(@"%@",message);
            [self hideHUD:message];
    
    }];
    
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




#pragma mark - UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row==0){
        return 64;
    }else if(indexPath.row==1){
        return 60;
    }else if(indexPath.row==2){
        return 60;
    }else if(indexPath.row==3){
        return 60;
    }else if(indexPath.row==4){
        return 125;
    }else if(indexPath.row==5){
        return 60;
    }else if(indexPath.row==7){
        return 165;
    }else if(indexPath.row==6){
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
        cell = self.topCell;
    }else if(indexPath.row==1){
        cell = self.backNameCell;
    }else if(indexPath.row==2){
        cell = self.addressCell;        
    }else if(indexPath.row==3){
        cell = self.banckDetailedCell;
    }else if(indexPath.row==4){
        cell = self.inputCell;
    }else if(indexPath.row==5){
        cell  =  self.userMessageCell;
    }else if(indexPath.row == 7){
        cell  =  self.messageCell;
    }else if(indexPath.row==6){
        cell = self.doCell;
        
    }else{
        cell=self.topCell;
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

















#pragma mark - popoverListViewDelegate
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(popoverListView.tag==1000){
        return [self BackNamepopoverListView:popoverListView cellForIndexPath:indexPath];
    }
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier] ;
    
    //NSInteger row = indexPath.row;
    HZLocation *hz;
    if(popoverListView.tag==1001){
         hz =  [self.stateArray objectAtIndex:indexPath.row];
    }else if(popoverListView.tag ==1002){
         hz =  [self.cityArray objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.text = hz.addressName;
    cell.textLabel.textColor=[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1];
   // cell.textLabel.highlightedTextColor=[UIColor colorWithRed:186/255.0 green:152/255.0 blue:100/255.0 alpha:1];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth-40, 1)];
    line.backgroundColor=[UIColor grayColor];
    //[UIColor colorWithRed:198/255.0 green:173/255.0 blue:136/255.0 alpha:1];
    [cell addSubview:line];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    
    
    return cell;
}




- (UITableViewCell *)BackNamepopoverListView:(UIPopoverListView *)popoverListView
                            cellForIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier] ;

    
    
    NSString *title=[self.backNameList objectAtIndex:indexPath.row*2];
    NSString *image=[self.backiconList objectAtIndex:indexPath.row*2];
    UIButton *button1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kAppWidth-40)/2, 40)];
    [button1 setTitle:title forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [button1 handleControlEvent:UIControlEventTouchUpInside withBlock:^{
      //  NSLog(image);
        self.backnameLB.text=title;
        self.backname=title;
        [popoverListView dismiss];
     
    }];

    [button1 sd_setBackgroundImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if(image){
            [button1 setTitle:@"" forState:UIControlStateNormal];
        }
    } ];

    
    [cell addSubview:button1];
    
    NSInteger i=indexPath.row*2+1;
    
    if(i<self.backNameList.count){
        NSString *title2=[self.backNameList objectAtIndex:i];
         NSString *image2=[self.backiconList objectAtIndex:i];
        UIButton *button2=[[UIButton alloc] initWithFrame:CGRectMake((kAppWidth-40)/2, 0, (kAppWidth-40)/2, 40)];
        [button2 setTitle:title2 forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [button2 handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            self.backnameLB.text=title2;
           //  NSLog(image2);
            self.backname =title2;
            [popoverListView dismiss];
            
        }];
        
        [button2 sd_setBackgroundImageWithURL:[NSURL URLWithString:image2] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@""]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            if(image){
                [button2 setTitle:@"" forState:UIControlStateNormal];
            }
        } ];

        [cell addSubview:button2];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
    
}


- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    if(popoverListView.tag==1001){
        return self.stateArray.count;
    }else if(popoverListView.tag==1002){
        return self.cityArray.count;
    }else if(popoverListView.tag==1000){
        return self.backNameList.count/2 + self.backNameList.count%2;
    }
    return self.stateArray.count;
}




#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
   // self.selectIndex=indexPath.row;
    //[self bankCardVerification];
    
    if(popoverListView.tag==1001){
        self.stateHZ = [self.stateArray objectAtIndex:indexPath.row];
        self.stateLB.text=self.stateHZ.addressName;
        
        self.cityHZ=nil;
        //[self.cityArray objectAtIndex:indexPath.row];
        self.cityLB.text=@"选择市";
        //self.cityHZ.addressName;

    }else if(popoverListView.tag==1002){
        self.cityHZ=[self.cityArray objectAtIndex:indexPath.row];
        self.cityLB.text=self.cityHZ.addressName;
    }
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(popoverListView.tag==1000){
        return 40;
    }
    return 40.0f;
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


@end

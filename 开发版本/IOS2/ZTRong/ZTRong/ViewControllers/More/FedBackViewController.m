//
//  FedBackViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "FedBackViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "MBProgressHUD.h"

@interface FedBackViewController ()
{
    MBProgressHUD *HUD;
}
@end

@implementation FedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FedTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.FedTextView.layer.borderWidth = 1;
    self.FedTextView.layer.cornerRadius = 6;
    self.FedTextView.layer.masksToBounds = YES;
    
    self.FedTextView.delegate = self;
    HUD = [[MBProgressHUD alloc] init];
    [self.navigationController.view addSubview:HUD];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"用户反馈"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![UserTool userIsLogin])
    {
        loginViewController *loginView = [[loginViewController alloc] init];
        UINavigationController *nc=[[UINavigationController alloc] initWithRootViewController:loginView];
        loginView.isFromIndex3 = YES;
        nc.navigationBar.barStyle = UIStatusBarStyleDefault;
        [nc.navigationBar setTintColor:[UIColor whiteColor]];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (![UserTool userIsLogin]) {
        self.tabBarController.selectedIndex = 2;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)recoverBtn
{
    self.view.userInteractionEnabled = YES;
}

- (IBAction)submitButton:(id)sender
{
    if(![self.FedTextView.text isEqualToString:@"\n   我们力求为您提供优质、高效的服务，期待您的宝贵建议^ 0 ^"])
    {
        if(self.FedTextView.text.length != 0)
        {
            self.view.userInteractionEnabled = NO;
            [self performSelector:@selector(recoverBtn) withObject:sender afterDelay:0.6f];


            [HUD show:YES];
            NSDictionary *param = @{@"feedContent":self.FedTextView.text,@"userId":[UserTool getUserID],@"userName":[UserTool getUserName]};
            NSString *str = [StringHelper dicSortAndMD5:param];
            NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};
            
            [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/addUserFeed.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
                if([dict[@"success"] intValue] == 1)
                {
                    [HUD hide:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"反馈成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }else{
                    [HUD hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:dict[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                
                
            } failure:^(NSError *NSError) {
                
                
                
                [HUD hide:YES];
                
                NSString *message= [Tool getErrorMsssage:NSError];
                
                NSLog(@"%@",message);
                
            }];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入反馈内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入反馈内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.FedTextView resignFirstResponder];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([self.FedTextView.text isEqualToString:@"\n   我们力求为您提供优质、高效的服务，期待您的宝贵建议^ 0 ^"])
    {
        textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>120)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"字数不得超过120个" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
        textView.text = [textView.text substringToIndex:120];
    }
}
@end

//
//  MainViewController.m
//  ZTRong
//
//  Created by 李婷 on 15/5/22.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(void)backAction{
    if(self.type==kpresent){
        self.navigationController.tabBarController.tabBar.hidden=NO;
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecognizer];
    
    
    if( self. navigationController.viewControllers.count > 1){
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        self.navigationItem.leftBarButtonItem=leftItem;
        
        //[self.navigationController setNavigationBarHidden:YES animated:NO];
        
        //hidesBottomBarWhenPushed
        
    }
    
    
    if(self.navigationController.viewControllers.count==1 && self.type ==kpresent){
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        self.navigationItem.leftBarButtonItem=leftItem;
        
    }
    
    
    self.HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:self.HUD];
    
    
    //debug宏
#ifdef DEBUG
    //    UIButton *fastLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    fastLoginBtn.frame = imageVew.frame;
    //    [fastLoginBtn addTarget:self action:@selector(fastLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [landScrollView addSubview:fastLoginBtn];
#endif
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if( self. navigationController.viewControllers.count > 1){
        
        self.navigationController.tabBarController.tabBar.hidden=YES;
    }else{
        self.navigationController.tabBarController.tabBar.hidden=NO;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if( self. navigationController.viewControllers.count ==1){
        self.navigationController.tabBarController.tabBar.hidden=NO;
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

- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureFrom:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

#pragma mark - GestureRecognizer
-(void)handleGestureFrom:(UIGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}



//显示hud
-(void)showHUD{
    self.HUD.labelText=@"";
    [self.HUD show:YES];
    
    self.view.userInteractionEnabled = NO;
}

//隐藏hud
-(void)hideHUD:(NSString *)error{
    self.HUD.labelText=error;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.HUD hide: YES];
        self.view.userInteractionEnabled = YES;
    });
    
}
@end

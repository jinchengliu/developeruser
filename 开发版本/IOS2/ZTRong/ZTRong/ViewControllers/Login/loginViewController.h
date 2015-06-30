//
//  loginViewController.h
//  yilong
//
//  Created by fcl on 15/3/20.
//  Copyright (c) 2015年 itcast. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "registerViewController.h"



/**
 定义协议，用来实现传值代理
 */
@protocol loginDelegate <NSObject>

/**
 此方为必须实现的协议方法，用来传值
 */
- (void)username:(NSString *)pStr  password:(NSString *)password;
- (void)GetIsRegiserRetun:(NSString *)IsRegiserRetun;
- (void)GetIsLetter:(NSString *)IsIsLetter;//用于判断站内信登陆成功返回的状态
@end

@interface loginViewController : UIViewController<registerViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, unsafe_unretained) id<loginDelegate> delegate;
@property(nonatomic,copy) NSString *isLetter;//是否从站内信过来的
@property (weak, nonatomic) IBOutlet UITextField *txtusername;
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (nonatomic) BOOL isFromIndex3;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *RefindBtn;
@property (weak, nonatomic) IBOutlet UIButton *resigerBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn2;
@property (weak, nonatomic) IBOutlet UIButton *refindBtn2;
@property (weak, nonatomic) IBOutlet UIButton *resigerBtn2;
@property (nonatomic) BOOL isFromWeb;
@end

//
//  PayChangeViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayChangeViewController : MainViewController<UITextFieldDelegate>

- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *payPassText;
@property (weak, nonatomic) IBOutlet UITextField *payNewPassText;
@property (weak, nonatomic) IBOutlet UITextField *payNewagainText;
@property (weak, nonatomic) IBOutlet UITextField *telVerCodeText;
@property (weak, nonatomic) IBOutlet UIButton *telVerCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)telVerCodeBtnPressed:(id)sender;
- (IBAction)confirmBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *wrongPayPassLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongPayagainPassLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@end

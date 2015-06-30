//
//  PayPasswordViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPasswordViewController : MainViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *telVerCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *payPassText;
@property (weak, nonatomic) IBOutlet UITextField *payagainText;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *payPassLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *telVercodeText;
- (IBAction)telVerCodeBtnPressed:(id)sender;
- (IBAction)confirmBtnPressed:(id)sender;
@end

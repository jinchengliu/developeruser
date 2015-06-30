//
//  PhoneViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneViewController : MainViewController<UITextFieldDelegate>

- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *telVerCodeText;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *telVerCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *telVerCodeBtn;
- (IBAction)telVerCodeBtnPressed:(id)sender;
- (IBAction)confirmBtnPressed:(id)sender;
@end

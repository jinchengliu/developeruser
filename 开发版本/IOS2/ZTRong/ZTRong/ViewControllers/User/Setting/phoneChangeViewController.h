//
//  phoneChangeViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/14.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface phoneChangeViewController : MainViewController<UITextFieldDelegate>

- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *telVerCodeText;
@property (weak, nonatomic) IBOutlet UIButton *telVerCodeBtn;
- (IBAction)telVerCodeBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextField *payPassText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNewText;
@property (weak, nonatomic) IBOutlet UITextField *telVerCode2;
@property (weak, nonatomic) IBOutlet UIButton *telVerCodeBtn2;
- (IBAction)telVerCodeBtn2Pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

//
//  loginPasswordViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginPasswordViewController : MainViewController<UITextFieldDelegate>

- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginText;
@property (weak, nonatomic) IBOutlet UITextField *newloginText;
@property (weak, nonatomic) IBOutlet UITextField *newagainText;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *newagainLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
- (IBAction)changePasswordBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (BOOL)isPureInt:(NSString*)string;
- (BOOL)isCharater:(NSString *)string;
@end

//
//  ForgetViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetViewController : UIViewController<UITextFieldDelegate>

- (IBAction)confirmBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UILabel *label1;
- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *telVcodeText;
- (IBAction)telVcodeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *telVcodeBt;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@end

//
//  ReFindViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/18.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReFindViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *payPassText;
@property (nonatomic,strong) NSString *phoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel1;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel2;
- (IBAction)confirmBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UITextField *passAgainText;
@end

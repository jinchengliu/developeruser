//
//  IdentityViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/13.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentityViewController : MainViewController<UITextFieldDelegate>

- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cofirmBtnPressed;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *identityText;
- (IBAction)confirmBtn:(id)sender;
@end

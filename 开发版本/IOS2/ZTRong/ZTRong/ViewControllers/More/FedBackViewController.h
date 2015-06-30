//
//  FedBackViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FedBackViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *FedTextView;
- (IBAction)submitButton:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end

//
//  NewCustomViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/19.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCustomViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageview;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIScrollView *underScroller;

- (void)setScrollerView:(NSDictionary *)dict;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)backviewTap:(id)sender;
@end

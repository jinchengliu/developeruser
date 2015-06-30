//
//  YLQRcodeViewController.h
//  yilong
//
//  Created by fcl on 15/4/10.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLQRcodeViewControllerDelegate <NSObject>

/**
 此方为必须实现的协议方法，用来传值@required
 */

- (void)SetInvitationCode:(NSString *)InvitationCode;//邀请码

@end

@interface YLQRcodeViewController : UIViewController
@property (nonatomic, unsafe_unretained) id<YLQRcodeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *saomiaoBtn;
- (IBAction)saomiaoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *saomiaoLabel;

@end

//
//  SettingViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/12.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : ZTRMajorViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;
- (IBAction)confirmButton:(id)sender;
@end

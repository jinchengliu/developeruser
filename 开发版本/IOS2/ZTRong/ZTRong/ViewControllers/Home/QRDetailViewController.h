//
//  QRDetailViewController.h
//  ZTRong
//
//  Created by yangmine on 15/6/10.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRDetailViewController : ZTRMajorViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRiamgeView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic,strong) NSString *QRURL;
@end

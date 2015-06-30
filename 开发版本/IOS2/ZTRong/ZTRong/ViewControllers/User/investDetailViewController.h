//
//  investDetailViewController.h
//  ZTRong
//
//  Created by yangmine on 15/5/24.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface investDetailViewController : UIViewController

@property (nonatomic,strong) NSString *ordId;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lefttimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;
@property (weak, nonatomic) IBOutlet UILabel *payBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *redBagLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *realPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *gmLabel;
@property (weak, nonatomic) IBOutlet UILabel *boolPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (weak, nonatomic) IBOutlet UILabel *jyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fhblLabel;
@property (weak, nonatomic) IBOutlet UILabel *jxfsLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *dwLabel;
@property (weak, nonatomic) IBOutlet UILabel *jxLabel;
@property (weak, nonatomic) IBOutlet UILabel *benLabel;
@property (weak, nonatomic) IBOutlet UILabel *bfbLabel;
@property (weak, nonatomic) IBOutlet UILabel *yinLabel;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *jxLabel1;
@property (weak, nonatomic) IBOutlet UILabel *detaiNameLabel;

@property (nonatomic) BOOL isFromHome;

- (void)setOrderDetail:(NSDictionary *)dict;
- (IBAction)htBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *htBtn;
@end

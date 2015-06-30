//
//  RewardCell.m
//  ZTRong
//
//  Created by 李婷 on 15/6/8.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "RewardCell.h"

@implementation RewardCell

- (void)awakeFromNib {
    // Initialization code
    
    _bgView.layer.borderColor = RGBColor(220, 220, 220).CGColor;
    _bgView.layer.borderWidth = 1;
    
    _name.textColor = ButtonBG;
    _investID.textColor = ButtonBG;
    _orderMoney.textColor = ButtonBG;
    _rate.textColor = ButtonBG;
    _dateTime.textColor = ButtonBG;
    
    _name.adjustsFontSizeToFitWidth = YES;
    _investID.adjustsFontSizeToFitWidth = YES;
    _orderMoney.adjustsFontSizeToFitWidth = YES;
    _rate.adjustsFontSizeToFitWidth = YES;
    _dateTime.adjustsFontSizeToFitWidth = YES;
    _reward.adjustsFontSizeToFitWidth = YES;

}

- (void)setIsInvest:(BOOL)isInvest{
    _isInvest = isInvest;
    
    if (isInvest) {
        _isInvestImage.image = [UIImage imageNamed:@"myshare_user_already"];
    }else
        _isInvestImage.image = [UIImage imageNamed:@"myshare_user_un"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

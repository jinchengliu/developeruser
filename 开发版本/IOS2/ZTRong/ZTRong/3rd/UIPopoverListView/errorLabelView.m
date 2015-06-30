//
//  errorLabelView.m
//  API4.0Demo
//
//  Created by  on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "errorLabelView.h"
#import <QuartzCore/QuartzCore.h>

#define errorLabelWidth     150
#define errorLabelHeight    30

@implementation errorLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorLabelWidth, errorLabelHeight)];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.backgroundColor = [UIColor blackColor];
        errorLabel.alpha = 0.7;
        errorLabel.layer.masksToBounds = YES;
        errorLabel.layer.cornerRadius = 4;
        errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        errorLabel.numberOfLines = 100;
        errorLabel.textColor = [UIColor whiteColor];
        errorLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:errorLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame superController:(UIViewController*)superController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, errorLabelWidth, errorLabelHeight)];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.backgroundColor = [UIColor blackColor];
        errorLabel.alpha = 0.7;
        errorLabel.layer.masksToBounds = YES;
        errorLabel.layer.cornerRadius = 4;
        errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        errorLabel.numberOfLines = 100;
        errorLabel.textColor = [UIColor whiteColor];
        errorLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:errorLabel];
        for(errorLabelView *view in superController.navigationController.view.subviews)
        {
            if([view isKindOfClass:[errorLabelView class]])
            {
                [view.timeSlice invalidate];
                [view removeFromSuperview];
                break;
            }
        }
        // Initialization code
    }
    return self;
}

- (void)setLabeldescribe:(UILabel *)labelStr
{
//    CGSize size = CGSizeMake(300, 10000);
//    CGSize labelSize = [labelStr.text sizeWithFont:labelStr.font
//                                 constrainedToSize:size
//                                     lineBreakMode:NSLineBreakByClipping];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:labelStr.text
     attributes:@
     {
     NSFontAttributeName:labelStr.font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize labelSize = rect.size;


    self.frame = CGRectMake(0, kAppHeight - 130, kAppWidth, labelSize.height + 10);


    labelStr.frame = CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - labelSize.width - 10) / 2, 0,
            labelSize.width + 10, labelSize.height + 10);
}


- (void)setErrorText:(NSString *)str
{
    errorLabel.text = str;
    if (str==nil || str.length == 0) {
        errorLabel.hidden = YES;
    }
    [self setLabeldescribe:errorLabel];
    self.timeSlice = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayRemove:) userInfo:nil repeats:NO];
}

- (void)delayRemove:(id)sender
{

    [self removeFromSuperview];
    //   [self release];

}

-(void)dealloc{
    if(self.timeSlice){
        [self.timeSlice invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

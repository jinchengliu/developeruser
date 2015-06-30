//
//  errorLabelView.h
//  API4.0Demo
//
//  Created by  on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface errorLabelView : UIView
{
    UILabel *errorLabel;
}
- (void)setErrorText:(NSString *)str;
- (id)initWithFrame:(CGRect)frame superController:(UIViewController*)superController;

@property (nonatomic,strong) NSTimer *timeSlice;

@end

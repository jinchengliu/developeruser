//
//  SelectionPopup.m
//  ZTRong
//
//  Created by fcl on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "SelectionPopup.h"

@implementation SelectionPopup

- (void)maskWillAppear {
    // do noting in base
    [super maskWillAppear];
   // CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
   // UIButton *cancel =[[UIButton alloc] initWithFrame:CGRectMake(kAppWidth-130, 20, 120, 40)];
    UIButton *cancel =[[UIButton alloc] initWithFrame:CGRectMake(0, 0,kAppWidth, kAppHeight)];

    
    [cancel handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self doDismiss];
    
    }];
    
    
    [self.bgView addSubview:cancel];
    
    UIView  *waitingCenterView = [[UIView alloc] initWithFrame:CGRectMake(kAppWidth-130, 64, 120, self.showDate.count*40)];
    waitingCenterView.backgroundColor = [UIColor clearColor];
    //waitingCenterView.layer.cornerRadius = 10;
    [self.bgView addSubview:waitingCenterView];
    
    if(self.showTV==nil){
        self.showTV=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, waitingCenterView.frame.size.width, waitingCenterView.frame.size.height)];
        self.showTV.delegate=self;
        self.showTV.dataSource=self;
        self.showTV.separatorColor=[UIColor clearColor];
        
    }
    
    
    [waitingCenterView addSubview:self.showTV];
    
    self.bgView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
    
//    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 286, 335)];
//    bg.backgroundColor=[UIColor clearColor];
//    bg.image=[UIImage imageNamed:@"xuanyao_bg"];
    
 //   [waitingCenterView addSubview:bg];
    
    
    
}





- (void)maskDoAppear {
    [super maskDoAppear];
//    self.bgView.frame=CGRectMake(0,self.bgView.frame.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)maskDidAppear {
    // do noting in base
    [super maskDidAppear];
}

- (void)maskWillDisappear {
    // do noting in base
    [super maskWillDisappear];
}

- (void)maskDoDisappear {
    // do noting in base
    [super maskDoDisappear];
  //  self.bgView.frame=CGRectMake(0,kAppHeight, self.frame.size.width, self.frame.size.height);
}

- (void)maskDidDisappear {
    // do noting in base
    [super maskDidDisappear];
}





#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showDate.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier];
//        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(10, 39, 100, 1)];
//        line.backgroundColor=[UIColor colorWithRed:198/255.0 green:173/255.0 blue:136/255.0 alpha:1];
//        [cell addSubview:line];
    }
    //NSInteger row = indexPath.row;
    if ([[self.showDate objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = [self.showDate objectAtIndex:indexPath.row];

    }else
        cell.textLabel.attributedText = [self.showDate objectAtIndex:indexPath.row];

    cell.textLabel.textColor=[UIColor colorWithRed:127/255.0 green:122/255.0 blue:120/255.0 alpha:1];
    cell.textLabel.highlightedTextColor=[UIColor whiteColor];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:94/255.0 green:71/255.0 blue:34/255.0 alpha:1];
    cell.contentView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.finishBlock){
        self.finishBlock(indexPath.row);
    }
    
    [self doDismiss];
    
}



@end

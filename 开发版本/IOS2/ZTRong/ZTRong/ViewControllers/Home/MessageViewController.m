//
//  MessageViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/20.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MessageViewController.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"

@interface MessageViewController ()
{
    NSMutableArray *titleArray;
    NSMutableArray *contentArray;
    NSMutableArray *dateArray;
    int totalNumber;
    int unreadNumber;
    SelectionPopup *popup;
    BOOL isreload;
    int textviewHeight;
    NSIndexPath *indexpath;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tv.delegate = self;
    self.tv.dataSource = self;
        
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"站内消息"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    titleArray = [NSMutableArray array];
    contentArray = [NSMutableArray array];
    dateArray = [NSMutableArray array];
    
    self.headView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:246.0f/255.0f blue:247.0f/255.0f alpha:1];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"my_redbag_right_button"] style:UIBarButtonItemStyleBordered target:self action:@selector(showPopo)];
    settingItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingItem;
}

-(void)showPopo{
    
    
    if(popup==nil){
        popup=[[SelectionPopup alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
        popup.showDate =[[NSArray alloc] initWithObjects:@"不限",@"近1周",@"近1个月",@"近3个月", nil];
        NSArray *typeArray= [[NSArray alloc] initWithObjects:@"",@"jinyizhou",@"jinyigeyue",@"jinsangeyue", nil];
        __weak MessageViewController *blockself = self;
        popup.finishBlock=^(NSInteger i){
            blockself.Selection =[typeArray objectAtIndex:i];
            blockself.page=1;
            //        [self getrechargeRecords];
        
        };
    }
    
    [popup showInView:APPDELEGATE.window MaskColor:[[UIColor blackColor] colorWithAlphaComponent:.3f] Completion:^{} Dismission:^{
        
        
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showHUD];
    isreload = NO;
    
    NSDictionary *param = @{@"dateRange":@"1",@"page":@"1",@"userName":[UserTool getUserName]};
    NSString *str = [StringHelper dicSortAndMD5:param];
    NSDictionary * params = @{@"channel":@"APP",@"params":param,@"sign":str,@"version":@"1.0"};

    [Tool ZTRPostRequest:[NSString stringWithFormat:@"%@%@",htmlUrl,@"/user/userMessageList.htm"] parameters:@{@"message":[StringHelper dictionaryToJson:params]}  finishBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        if([dict[@"success"] intValue] == 1)
        {
            [self hideHUD:@""];
            NSLog(@"%@",dict);
            totalNumber = [dict[@"map"][@"totalNumber"] intValue];
            unreadNumber = [dict[@"map"][@"unreadNumber"] intValue];
            NSString *totalStr = [NSString stringWithFormat:@"%i",unreadNumber];
            NSString *unreadStr = [NSString stringWithFormat:@"%i",totalNumber-unreadNumber];
            NSString *str = [NSString stringWithFormat:@"共有%i条未读，%i条已读站内消息",unreadNumber,totalNumber-unreadNumber];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(2, 7+totalStr.length+unreadStr.length);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
            [self.messageLabel setAttributedText:noteStr] ;
            if(dict[@"map"][@"pageInfo"][@"rows"])
            {
                NSArray *array = dict[@"map"][@"pageInfo"][@"rows"];
                NSLog(@"%@",array);
                    for(NSDictionary *dic in array)
                    {
                    if(![dic[@"title"] isEqualToString:@""])
                    {
                        [titleArray addObject:dic[@"title"]];
                    }
                    else
                    {
                        [titleArray addObject:@""];
                    }
                    if(![dic[@"content"] isEqualToString:@""])
                    {
                        [contentArray addObject:dic[@"content"]];
                    }
                    else
                    {
                        [contentArray addObject:@""];
                    }
                    if(dic[@"createDateStr"] != nil)
                    {
                        [dateArray addObject:dic[@"createDateStr"]];
                    }
                    else
                    {
                        [dateArray addObject:@""];
                    }
                }
            }
            [self.tv reloadData];
        }
        else
        {
            [self hideHUD:dict[@"errorMsg"]];
        }
        
    } failure:^(NSError *NSError) {
        
        NSString *message= [Tool getErrorMsssage:NSError];
        [self hideHUD:message];
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    UILabel *label;
    UILabel *dateLabel;
    UIWebView *webview;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    for(id subview in cell.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, (self.view.bounds.size.width*180)/320, 20)];
    label.text = titleArray[indexPath.row];
    label.font = [UIFont fontWithName:nil size:14];
//    label.text = @"站内消息";
    label.textColor = [UIColor colorWithRed:186.0f/255.0f green:159.0f/255.0f blue:113.0f/255.0f alpha:1];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-140, 20, 120, 20)];
    dateLabel.font = [UIFont fontWithName:nil size:12];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.text = dateArray[indexPath.row];
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(15, 50, self.view.bounds.size.width-30, 50)];
    webview.delegate = self;
//    webview = (UIWebView *)[cell.contentView viewWithTag:10003];
    
    [webview loadHTMLString:contentArray[indexPath.row] baseURL:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webview loadRequest:request];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:dateLabel];
    [cell.contentView addSubview:webview];
//    dateLabel.text = @"今天";
    
//    UITextView *textview;
//    if(isreload == NO)
//    {
//        textviewHeight = 40;
//        
//    }
//    else
//    {
//        textviewHeight = [self heightForString:contentArray[indexPath.row] fontSize:14 andWidth:self.view.bounds.size.width-30];
//        textview = [[UITextView alloc] initWithFrame:CGRectMake(15, 50, self.view.bounds.size.width-30, textviewHeight)];
//    }
//    
//    textview.editable = NO;
//    textview.font = [UIFont fontWithName:nil size:14];
//    textview.text = contentArray[indexPath.row];
    
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-55, 60+textviewHeight, 30, 30)];
//    button.tag = indexPath.row;
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    if(isreload == NO)
//    {
//        [button setImage:[UIImage imageNamed:@"down_normal"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [button setImage:[UIImage imageNamed:@"up_normal"] forState:UIControlStateNormal];
//    }
//    [button addTarget:self action:@selector(reloadIndex:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:button];
    return cell;
}

- (void)reloadIndex:(UIButton *)btn
{
    if(isreload == NO)
    {
        UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
        NSIndexPath *indexPath = [self.tv indexPathForCell:cell];
        isreload = YES;
        [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        indexpath = indexPath;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
        NSIndexPath *indexPath = [self.tv indexPathForCell:cell];
        isreload = NO;
        [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        indexpath = indexPath;
    }
}

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isreload == NO)
    {
        return 120;
    }
    else
    {
        return 140+textviewHeight-40;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

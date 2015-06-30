//
//  MoreViewController.m
//  ZTRong
//
//  Created by yangmine on 15/5/11.
//  Copyright (c) 2015年 李婷. All rights reserved.
//

#import "MoreViewController.h"
#import "MBProgressHUD.h"

@interface MoreViewController ()
{
    NSString *bundleName;
    BOOL isCellSelected;
    MBProgressHUD *HUD;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moreTable.delegate = self;
    self.moreTable.dataSource = self;
    
    HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:HUD];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"更多"];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    self.list1Array = @[@"最新动态",@"网站公告"];
    self.list2Array = @[@"关于我们",@"联系我们"];
    self.list3Array = @[@"用户反馈"];
   // self.list3Array = @[@"用户反馈",@"检查更新"];
    self.image1Array = @[@"more_icon01",@"more_icon02"];
    self.image2Array = @[@"more_icon03",@"more_icon04"];
    self.image3Array = @[@"more_icon06",@"more_icon07"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:39.0f/255.0f green:15.0f/255.0f blue:8.0f/255.0f alpha:1]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.view.userInteractionEnabled = NO;
//    [self performSelector:@selector(recoverTabbar) withObject:nil afterDelay:0.6f];
}

- (void)recoverTabbar
{
    self.tabBarController.view.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.list1Array.count;
    }
    else if(section == 1)
    {
        return self.list2Array.count;
    }
    else if(section == 2)
    {
        return self.list3Array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    NSUInteger section = [indexPath section];
    if(section == 0)
    {
        cell.textLabel.text = [self.list1Array objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.image1Array[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(section == 1)
    {
        cell.textLabel.text = [self.list2Array objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.image2Array[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(section == 2)
    {
        cell.textLabel.text = [self.list3Array objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.image3Array[indexPath.row]];
        if(indexPath.row == 1)
        {
           // [self onCheckVersion];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-40, cell.textLabel.frame.origin.y+5, 40, (self.view.bounds.size.height*40)/568)];
            label.text = [NSString stringWithFormat:@"%@",bundleName];
            label.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:label];
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 设置自由控制更新callback函数
     若程序需要自由控制收到更新内容后的流程可设置delegate和callback函数来完成
     
     @param delegate 需要自定义checkUpdate的对象.
     @param callBackSelectorWithDictionary 当checkUpdate事件完成时此方法会被调用,同时标记app更新信息的字典被传回.
     */
    // + (void)checkUpdateWithDelegate:(id)delegate selector:(SEL)callBackSelectorWithDictionary;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    NSInteger section=[indexPath section];
    
    if(section == 0)
    {
        if(indexPath.row == 0)
        {
//
            UIViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"NewActionViewController"];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
        else if(indexPath.row == 1)
        {
            
            UIViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"WebActionViewController"];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    else if(section == 1)
    {
        if(indexPath.row == 0)
        {
            
            WebViewController *web = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
            web.title = @"关于我们";
            web.url = [NSString stringWithFormat:@"%@/about.htm",htmlUrl];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];

                }
        else if(indexPath.row == 1)
        {
            WebViewController *web = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
            web.title = @"联系我们";
            web.url = [NSString stringWithFormat:@"%@/contact.htm",htmlUrl];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
            
        }
//        else if(indexPath.row == 2)
//        {
//            
//            
//            WebViewController *web = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
//            web.title = @"合作伙伴";
//            web.url = [NSString stringWithFormat:@"%@/partners.htm",htmlUrl];
//            web.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:web animated:YES];
//            
//            
//        }
    }
    else if(section == 2)
    {
        if(indexPath.row == 0)
        {
            
            UIViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"FedBackViewController"];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
        else if(indexPath.row == 1)
        {
//            [MobClick checkUpdateWithDelegate:self selector:@selector(btnUpdate:)];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
            isCellSelected = YES;
            //[self onCheckVersion];
        }
    }
    
    //    if (section==5) {
    //        //[MobClick checkUpdate:@"New version" cancelButtonTitle:@"Skip" otherButtonTitles:@"Goto Store"];
    //        //[MobClick checkUpdate];
    //        [MobClick checkUpdateWithDelegate:self selector:@selector(btnUpdate:)];
    //    }
    
    
    [self.moreTable  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (50*self.view.bounds.size.height)/568;
}


//- (void)btnUpdate:(NSDictionary *)appInfo
//{
//    NSLog(@"appInfo:%@",appInfo);
//    NSString *IsUpdateVersion=appInfo[@"update"];
//    NSString *version=appInfo[@"version"];
//    NSString *versionMsg=[NSString stringWithFormat:@"最新版本：%@",version];
//    self.appstoreURL=appInfo[@"path"];
//    NSLog(@"appInfo:%@",appInfo);
//    
//    if ([IsUpdateVersion isEqualToString:@"YES"]) {
//        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"发现新版本" message:versionMsg delegate:self cancelButtonTitle:@"忽略此版本" otherButtonTitles:@"访问AppStore", nil];
//        [alertview show];
//    }else if([IsUpdateVersion isEqualToString:@"NO"])
//    {
//        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前版本已是最新版本！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertview show];
//        
//    }
//}
//
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSString *AppStoreURL=self.appstoreURL;
//    NSLog(@"AppStoreURL:%@",AppStoreURL);
//    if (buttonIndex==1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreURL]];
//    }
//    
//}
-(void)onCheckVersion
{
//    [HUD show:YES];
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    //CFShow((__bridge CFTypeRef)(infoDic));
//    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    
//    NSString *URL = @"http://itunes.apple.com/lookup?id=998432074";
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:URL]];
//    [request setHTTPMethod:@"POST"];
//    NSHTTPURLResponse *urlResponse = nil;
//    NSError *error = nil;
//    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    
//    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
//    NSData *jsonData = [results dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
////    = [results js];
//    NSArray *infoArray = [dic objectForKey:@"results"];
//    if ([infoArray count]) {
//        [HUD hide:YES];
//        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
//        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
//        
//        if (![lastVersion isEqualToString:currentVersion]) {
//            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
//            alert.tag = 10000;
//            [alert show];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alert.tag = 10001;
//            [alert show];
//            bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        }
//    }
//    else
//    {
//        [HUD hide:YES];
//        if(isCellSelected == YES)
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alert.tag = 10001;
//            [alert show];
//
//            bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        }
//        else
//        {
//            bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        }
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}


@end

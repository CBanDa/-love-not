//
//  HomeViewController.m
//  爱普笔记
//
//  Created by ldci on 14-1-2.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "HomeViewController.h"
#import "MainView.h"
#import "NewViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"印象笔记";
    NSLog(@"self.view franme is : %@",NSStringFromCGRect(self.view.frame));

    
    // 导航
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"beijing.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 背景
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing.png"]];
    [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imageView];
    
    [self initBottomView];
    
    //笔记数组
    self.noteCoverMArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    self.remindCoverMArray = [[NSMutableArray alloc]initWithCapacity:12];
    [self createSQL];
	// Do any additional setup after loading the view.
}

// 底下的按钮集合
- (void)initBottomView
{
    // 下面的按钮图片
    UIImageView *imageKong = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kongjian.png"]];
    [imageKong setFrame:CGRectMake(8, self.view.frame.size.height-180, self.view.frame.size.width-15, 110)];
    [self.view addSubview:imageKong];
    
    // 往图片上面添加透明按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(24, self.view.frame.size.height-80, 30, 30)];
    [button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(85, self.view.frame.size.height-80, 30, 30)];
    [button2 addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setFrame:CGRectMake(145, self.view.frame.size.height-80, 30, 30)];
    [button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setFrame:CGRectMake(205, self.view.frame.size.height-80, 30, 30)];
    [button4 addTarget:self action:@selector(button4:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 setFrame:CGRectMake(266, self.view.frame.size.height-80, 30, 30)];
    [button5 addTarget:self action:@selector(button5:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button6 setFrame:CGRectMake(8, self.view.frame.size.height-145 ,303, 55)];
    [button6 addTarget:self action:@selector(button5:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button6];
}

// 拍照的快捷键
- (void)button1:(id)sender
{
    // 存储数据
    if(self.noteCoverMArray.count == 0)
    {
        NSDate *  senddate=[NSDate date];
        
        NSCalendar  * cal = [NSCalendar  currentCalendar];
        NSUInteger  unitFlags =NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
        // NSInteger year = [conponent year];
        NSInteger month = [conponent month];
        NSInteger day = [conponent day];
        NSInteger hour = [conponent hour];
        NSInteger minute = [conponent minute];
        self.message = [NSString stringWithFormat:@"%2d:%02d,%2d/%2d",hour,minute,day,month];
        [self.dataWorker insertGroupTitle:self.message andGroupID:0];
    }
    NewViewController *new = [[NewViewController alloc]init];
    new.title = @"新笔记";
    new.GroupID = [[[self.noteCoverMArray lastObject]objectAtIndex:1]intValue];
    new.isFirst = YES;
    [self.navigationController pushViewController:new animated:YES];
    self.delegate = new;
    [self.delegate openCamera:nil];
    
}

// 图片库的快捷键
- (void)button2:(id)sender
{
    // 存储数据
    if(self.noteCoverMArray.count == 0)
    {
        NSDate *  senddate=[NSDate date];
        
        NSCalendar  * cal = [NSCalendar  currentCalendar];
        NSUInteger  unitFlags =NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
        // NSInteger year = [conponent year];
        NSInteger month = [conponent month];
        NSInteger day = [conponent day];
        NSInteger hour = [conponent hour];
        NSInteger minute = [conponent minute];
        self.message = [NSString stringWithFormat:@"%2ld:%02ld,%2ld/%2ld",(long)hour,(long)minute,(long)day,(long)month];
        [self.dataWorker insertGroupTitle:self.message andGroupID:0];
    }
    NewViewController *new = [[NewViewController alloc]init];
    new.title = @"新笔记";
    new.GroupID = [[[self.noteCoverMArray lastObject]objectAtIndex:1]intValue];
    new.isFirst = YES;
    [self.navigationController pushViewController:new animated:YES];
    //设置代理
    self.delegate = new;
    [self.delegate openPhotoLibrary:nil];
}

// 提醒的快捷键
- (void)button3:(id)sender
{
    RemindViewController *remind = [[RemindViewController alloc]init];
    NSMutableArray * array = [self.dataWorker selectData];
    if (array.count == 0) {
        remind.rowID = 0;
    }else{
        remind.rowID = [[[array objectAtIndex:0]objectForKey:@"id"]intValue];
        for (int i = 0; i<array.count; i++) {
            if (remind.rowID <= [[[array objectAtIndex:i]objectForKey:@"id"]intValue]) {
                remind.rowID = [[[array objectAtIndex:i]objectForKey:@"id"]intValue]+1;
            }
        }
    }
    [self.navigationController pushViewController:remind animated:YES];
}

// 笔记本的快捷键
- (void)button4:(id)sender
{
    GroupViewController *groupVC = [[GroupViewController alloc]init];
    [self.navigationController pushViewController:groupVC animated:YES];
}

// 写笔记的快捷键
- (void)button5:(id)sender
{
    // 存储数据
    if(self.noteCoverMArray.count == 0)
    {
        NSDate *  senddate=[NSDate date];
        
        NSCalendar  * cal = [NSCalendar  currentCalendar];
        NSUInteger  unitFlags =NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
        // NSInteger year = [conponent year];
        NSInteger month = [conponent month];
        NSInteger day = [conponent day];
        NSInteger hour = [conponent hour];
        NSInteger minute = [conponent minute];
        self.message = [NSString stringWithFormat:@"%2d:%02d,%2d/%2d",hour,minute,day,month];
        [self.dataWorker insertGroupTitle:self.message andGroupID:0];
    }
    NewViewController *new = [[NewViewController alloc]init];
    new.title = @"新笔记";
    new.GroupID = [[[self.noteCoverMArray lastObject]objectAtIndex:1]intValue];
    new.isFirst = YES;
    [self.navigationController pushViewController:new animated:YES];
}

- (void)createSQL
{
    self.dataWorker = [[NoteSQL alloc] init];
    [self.dataWorker createDB];
    [self.dataWorker createGroupTable:@"create table if not exists GroupTable (GroupTitle text,GroupID int)"];
    [self.dataWorker createGroupTable:@"create table if not exists NoteTable (GroupID int,NoteID int,NoteTitle text,NoteText text,NoteImage text, Date text)"];
    [self.dataWorker createGroupTable:@"create table if not exists RemindTable (id int,time text,message text)"];
}

- (void)viewWillAppear:(BOOL)animated
{
    //表1的所有内容
    self.noteCoverMArray = [self.dataWorker selectGroupData];
    //表3的所有内容
    self.remindCoverMArray = [self.dataWorker selectData];
    
//    //======================= test View ========================
//    NSArray *testArray = [NSArray arrayWithObjects:@"aaa", @"1",nil];
//    NSArray *testArray1 = [NSArray arrayWithObjects:@"bbb", @"2",nil];
//    //表1的所有内容
//    [self.noteCoverMArray addObject:testArray];
//    [self.noteCoverMArray addObject:testArray1];
//    //表3的所有内容
//  //  self.remindCoverMArray = [self.dataWorker selectData];
//    //======================= test View ========================

    
    
    if (self.noteCoverMArray.count == 0){
        // 0
        self.main = [[MainView alloc]initWithFrame:CGRectMake(8, 5, self.view.frame.size.width-16, 50)];
        [self.main addView:0];
        
        self.main.imageView.image = [UIImage imageNamed:@"bijiben.png"];
        [self.main.btn addTarget:self action:@selector(showGroup) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.main];
        
        
    }else if(self.noteCoverMArray.count == 1){
        // 1
        self.main = [[MainView alloc]initWithFrame:CGRectMake(8, 5, self.view.frame.size.width-16, 120)];
        [self.main addView:1];
        
        self.main.leftMessage.text = [[self.noteCoverMArray lastObject]objectAtIndex:0];
        
        self.main.label.text = @"笔记";
        
        self.main.imageView.image = [UIImage imageNamed:@"bijiben.png"];
        
        [self.main.btn addTarget:self action:@selector(showGroup) forControlEvents:UIControlEventTouchUpInside];
        
        [self.main.leftBtn addTarget:self action:@selector(addBijiAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.main];
    }else{
        // 2
        self.main = [[MainView alloc]initWithFrame:CGRectMake(8, 5, self.view.frame.size.width-16, 150)];
        [self.main addView:2];
        
        self.main.leftMessage.text = [[self.noteCoverMArray lastObject]objectAtIndex:0];
        self.main.rightMessage.text = [[self.noteCoverMArray objectAtIndex:self.noteCoverMArray.count-2]objectAtIndex:0];
        
        self.main.label.text = @"笔记";
        self.main.rlabel.text = @"笔记";
        
        self.main.imageView.image = [UIImage imageNamed:@"bijiben.png"];
        
        [self.main.btn addTarget:self action:@selector(showGroup) forControlEvents:UIControlEventTouchUpInside];
        [self.main.rightBtn addTarget:self action:@selector(addSecondAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.main.leftBtn addTarget:self action:@selector(addBijiAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.main];
    }
    
    
    
    
    
    
    if (self.remindCoverMArray.count == 0){
        // 提醒0
        self.remind = [[MainView alloc]initWithFrame:CGRectMake(8, 175 , self.view.frame.size.width-16, 50)];
        [self.remind addView:0];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40,6, 50, 30)];
        label.text = @"提醒";
        label.textColor = [UIColor whiteColor];
        [self.remind addSubview:label];
        
        self.remind.imageView.image = [UIImage imageNamed:@"remind.png"];
        self.remind.imageView.frame = CGRectMake(7, 5, 30, 35);
        [self.remind.btn addTarget:self action:@selector(showRemind) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.remind];
    }
    else if (self.remindCoverMArray.count == 1){
        // 提醒1
        self.remind = [[MainView alloc]initWithFrame:CGRectMake(8, 145 , self.view.frame.size.width-16, 120)];
        [self.remind addView:1];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40,6, 50, 30)];
        label.text = @"提醒";
        label.textColor = [UIColor whiteColor];
        [self.remind addSubview:label];
        
        self.remind.imageView.image = [UIImage imageNamed:@"remind.png"];
        
        self.remind.imageView.frame = CGRectMake(7, 5, 30, 35);
        
        
        self.remind.leftMessage.text = [[self.remindCoverMArray lastObject]objectForKey:@"message"];
        
        self.remind.leftTime.text = [[self.remindCoverMArray lastObject]objectForKey:@"time"];
        self.remind.label.text = @"提醒";
        
        [self.remind.btn addTarget:self action:@selector(showRemind) forControlEvents:UIControlEventTouchUpInside];
        [self.remind.leftBtn addTarget:self action:@selector(addRemindAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.remind];

    }else{
        // 提醒2
        self.remind = [[MainView alloc]initWithFrame:CGRectMake(8, 145 , self.view.frame.size.width-16, 120)];
        [self.remind addView:2];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40,6, 50, 30)];
        label.text = @"提醒";
        label.textColor = [UIColor whiteColor];
        [self.remind addSubview:label];
        
        self.remind.imageView.image = [UIImage imageNamed:@"remind.png"];
        self.remind.imageView.frame = CGRectMake(7, 5, 30, 35);
        
        self.remind.leftMessage.text = [[self.remindCoverMArray lastObject]objectForKey:@"message"];
        self.remind.leftTime.text = [[self.remindCoverMArray lastObject]objectForKey:@"time"];
        self.remind.label.text = @"提醒";
        
        self.remind.rightMessage.text = [[self.remindCoverMArray objectAtIndex:self.remindCoverMArray.count-2]objectForKey:@"message"];
        self.remind.rightTime.text = [[self.remindCoverMArray objectAtIndex:self.remindCoverMArray.count-2]objectForKey:@"time"];
        self.remind.rlabel.text = @"提醒";
        
        [self.remind.btn addTarget:self action:@selector(showRemind) forControlEvents:UIControlEventTouchUpInside];
        [self.remind.leftBtn addTarget:self action:@selector(addRemindAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.remind.rightBtn addTarget:self action:@selector(addSecondRemindAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.remind];
    }
}



#define mark =================闹钟按键响应方法=================
// 闹钟页面跳转到二级页面（添加按键）
- (void)showRemind
{
    //跳入到闹钟界面
    ClockViewController *clockVC = [[ClockViewController alloc]init];
    [self.navigationController pushViewController:clockVC animated:YES];
}
// 点击提醒调用（闹钟左侧按键）
- (void)addRemindAction:(id)sender
{
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * localNotification in allLocalNotification){
        NSString * alarmValue=[localNotification.userInfo objectForKey:@"AlarmKey"];
        if ([[[self.remindCoverMArray lastObject]objectForKey:@"time"] isEqualToString:alarmValue]){
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
    RemindViewController *remind = [[RemindViewController alloc]init];
    
    remind.list = [self.remindCoverMArray lastObject];
    remind.rowID = [[[self.remindCoverMArray lastObject]objectForKey:@"id"]intValue];
    
    [self.dataWorker deleteData:remind.rowID];
    [self.navigationController pushViewController:remind animated:YES];
}

// 点击右侧提醒调用
- (void)addSecondRemindAction:(id)sender
{
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * localNotification in allLocalNotification){
        NSString * alarmValue=[localNotification.userInfo objectForKey:@"AlarmKey"];
        if ([[[self.remindCoverMArray objectAtIndex:self.remindCoverMArray.count-2]objectForKey:@"time"] isEqualToString:alarmValue]){
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
    RemindViewController *remind = [[RemindViewController alloc]init];
    
    remind.list = [self.remindCoverMArray objectAtIndex:self.remindCoverMArray.count-2];
    remind.rowID = [[[self.remindCoverMArray objectAtIndex:self.remindCoverMArray.count-2]objectForKey:@"id"]intValue];
    
    [self.dataWorker deleteData:remind.rowID];
    [self.navigationController pushViewController:remind animated:YES];
}





#define mark =================笔记按键响应方法=================
// 笔记本页面跳转到二级页面（添加按键）
- (void)showGroup
{
    GroupViewController *groupVC = [[GroupViewController alloc]init];
    [self.navigationController pushViewController:groupVC animated:YES];
}
// 点击笔记调用（笔记左侧响应方法）
- (void)addBijiAction:(id)sender
{
    NoteViewController *noteVC = [[NoteViewController alloc] init];
    noteVC.GroupID = [[[self.noteCoverMArray lastObject]objectAtIndex:1]intValue];
    noteVC.title = @"笔记";
    [self.navigationController pushViewController:noteVC animated:YES];
}
// 点击右边按钮调用的方法（笔记右侧响应方法）
- (void)addSecondAction:(id)sender
{
    NoteViewController *noteVC = [[NoteViewController alloc] init];
    noteVC.GroupID = [[[self.noteCoverMArray objectAtIndex:self.noteCoverMArray.count-2]objectAtIndex:1]intValue];
    noteVC.title = @"笔记";
    [self.navigationController pushViewController:noteVC animated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 将所有添加上的试图remove掉
- (void)viewDidDisappear:(BOOL)animated
{
    [self.main removeFromSuperview];
    [self.remind removeFromSuperview];
}

@end
